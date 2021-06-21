class BoardItem {
  final int idx;
  final String title;
  final String content;
  final List<String> images;
  final String writerUserNick;
  final bool isMyBoard;
  final bool isAnonymous;
  final DateTime createDateTime;

  BoardItem(this.idx, this.title, this.content, this.images, this.writerUserNick, this.isMyBoard, this.isAnonymous, this.createDateTime);


  factory BoardItem.fromMap(Map<String, dynamic> boardItemMap){
    return new BoardItem(
        boardItemMap['idx']
        , boardItemMap['title']
        , boardItemMap['content']
        , boardItemMap['images']
        , boardItemMap['writerUserNick']
        , boardItemMap['isMyBoard']
        , boardItemMap['isAnonymous']
        , boardItemMap['createDateTime']);
  }
}
