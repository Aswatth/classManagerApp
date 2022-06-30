import 'package:class_manager/Model/performance.dart';
import 'package:class_manager/Model/student.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PerformancePage extends StatefulWidget {
  StudentModel studentModel;
  String subjectName;
  PerformancePage({Key? key,required this.studentModel,required this.subjectName}) : super(key: key);

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {

  List<PerformanceModel> _testList = [];

  final TextEditingController _marksScoredController = TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  double _marksScored = 0;
  double _totalMarks = 0;
  DateTime _selectedTestDate = DateTime.now();
  bool _isTuitionTest = false;

  List<FlSpot> _chartData = [];

  Future<void> getPerformance()async{
    List<PerformanceModel> temp = await PerformanceHelper.instance.getPerformanceList(widget.studentModel.id!, widget.subjectName);

    setState(() {
      _testList = temp;
      _chartData.clear();
      //_testList.forEach((element) {print(element.toString());});
      _testList.forEach((element) {
        print(element.toString());
        _chartData.add(FlSpot(_testList.indexOf(element).toDouble() + 1, (element.marksScored/element.maxMarks)*100));
      });
    });
  }

  Widget marksScoreField() {
    return TextFormField(
      controller: _marksScoredController,
      keyboardType: TextInputType.number,
      validator: (value){
        if(value!.isEmpty){
          return "Marks scored cannot be empty";
        }
        else if(double.parse(value!) < 0){
          return "Marks cannot be < 0";
        }
      },
      decoration: InputDecoration(
        icon: Icon(Icons.percent),
        labelText: 'Marks scored',
        suffix: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _marksScoredController.clear();
            });
          },
        )
      ),
      onChanged: (_){
        setState(() {
          _marksScored = _.isEmpty?0:double.parse(_);
        });
      },
      onSaved: (_){
        setState(() {
          _marksScored = _!.isEmpty?0:double.parse(_!);
        });
      },
    );
  }

  Widget totalMarksField(){
    return TextFormField(
      controller: _totalMarksController,
      keyboardType: TextInputType.number,
      validator: (value){
        if(value!.isEmpty){
          return "Marks scored cannot be empty";
        }
        else if(double.parse(value!) < 0){
          return "Marks cannot be < 0";
        }
      },
      decoration: InputDecoration(
        icon: Icon(Icons.assignment_turned_in),
        labelText: 'Total marks',
        suffix: IconButton(
        icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _totalMarksController.clear();
            });
          },
        ),
      ),
      onChanged: (_){
        setState(() {
          _totalMarks = _.isEmpty?0:double.parse(_!);
        });
      },
      onSaved: (_){
        setState(() {
          _totalMarks = _!.isEmpty?0:double.parse(_!);
        });
      },
    );
  }

  Widget testDateField() {
    return StatefulBuilder(
      builder: (context, setStateDate){
        return DateTimePicker(
          controller: _testDateController,
          type: DateTimePickerType.date,
          dateMask: 'dd-MMM-yyyy',
          validator: (value){
            if(value!.isEmpty){
              return 'Test date cannot be empty';
            }else{
              return null;
            }
          },
          decoration: InputDecoration(
            icon: Icon(Icons.today),
            labelText: "Test date",
            suffixIcon: IconButton(
              icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
              onPressed: (){
                setStateDate(() {
                  _testDateController.clear();
                });
              },
            ),
          ),
          firstDate: DateTime(1999),
          lastDate: DateTime(2100),
          onSaved: (value){
            setState(() {
              if(value.runtimeType is String){
                _selectedTestDate = DateFormat("dd-MMM-yyyy").parse(value!);
              }
              else {
                _selectedTestDate = DateTime.parse(value!);
              }
            });
          },
        );
      },
    );
  }

  _add()async{
    _formKey.currentState!.save();

    PerformanceModel performanceModel = PerformanceModel.createNew(performanceStudentId: widget.studentModel.id!, performanceSubjectName: widget.subjectName, testDate: _selectedTestDate, marksScored: _marksScored, maxMarks: _totalMarks, isTuitionTest: _isTuitionTest);
    bool isSuccessful = await PerformanceHelper.instance.insert(performanceModel);

    if(isSuccessful){
      _testDateController.clear();
      _marksScoredController.clear();
      _totalMarksController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Test created successfully!"),
      ),);

      getPerformance();

      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Test already exists!"),
      ),);
    }
  }

  _delete(PerformanceModel performanceModel)async{
    bool isSuccessful = await PerformanceHelper.instance.delete(performanceModel);

    if(isSuccessful){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Deleted test successfully!"),
      ),);

      getPerformance();
    }
  }

  _update(PerformanceModel oldPerformanceModel)async{
    _formKey.currentState!.save();

    PerformanceModel newPerformance = PerformanceModel(testId: oldPerformanceModel.testId,performanceStudentId: widget.studentModel.id!, performanceSubjectName: widget.subjectName, testDate: _selectedTestDate, marksScored: _marksScored, maxMarks: _totalMarks, isTuitionTest: _isTuitionTest);

    bool isSuccessful = await PerformanceHelper.instance.update(oldPerformanceModel , newPerformance);

    if(isSuccessful){
      _testDateController.clear();
      _marksScoredController.clear();
      _totalMarksController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Updated test successfully!"),
      ),);

      getPerformance();

      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Test already exists!"),
      ),);
    }
  }
  
  edit(PerformanceModel performanceModel){
    setState(() {
      _marksScoredController.text = performanceModel.marksScored.toString();
      _totalMarksController.text = performanceModel.maxMarks.toString();
      _testDateController.text = performanceModel.testDate.toString();
      _isTuitionTest = performanceModel.isTuitionTest;
    });

    popUp("Edit",performanceModel);
  }
  
  popUp(String buttonText, PerformanceModel? oldPerformanceModel){
    Alert(
      context: context,
      title: buttonText + " test",
      content: StatefulBuilder(
        builder: (context, setStateAlert){
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                marksScoreField(),
                totalMarksField(),
                testDateField(),
                ListTile(
                title: Text("Tution test: "),
                trailing: Checkbox(
                  value: _isTuitionTest,
                  onChanged: (value){
                    setStateAlert(() {
                      print(_isTuitionTest);
                      _isTuitionTest = value!;
                      print(_isTuitionTest);
                    });
                  },
                )
            )
              ],
            ),
          );
        },
      ),
        buttons: [
          DialogButton(
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  if(buttonText.toUpperCase() == "ADD"){
                    _add();
                  }
                  else if(buttonText.toUpperCase() == "EDIT"){
                    _update(oldPerformanceModel!);
                  }
                });
              }
            },
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget chartTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget widget = Text(value.toInt().toString());

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      angle: 0,
      child: widget
    );
  }

  Widget lineChart(){
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 300,
          height: 300,
          child: LineChart(
            LineChartData(
                minY: 0,
                maxY: 100,
                titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        )
                    ),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false,
                        )
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: 1,
                            getTitlesWidget: chartTitleWidgets
                        )
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            reservedSize: 50,
                            showTitles: true,
                            getTitlesWidget: chartTitleWidgets
                        )
                    )
                ),

                lineBarsData: [
                  LineChartBarData(
                      spots: _chartData.isEmpty?[FlSpot(0, 0)]:_chartData,
                      isCurved: true,
                      belowBarData: BarAreaData(
                          show: true
                      )
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget testListWidget(){
    return ListView.builder(
      itemCount: _testList.length,
      itemBuilder: (context, index){
        PerformanceModel performance = _testList[index];
        return ListTile(
          leading: Text((index+1).toString()),
          title: Text("Scored:\t ${performance.marksScored} / ${performance.maxMarks}"),
          subtitle: Text(DateFormat("dd-MMM-yyyy").format(performance.testDate)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              setState(() {
                _delete(performance);
              });
            },
          ),
          onLongPress: (){
            setState(() {
              edit(performance);
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPerformance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subjectName} performance"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              lineChart(),
              Column(
                children: [
                  IconButton(
                      onPressed: (){
                        popUp("Add",null);
                      },
                      icon: Icon(Icons.add_chart)
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: (){
                      getPerformance();
                    },
                  )
                ],
              )
            ],
          ),
          Divider(color: Colors.black87,),
          Expanded(child: testListWidget())
        ],
      ),
    );
  }
}
