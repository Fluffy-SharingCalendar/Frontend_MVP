class Article {
  final int postId;
  final int authorId;
  final String authorNickname;
  final int authorProfileImageNo;
  final List<String> urls; // List<String>으로 이미지 URL들을 저장
  final String content;
  final String eventDate;
  final int commentCnt;

  Article({
    required this.postId,
    required this.authorId,
    required this.authorNickname,
    required this.authorProfileImageNo,
    required this.urls,
    required this.content,
    required this.eventDate,
    required this.commentCnt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      postId: json['postId'],
      authorId: json['authorId'],
      authorNickname: json['authorNickname'],
      authorProfileImageNo: json['authorProfileImageNo'],
      // null 체크를 추가하여 안전하게 파싱
      urls: json['urls'] != null
          ? List<String>.from(json['urls'].map((url) => url['url']))
          : [],
      content: json['content'],
      eventDate: json['eventDate'],
      commentCnt: json['commentCnt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorNickname': authorNickname,
      'authorProfileImageNo': authorProfileImageNo,
      'urls': urls, // String 리스트 그대로 반환
      'content': content,
      'eventDate': eventDate,
      'commentCnt': commentCnt,
    };
  }
}

class ArticleResponse {
  final List<Article> posts;
  final int totalPages;
  final int totalElements;
  final int currentPage;
  final int pageSize;

  ArticleResponse({
    required this.posts,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
    required this.pageSize,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    return ArticleResponse(
      posts: List<Article>.from(
          json['posts'].map((post) => Article.fromJson(post))),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((post) => post.toJson()).toList(),
      'totalPages': totalPages,
      'totalElements': totalElements,
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
  }
}
