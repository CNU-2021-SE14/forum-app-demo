class Notification {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? postId;
  final String? receiverId;

  Notification(
      {this.id,
      this.title,
      this.contents,
      this.datetime,
      this.postId,
      this.receiverId});
}
