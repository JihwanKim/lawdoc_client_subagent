import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/board_item.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/widget/board_image_at_edit.dart';

class BoardNewOrEditView extends StatefulWidget {
  final BoardItem boardItem;
  final BoardType boardType;

  const BoardNewOrEditView({Key key, this.boardType, this.boardItem})
      : super(key: key);
  @override
  _BoardNewOrEditViewState createState() => _BoardNewOrEditViewState();
}

class _BoardNewOrEditViewState extends State<BoardNewOrEditView> {
  bool _isAnonymous = true;
  TextEditingController _titleController;
  TextEditingController _contentController;
  List<String> _images;

  Future getImage() async {

    FilePickerResult result = await FilePicker.platform.pickFiles(type:FileType.image);
    if (result == null) {
      return;
    }

    if(result.files.length == 0){
      return;
    }
    final File file = File(result.files.single.path);

    setState(() {
      if (file != null) {
        _images.add(file.path);
      } else {
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAnonymous =
        widget.boardItem != null ? widget.boardItem.isAnonymous : true;
    _titleController = TextEditingController(
        text: widget.boardItem != null ? widget.boardItem.title : "");
    _contentController = TextEditingController(
        text: widget.boardItem != null ? widget.boardItem.content : "");
    _images = widget.boardItem != null ? widget.boardItem.images.toList() : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [buildBack(context)],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAnonymous(),
                  buildTitle(),
                  SizedBox(
                    height: 10,
                  ),
                  buildContent(),
                  SizedBox(
                    height: 10,
                  ),
                  buildImageList(),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            BoardSaveButton(
              onSave: () async {
                final prov = Provider.of<BoardProvider>(context, listen: false);
                final BoardItem boardItem = BoardItem(
                    widget.boardItem != null ? widget.boardItem.idx : null,
                    _titleController.text,
                    _contentController.text,
                    _images,
                    "test",
                    true,
                    _isAnonymous,
                    DateTime.now());
                await prov.save(widget.boardType, boardItem);
                return boardItem;
              },
            ),
          ],
        ),
      ],
    );
  }

  IconButton buildBack(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context, null);
      },
    );
  }

  Row buildAnonymous() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Checkbox(
            value: _isAnonymous,
            activeColor: widget.boardItem == null ? Colors.blue : Colors.grey,
            onChanged: (isCheck) {
              if(widget.boardItem == null ){
                setState(() {
                  _isAnonymous = isCheck;
                });
              }
            }),
        Text("익명"),
      ],
    );
  }

  Container buildImageList() {
    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.lightBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
            onPressed: () async {
              await getImage();
            },
          ),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: BoardImageAtEdit(
                    path: _images[index],
                    onRemove: () {
                      _images.removeAt(index);
                      setState(() {});
                    },
                    onUpload: (s3key){
                      _images[index] = s3key;
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextField buildTitle() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: "제목",
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
    );
  }

  TextFormField buildContent() {
    return TextFormField(
      controller: _contentController,
      minLines: 10,
      maxLines: 150,
      decoration: InputDecoration(
        labelText: "내용",
        labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ),
    );
  }
}

class BoardSaveButton extends StatefulWidget {
  final Function onSave;
  final Function onFail;

  const BoardSaveButton({Key key, this.onSave, this.onFail}) : super(key: key);
  @override
  _BoardSaveButtonState createState() => _BoardSaveButtonState();
}

class _BoardSaveButtonState extends State<BoardSaveButton> {
  bool _isRunSave = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        color: Colors.blueAccent,
        child: _isRunSave
            ? Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ))
            : Text("저장"),
        onPressed: () async {
          // run save!
          setState(() {
            _isRunSave = true;
          });
          final item = await widget.onSave();
          setState(() {
            _isRunSave = false;
          });
          if (item != null && item is BoardItem) {
            Navigator.pop(context, item);
          } else {
            widget.onFail();
          }
        },
      ),
    );
  }
}
