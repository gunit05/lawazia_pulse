class AppNotification {

  String id;
  String title;
  String body;
  DateTime time;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {

    return {
      "id": id,
      "title": title,
      "body": body,
      "time": time.toIso8601String(),
      "isRead": isRead
    };

  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {

    return AppNotification(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      time: DateTime.parse(json["time"]),
      isRead: json["isRead"] ?? false,
    );

  }

}