import 'package:diary/models/category_model.dart';
import 'package:diary/providers/diaryprovider.dart';
import 'package:flutter/material.dart';
import 'package:diary/widgets/button_adddiary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPage extends ConsumerStatefulWidget {
  final PageController controller;
  const CategoryPage({super.key, required this.controller});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final List<CategoryModel> category = [
    CategoryModel(
      imagePath: "assets/icons/icons8-diary-100.png",
      category: "Daily Journal",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-aeroplane-48.png",
      category: "Travel Memories",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-moon-40.png",
      category: "Dream Journal",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-heart-64.png",
      category: "Gratitude Notes",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-fitness-48.png",
      category: "Fitness Tracker",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-secret-64.png",
      category: "Secret Diary",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-cooking-book-48.png",
      category: "Recipe Collection",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-creativity-48.png",
      category: "Creative Ideas",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-notepad-94.png",
      category: "Quick Notes",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-bullet-list-64.png",
      category: "Bucket List",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-emotion-64.png",
      category: "Emotion Log",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-reading-94.png",
      category: "Reading Log",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-planner-94.png",
      category: "Study Planner",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-alzheimer-50.png",
      category: "Mood Tracker",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-profit-growth-64.png",
      category: "Self Growth",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-pray-skin-type-4-48.png",
      category: "Prayer Journal",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-relationship-100.png",
      category: "Relationship Diary",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-office-48.png",
      category: "Work Notes",
    ),
    CategoryModel(
      imagePath: "assets/icons/icons8-memories-48.png",
      category: "Memory Book",
    ),
  ];

  int isSelected = -1;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.read(diaryProvider.notifier);
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
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    "What type of diary?",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    "Select a category",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 19),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: 19,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          title: category[index].category,
                          givenicon: Image.asset(category[index].imagePath),
                          isSelect: isSelected == index,
                          onTap: () {
                            setState(() {
                              isSelected = index;
                            });
                          },
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
    if(isSelected==-1){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a category"),));

    }
    else {
      categoryProvider.updateCategory(category[isSelected]);
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

class CategoryCard extends StatelessWidget {
  final String title;
  final Image givenicon;
  final bool isSelect;
  final VoidCallback onTap;
  CategoryCard({
    required this.title,
    required this.givenicon,
    required this.isSelect,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: isSelect ? Colors.pink.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelect ? Colors.brown : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40, width: 35, child: givenicon),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
