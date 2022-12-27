import 'dart:convert';

List<NavDrawer> drawerFromJson(String str) =>
    List<NavDrawer>.from(json.decode(str).map((x) => NavDrawer.fromJson(x)));

String drawerToJson(List<NavDrawer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NavDrawer {
  NavDrawer({
    required this.id,
    required this.title,
    required this.link,
  });

  int id;
  String title;
  String link;

  factory NavDrawer.fromJson(Map<dynamic, dynamic> json) => NavDrawer(
        id: json["id"],
        title: json["title"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "link": link,
      };
}
