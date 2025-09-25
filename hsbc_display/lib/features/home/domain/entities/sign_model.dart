class SignModel {
  String id;
  String title1;
  String title2;
  String signsBanner;
  String signsBg;
  String sbanner;

  SignModel({
    required this.id,
    required this.title1,
    required this.title2,
    required this.signsBanner,
    required this.signsBg,
    required this.sbanner,
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['id'] ?? '',
      title1: json['title_1'] ?? '',
      title2: json['title_2'] ?? '',
      sbanner: json['signs_showbg'] ?? '',
      signsBanner: json['signs_banner'] ?? '',
      signsBg: json['signs_background'] ?? '',
    );
  }
}
