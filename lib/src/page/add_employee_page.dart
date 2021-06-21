import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/view/add_employee_view.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AddEmployeeView(),
      ),
    );
  }
}