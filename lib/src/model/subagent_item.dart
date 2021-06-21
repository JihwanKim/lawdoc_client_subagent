enum SubAgentShowTypes{
  BOARD,
  REQUESTING,
  REQUEST,
  ACCEPTED
  // "BOARD", "REQUESTING", "REQUEST", "ACCEPTED"
}

class SubAgentItem {
  final int idx;
  final int pay;
  final String title;
  final String place;
  final String phone;
  final String content;
  final DateTime subAgentAt;
  final DateTime createAt;
  final DateTime updateAt;

  SubAgentItem(this.idx, this.title, this.place, this.phone, this.subAgentAt,
      this.pay, this.content, this.createAt, this.updateAt);
}
