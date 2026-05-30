import 'package:diary/models/diary_model.dart';
import 'package:diary/providers/diaryprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NamePage extends ConsumerStatefulWidget {
  final PageController controller;

  const NamePage({super.key, required this.controller});

  @override
  ConsumerState<NamePage> createState() => _NamePageState();
}

class _NamePageState extends ConsumerState<NamePage> {
  late final TextEditingController titleController;
  bool isTyping = false;

  void initState() {
    super.initState();
    titleController = TextEditingController();
  }

  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = ref.read(diaryProvider.notifier);
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 5,
            shadowColor: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  Text(
                    "Whats your diary called?",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Give you diary a special name",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 29),

                  TextField(
                    controller: titleController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          isTyping = true;
                        });
                      } else {
                        setState(() {
                          isTyping = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "My Beautiful Diary",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontFamily: "Caveat",
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.pink.shade100,
                          width: 2,
                        ),
                      ),
                      fillColor: Colors.pink.shade50,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 45,

            child: TextButton(
              style: ButtonStyle(
                backgroundColor: isTyping
                    ? MaterialStateProperty.all(Colors.brown)
                    : MaterialStateProperty.all(Colors.pink.shade100),
                foregroundColor: isTyping
                    ? MaterialStateProperty.all(Colors.white)
                    : MaterialStateProperty.all(Colors.blueGrey),
                shadowColor: MaterialStateProperty.all(Colors.grey),

                // elevation: MaterialStateProperty.all( 2),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () {

                  if(titleController.text.trim().isNotEmpty ){
                    titles.updateTitle(titleController.text);
                  widget.controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
                else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Diary name is required"),));

                  }


              },
              child: Text("Continue", style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
