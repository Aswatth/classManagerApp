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
                  onPressed: () {  },
                  child: Card(
                    child: Center(child: Text("Student details"),),
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {  },
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
        ),)
      ],
    );
  }
}
