import 'package:flutter/material.dart';

class Utils {
  static Function showSnackBar =
      (String content, BuildContext context, [int seconds = 2]) async {
    final snackBar = SnackBar(
      content: Text('$content'),
      duration: Duration(seconds: seconds),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    await Future.delayed(Duration(seconds: seconds));
  };
}
