import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/model/user_info.dart';
import 'package:subagent/src/provider/subagent_image_provider.dart';
import 'package:subagent/src/provider/user_provider.dart';
import 'package:subagent/src/utils/ui.dart';
import 'package:subagent/src/utils/utils.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserInfo _userInfo;
  TextEditingController _userNickEditingController;
  TextEditingController _phoneEditingController;
  TextEditingController _ownerLawyerEditingController;
  TextEditingController _officeEditingController;
  TextEditingController _branchEditingController;
  TextEditingController _bankAccountEditingController;

  bool _isRun = false;
  Widget _buildAppBar() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Card(
            color: Colors.blue,
            child: TextButton(
              child: _isRun
                  ? CupertinoActivityIndicator()
                  : Text(
                      "저장",
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () async {
                if (_isRun) {
                  Utils.showSnackBar(
                      "프로필 정보가 변경중입니다. 잠시 후 다시 시도해주십시오.", context, 1);
                }
                _userInfo.phoneNumber = _phoneEditingController.text;
                _userInfo.affiliationOffice = _officeEditingController.text;
                _userInfo.affiliationBranch = _branchEditingController.text;
                _userInfo.bankAccountInformation =
                    _bankAccountEditingController.text;

                final prov = Provider.of<UserProvider>(context, listen: false);
                setState(() {
                  _isRun = true;
                });
                await prov.save(_userInfo);
                setState(() {
                  _isRun = false;
                });
                Utils.showSnackBar("프로필 정보가 변경되었습니다.", context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          (_userInfo.profileS3Key == null)
              ? Container(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 300,
                      color: Colors.grey,
                    ),
                  ),
                )
              : (_userInfo.profileImgURL == null
                  ? Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()),
                    )
                  : Image.network(
                      _userInfo.profileImgURL,
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
                    )),
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () async {
                final imgProv =
                    Provider.of<SubAgentImageProvider>(context, listen: false);
                FilePickerResult result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                final length = await File(result.files.single.path).length();
                setState(() {
                  _userInfo.profileImgURL = null;
                });
                final s3key = await imgProv.upload(result.files.single.path);
                _userInfo.profileS3Key = s3key;
                _userInfo.profileImgURL = await imgProv.getByS3Key(s3key);
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserNick() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _userNickEditingController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "이름",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberChange() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _phoneEditingController,
              decoration: InputDecoration(
                labelText: "핸드폰 번호",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerLawyer() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _ownerLawyerEditingController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "소속변호사",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeChange() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _officeEditingController,
              decoration: InputDecoration(
                labelText: "소속 사무실",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchChange() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _branchEditingController,
              decoration: InputDecoration(
                labelText: "소속 지회",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankAccountChange() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _bankAccountEditingController,
              decoration: InputDecoration(
                labelText: "계좌 정보",
                labelStyle: TextStyle(color: UI.TEXT_BLACK_COLOR),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  initImageURL() async {
    final imgProv = Provider.of<SubAgentImageProvider>(context, listen: false);
    _userInfo.profileImgURL = await imgProv.getByS3Key(_userInfo.profileS3Key);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final prov = Provider.of<UserProvider>(context, listen: false);
    _userInfo = prov.userInfo;
    _phoneEditingController =
        TextEditingController(text: _userInfo.phoneNumber);
    _officeEditingController =
        TextEditingController(text: _userInfo.affiliationOffice);
    _branchEditingController =
        TextEditingController(text: _userInfo.affiliationBranch);
    _bankAccountEditingController =
        TextEditingController(text: _userInfo.bankAccountInformation);
    _userNickEditingController =
        TextEditingController(text: _userInfo.nickName);
    _ownerLawyerEditingController = TextEditingController(text: "소속변호사");
    initImageURL();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileImage(),
                _buildUserNick(),
                _buildPhoneNumberChange(),
                if (userProv.userInfo.type == UserType.EMPLOYEE)
                  _buildOwnerLawyer(),
                if (userProv.userInfo.type == UserType.LAWYER)
                  _buildOfficeChange(),
                if (userProv.userInfo.type == UserType.LAWYER)
                  _buildBranchChange(),
                if (userProv.userInfo.type == UserType.LAWYER)
                  _buildBankAccountChange(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
