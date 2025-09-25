class SignatureUrl {
  String filename;

  SignatureUrl({required this.filename});

  factory SignatureUrl.fromJson(Map<String, dynamic> json) {
    return SignatureUrl(filename: json['filename']);
  }
}
