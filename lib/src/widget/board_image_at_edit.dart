import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/subagent_image_provider.dart';

class BoardImageAtEdit extends StatefulWidget {
  final Function onRemove;
  final Function onUpload;
  final Function completeUpload;
  final String path;

  const BoardImageAtEdit(
      {Key key, this.path, this.onRemove, this.onUpload, this.completeUpload})
      : super(key: key);
  @override
  _BoardImageAtEditState createState() => _BoardImageAtEditState();
}

class _BoardImageAtEditState extends State<BoardImageAtEdit> {
  String _networkURL;
  String _s3Key;
  String _path;
  

  readImageInfo(context, String path, String s3key) async {
    if (s3key != null) {
      if(_networkURL == null){
        final prov = Provider.of<SubAgentImageProvider>(context, listen: false);
        _networkURL = await prov.getByS3Key(s3key);
      }
      return Image.network(
        _networkURL,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      return Image.file(File(path));
    }
    // Completer<ui.Image> completer = new Completer<ui.Image>();
    // image.image
    //     .resolve(new ImageConfiguration())
    //     .addListener(new ImageStreamListener((ImageInfo image, bool _) {
    //   completer.complete(image.image);
    // }));
    // ui.Image info = await completer.future;
    // int width = info.width;
    // int height = info.height;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.path.contains("data") || widget.path.contains("Application")){
      final imageProv =
      Provider.of<SubAgentImageProvider>(context, listen: false);
      imageProv.upload(widget.path, (sent, total) {}).then((value) {
        _s3Key = value;
        Future.delayed(Duration(seconds: 1),(){
          widget.onUpload(value);
          setState(() {});
        });

      }).catchError((onError) => {});
    }

    _path = (widget.path.contains("data") || widget.path.contains("Application")) ? widget.path : null;
    _s3Key = !(widget.path.contains("data") || widget.path.contains("Application")) ? widget.path : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: image.width,
      // height: image.height,
      child: Stack(
        children: [
          FutureBuilder(
            future: readImageInfo(context, _path, _s3Key),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: snapshot.data,
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (_s3Key != null) {
                  widget.onRemove();
                }
              },
              child: _s3Key == null
                  ? Container(
                      padding: EdgeInsets.all(4.0),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator())
                  : Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: Colors.redAccent,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
