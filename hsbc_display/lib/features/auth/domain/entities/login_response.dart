class LoginResponse {
  String id;
  String title;

  LoginResponse({required this.id, required this.title});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(id: json['id'], title: json['title']);
  }
}
