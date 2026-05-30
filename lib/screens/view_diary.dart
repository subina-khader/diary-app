import 'dart:math';

import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/selectdiary_provider.dart';
import 'adddiary/edit_diaryentry.dart';
class ViewDiary extends ConsumerStatefulWidget {
  const ViewDiary({super.key});

  @override
  ConsumerState<ViewDiary> createState() => _ViewDiaryState();
}

class _ViewDiaryState extends ConsumerState<ViewDiary> {
  late TextEditingController _contentController;
  late PageController _pageController;
  List <DiaryEntryModel> entries=[];
  int currentPage=0;
  Future<int?> datePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
    );
    if (pickedDate != null) {
      final index= entries.indexWhere((entry)=>entry.date == DateFormat('yyyy-MM-dd').format(pickedDate));
      return index;
    }
    return null;
  }

  @override
  void dispose(){
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    _contentController=TextEditingController();
    _pageController=PageController();
    loadEntries();
  }
  void loadEntries()async{

    final diary=ref.read(SelectedDiaryProvider);
    if(diary == null) return ;
     entries= await DatabaseHelper.instance.getAllEntriesByDiaryId(diary.id!);
     setState(() {

     });

  }
  @override
  Widget build(BuildContext context) {
    final selectedDiary = ref.read(SelectedDiaryProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor:Colors.pink.shade50 ,
        automaticallyImplyLeading: true,
        title: Align(alignment:Alignment.centerRight,child: IconButton(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.brown,))),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,10,20,30.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,


          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context,index){
                      return Container(
                        child:Column(
                          children: [
                            Row(
                              children: [
                                Text(DateFormat.yMMMd().format(
                                  DateTime.parse(entries[index].date),
                                ),                      style: TextStyle(fontSize: 20, fontFamily: "Caveat"),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async{
                                     int? index=await datePicker();
                                     if (index!=null )

                                           _pageController.animateToPage(index, duration: Duration(milliseconds: 23), curve: Curves.easeIn);
                                  },
                                  child: Icon(Icons.calendar_month, size: 19),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            Expanded(
                              child:
                                  SingleChildScrollView(child: Text(entries[index].content,style: TextStyle(
                                      color: Colors.black, fontFamily: "Caveat",fontSize: 16,
                                  ),)),


                            ),

                          ],
                        ),
                      );
                    },
                    controller: _pageController,
                    onPageChanged: (index){
                      setState(() {
                        currentPage=index;
                      });

                    },





                  ),
                ),

              ],
            ),
          )      ),
      ),
      floatingActionButton: FloatingActionButton(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),backgroundColor:Colors.brown,foregroundColor:Colors.white,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>EditDiaryentry()));},child: Icon(Icons.edit),),
    );
  }
}
