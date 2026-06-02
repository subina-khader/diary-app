import 'package:flutter/material.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  List<String> imagePath = [
    "assets/images/templates/plain.jpeg",
    "assets/images/templates/top.jpeg",
    "assets/images/templates/doubletop.jpeg",
    "assets/images/templates/bottom.jpeg",
    "assets/images/templates/doublebottom.jpeg",
    "assets/images/templates/left.jpeg",
    "assets/images/templates/right.jpeg",
    "assets/images/templates/image.jpeg",
  ];
  List<int> maximum = [0, 3, 6, 3, 6, 5, 5, 12];
  int count = 1;
  Widget openDialogueBox(index) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    "Photo Count",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    "How many photos would you like to add?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 29),
                  StatefulBuilder(
                    builder: (context, dialogSetState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              dialogSetState(() {
                                if (count > 1) count--;
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),

                          Text(
                            "$count",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              dialogSetState(() {
                                if (count < maximum[index]) count++;
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Max : ${maximum[index]} photos",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.pink.shade200,
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shadowColor: MaterialStateProperty.all(Colors.grey),

                    // elevation: MaterialStateProperty.all( 2),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: Text("Cancel", style: TextStyle(fontSize: 15)),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.pink.shade200,
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shadowColor: MaterialStateProperty.all(Colors.grey),

                    // elevation: MaterialStateProperty.all( 2),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      "templateindex": index,
                      "count": count,
                    });
                  },

                  child: Text("Apply", style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewDiary()));
              },
              child: Icon(Icons.close, color: Colors.brown),
            ),
            Text(
              "Templates",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Caveat",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 19,
            crossAxisSpacing: 19,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async{
                count = 1;
                if (index == 0) {
                  Navigator.pop(context, {"templateindex": 0, "count": 0});
                  return;
                }

                final result = await showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(child: openDialogueBox(index));
                  },
                );
                if (result != null) {
                  Navigator.pop(context, result);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: Image.asset(
                      imagePath[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
