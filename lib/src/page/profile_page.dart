
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subagent/src/view/profile_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: ProfileView(),
        ));
  }
}
