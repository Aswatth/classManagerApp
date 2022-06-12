import 'package:class_manager/AppPages/class_details_page.dart';
import 'package:class_manager/AppPages/student_list.dart';
import 'package:class_manager/database_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StudentListPage())
                    );
                  },
                  child: Card(
                    child: Center(child: Text("Student details"),),
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClassDetailsPage())
                    );
                  },
                  child: Card(
                    child: Center(child: Text("Class details"),),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(child: TextButton(
          onPressed: () {  },
          child: Card(
            child: Center(child: Text("Fees details"),),
          ),
        ),),
        // TEMP drop DB
        Flexible(child:TextButton(
          onPressed: (){
            DatabaseHelper.instance.dropDB();
          }, child: Text("Drop DB"),
        ))
      ],
    );
  }
}
