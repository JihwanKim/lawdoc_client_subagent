import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:subagent/src/utils/store.dart' as store;

class SubAgentImageProvider extends ChangeNotifier{

  _upload(String uploadURL, String path)async{

    await http.put(
      Uri.parse(uploadURL),
      headers: {
        'Content-Type': "image/${path.split(".").last}",
        'Accept': "*/*",
        'Content-Length': File(path).lengthSync().toString(),
        'Connection': 'keep-alive',
      },
      body: File(path).readAsBytesSync(),
    );
  }

  Future<String> upload(String path,[ Function onSendProgress]) async  {
    final dio = Dio();
    Response uploadURLResponse = await dio.get(
      "https://xqah3vdash.execute-api.ap-northeast-2.amazonaws.com/release",
      queryParameters: {
        "type":"upload",
        "extension":path.split(".").last
      }
    );
    final uploadURL = uploadURLResponse.data['url'];

    final s3key = uploadURLResponse.data['key'];
    await _upload(uploadURL, path);

    return s3key;
  }

  Future<String> getByS3Key(String s3key) async{
    final dio = Dio();
    Response uploadURLResponse = await dio.get(
        "https://xqah3vdash.execute-api.ap-northeast-2.amazonaws.com/release",
        queryParameters: {
          "type":"download",
          "file_uri":s3key
        }
    );
    return uploadURLResponse.data['url'];
  }
}