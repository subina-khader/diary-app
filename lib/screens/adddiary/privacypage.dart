import 'package:diary/models/diary_model.dart';
import 'package:diary/providers/diaryprovider.dart';
import 'package:diary/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:diary/widgets/button_adddiary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_screen.dart';

class PrivacyPage extends ConsumerStatefulWidget {
  final PageController controller;
  const PrivacyPage({super.key, required this.controller});

  @override
  ConsumerState<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  bool isPrivate = false;
  bool isObscure = false;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final privacyProvider = ref.read(diaryProvider.notifier);
    final state = ref.watch(diaryProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
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
                    "Privacy settings",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    "Keep your thoughts safe",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 19),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isPrivate ? Colors.brown : Colors.pink.shade50,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(13),

                      leading: CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.lock_outline_rounded),
                      ),
                      title: Text(
                        "Password Protected",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        "Secure your diary with a password",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      trailing: Switch(
                        activeTrackColor: Colors.brown,
                        value: isPrivate,
                        onChanged: (value) {
                          setState(() {
                            isPrivate = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  isPrivate
                      ? TextField(
                          controller: _passwordController,
                          textAlign: TextAlign.center,
                          obscureText: isObscure,
                          obscuringCharacter: '*',

                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            hintText: "Enter password",
                            hintStyle: TextStyle(
                              fontSize: 19,
                              fontFamily: "Caveat",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            fillColor: Colors.pink.shade50,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),

                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text(
                            "Preview",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,

                            decoration: BoxDecoration(
                              color: Color(state.themes!.color),
                              // color: Colors.brown,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.name,
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontFamily: "Caveat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    state.category!.category,
                                    style: TextStyle(
                                      // fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),

                                  isPrivate
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Protected",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                label: "Create Diary",
                onPressed: () async {
                  privacyProvider.updatePassword(
                    isPrivate,
                    _passwordController.text,
                  );
                  DiaryModel diary = DiaryModel(
                    name: state.name,
                    themeValue: state.themes!.color,
                    themeName: state.themes!.colorName,
                    categoryIconPath: state.category!.imagePath,
                    categoryName: state.category!.category,
                    isPrivate: state.isPrivate,
                    password: state.password,
                  );
                  try {
                    await DatabaseHelper.instance.insertDiary(diary);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Successfully created diary")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Diary creation failed")),
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
