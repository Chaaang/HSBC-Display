class Event {
  String id;
  String title1;
  String title2;
  String signsBanner;
  String signsBackground;
  String signsShowBg;
  String listRefreshSecods;

  Event({
    required this.id,
    required this.title1,
    required this.title2,
    required this.signsBanner,
    required this.signsBackground,
    required this.signsShowBg,
    required this.listRefreshSecods,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title1: json['title_1'] ?? '',
      title2: json['title_2'] ?? '',
      signsBanner: json['signs_banner'] ?? '',
      signsBackground: json['signs_background'] ?? '',
      signsShowBg: json['signs_showbg'] ?? '',
      listRefreshSecods: json['lists_refresh_seconds'] ?? '',
    );
  }
}
