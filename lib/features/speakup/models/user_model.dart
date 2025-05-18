class UserModel {
  String userId;
  String username;
  String email;
  String password;
  String imageUrl;

  UserModel({
    required this.username,
    required this.userId,
    required this.email,
    required this.password,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['userId'] = userId;
    data['email'] = email;
    data['password'] = password;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
