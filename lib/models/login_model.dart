class Login {
  String nickname;
  String? phoneNumber;
  int profileImageIndex;

  Login({
    required this.nickname,
    this.phoneNumber,
    required this.profileImageIndex,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      nickname: json['nickname'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageIndex: json['profileImageIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'profileImageIndex': profileImageIndex,
    };
  }
}
