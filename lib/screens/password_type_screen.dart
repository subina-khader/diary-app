import 'dart:math';

import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/screens/view_diary.dart';
import 'package:diary/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/selectdiary_provider.dart';
import 'adddiary/edit_diaryentry.dart';

class PasswordTypeScreen extends ConsumerStatefulWidget {
  const PasswordTypeScreen({super.key});

  @override
  ConsumerState<PasswordTypeScreen> createState() => _PasswordTypeScreenState();
}

class _PasswordTypeScreenState extends ConsumerState<PasswordTypeScreen> {
  late TextEditingController _passwordController;

  bool _isVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDiary = ref.read(SelectedDiaryProvider);
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 47),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.lock, size: 33),
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  Text(
                    "Secret Diary",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    "This diary is protected. Enter your password to continue.",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.pink.shade50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              textAlign: TextAlign.center,
                              obscuringCharacter: "*",
                              obscureText: !_isVisible,
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Caveat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            child: _isVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.brown),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (selectedDiary == null) return;
                      bool check = await DatabaseHelper.instance.checkPassword(
                        selectedDiary.id!,
                        _passwordController.text.trim(),
                      );
                      if (check) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ViewDiary()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Wrong Password")),
                        );
                      }
                    },
                    child: Text(
                      "Unlock",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
