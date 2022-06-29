import 'package:class_manager/AppPages/StudentPages/student_list.dart';
import 'package:class_manager/AppPages/StudentPages/student_search.dart';
import 'package:class_manager/AppPages/backup.dart';
import 'package:class_manager/AppPages/class_details.dart';
import 'package:class_manager/AppPages/statistics_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  PageController _pageController = PageController();
  List<Widget> _screens = [
    StudentList(),
    StudentSearch(),
    ClassDetails(),
    StatisticsPage(),
    BackUp()
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
                Icons.list,
                //color: _selectedIndex==0?Colors.blueAccent:Colors.grey,
              ),
              label: "Student List"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.search,
                  //color: _selectedIndex==1?Colors.blueAccent:Colors.grey,
              ),
              label: "Search"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              label: "Class details"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: "Statistics"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: "Backup"
          ),
        ],
      ),
    );
  }
}
