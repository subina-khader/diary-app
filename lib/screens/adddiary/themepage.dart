import 'package:diary/models/theme_model.dart';
import 'package:diary/providers/diaryprovider.dart';
import 'package:flutter/material.dart';
import 'package:diary/widgets/button_adddiary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemePage extends ConsumerStatefulWidget {
  final PageController controller;

  const ThemePage({super.key, required this.controller});

  @override
  ConsumerState<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends ConsumerState<ThemePage> {
  final List<ThemeModel> themes = [
    ThemeModel(color: 0xFF6D4C41, colorName: "Leather"),
    ThemeModel(color: 0xFFE91E63, colorName: "Floral"),
    ThemeModel(color: 0xFFA1887F, colorName: "Vintage"),
    ThemeModel(color: 0xFFF8BBD0, colorName: "Pastel"),
    ThemeModel(color: 0xFFFFF9C4, colorName: "Notebook"),
    ThemeModel(color: 0xFF212121, colorName: "Dark"),
    ThemeModel(color: 0xFF4FC3F7, colorName: "SkyBlue"),
    ThemeModel(color: 0xFF81C784, colorName: "Mint"),
    ThemeModel(color: 0xFFFFAB91, colorName: "Peach"),

    // ThemeModel(color: const Color(0xFFFFAB91), colorName: "Peach"),
  ];
  int isSelected = -1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(diaryProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 9,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Choose a cover",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Pick your favorite style",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 19),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 40,
                        mainAxisSpacing: 15,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = index;
                            });
                          },
                          child: ThemeCard(
                            isSelected: isSelected == index,

                            colors: themes[index].color,
                            name: themes[index].colorName,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            CustomBotton(
              fillcolor: Colors.white,
              fontcolor: Colors.brown,
              label: "Back",
              onPressed: () {
                widget.controller.previousPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            ),
            SizedBox(width: 18),
            CustomBotton(
              fillcolor: Colors.brown,
              fontcolor: Colors.white,
              label: "Continue",
              onPressed: () {
                // ThemeModel theme =ThemeModel(color: themes[isSelected].color, colorName: themes[isSelected].colorName);
                if(isSelected==-1){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a theme"),));

                }
                else{
                  themeProvider.updateTheme(themes[isSelected]);
                  widget.controller.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }

              },
            ),
          ],
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

class ThemeCard extends StatelessWidget {
  final bool isSelected;
  final int colors;
  final String name;
  const ThemeCard({
    super.key,
    required this.colors,
    required this.name,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  color: Color(colors),
                ),
              ),
              isSelected
                  ? Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.check, size: 16),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(height: 15),
        Text(name),
      ],
    );
  }
}
