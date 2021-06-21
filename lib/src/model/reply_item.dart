class ReplyItem{
  final int idx;
  final String content;
  final String writerUserNick;
  final bool isMyReply;
  final bool isAnonymous;
  final DateTime createDateTime;

  ReplyItem(this.idx, this.content, this.writerUserNick, this.isMyReply, this.isAnonymous, this.createDateTime);

  factory ReplyItem.fromMap(Map<String, dynamic> replyItemMap){
    return new ReplyItem(
        replyItemMap['idx']
        , replyItemMap['content']
        , replyItemMap['writerUserNick']
        , replyItemMap['isMyReply']
        , replyItemMap['isAnonymous']
        , replyItemMap['createDateTime']);
  }
}