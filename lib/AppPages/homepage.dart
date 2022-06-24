import 'package:class_manager/AppPages/class_details.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("Student details"),
                ),
                Tab(
                  child: Text("Class details"),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
             Center(
               child: Text("Student Details"),
             ),
              ClassDetails(),
            ],
          )
        ));
  }
}
