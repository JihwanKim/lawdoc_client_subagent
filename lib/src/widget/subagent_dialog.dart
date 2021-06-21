
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogResponse{
  OK, CANCEL
}

class SubAgentDialog extends StatefulWidget {
  final String title;
  final String okButtonContent;
  final String cancelButtonContent;
  final Function onOkButtonClick;

  const SubAgentDialog(
      {Key key,
        this.title,
        this.okButtonContent,
        this.cancelButtonContent,
        this.onOkButtonClick})
      : super(key: key);
  @override
  _SubAgentDialogState createState() => _SubAgentDialogState();
}

class _SubAgentDialogState extends State<SubAgentDialog> {
  bool _isRun = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text(widget.title),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: _isRun
              ? CupertinoActivityIndicator()
              : Text(widget.okButtonContent),
          onPressed: () async {
            setState(() {
              _isRun = true;
            });
            await widget.onOkButtonClick();
            setState(() {
              _isRun = false;
            });
            Navigator.pop(context, DialogResponse.OK);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            widget.cancelButtonContent,
            style: TextStyle(color: Colors.redAccent),
          ),
          onPressed: () {
            Navigator.pop(context, DialogResponse.CANCEL);
          },
        )
      ],
    );
  }
}
