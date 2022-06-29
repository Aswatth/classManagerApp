import 'package:class_manager/AppPages/FeesPages/fee_list.dart';
import 'package:class_manager/AppPages/FeesPages/fees_details.dart';
import 'package:class_manager/AppPages/SessionPages/session_list.dart';
import 'package:class_manager/AppPages/StudentPages/student_profile.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  StudentModel studentModel;
  StudentHome({Key? key,required this.studentModel}) : super(key: key);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  int _selectedIndex = 0;

  PageController _pageController = PageController();
  List<Widget> _screens = [
  ];

  void onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  void onItemTapped(int index){
    _pageController.jumpToPage(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screens = [
      StudentProfile(studentModel: widget.studentModel),
      SessionList(studentModel: widget.studentModel),
      FeesDetails(studentModel: widget.studentModel)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onItemTapped,
        //selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Profile"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                //color: _selectedIndex==1?Colors.blueAccent:Colors.grey,
              ),
              label: "Session list"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
                //color: _selectedIndex==1?Colors.blueAccent:Colors.grey,
              ),
              label: "Fees details"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.show_chart,
                //color: _selectedIndex==1?Colors.blueAccent:Colors.grey,
              ),
              label: "Performance"
          ),
        ],
      ),
    );
  }
}
