class Comment {
  final int commentId;
  final int authorId;
  final String authorNickname;
  final int authorProfileNo;
  final String content;
  final String createdAt;

  Comment({
    required this.commentId,
    required this.authorId,
    required this.authorNickname,
    required this.authorProfileNo,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      authorId: json['authorId'],
      authorNickname: json['authorNickname'],
      authorProfileNo: json['authorProfileNo'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'authorId': authorId,
      'authorNickname': authorNickname,
      'authorProfileNo': authorProfileNo,
      'content': content,
      'createAt': createdAt,
    };
  }
}
