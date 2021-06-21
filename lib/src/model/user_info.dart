enum UserType{
  LAWYER, EMPLOYEE
}

class UserInfo {
  int idx;
  String nickName;
  String profileS3Key;
  String profileImgURL;
  String phoneNumber;
  String email;

  bool isAlarm = true;
  UserType type;
  String affiliationOffice; //소속 사무실명
  String affiliationBranch; //소속지회

  // for lawyer
  String bankAccountInformation; //계좌정보
  String issueNumber;//변호사 자격증 등록번호
  String serialNumber;//변호사 자격증 발급번호
}
