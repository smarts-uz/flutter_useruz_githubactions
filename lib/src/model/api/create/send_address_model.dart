
class SendAddressModel {
  SendAddressModel({
    required this.taskId,
    required this.points,
  });

  int taskId;
  List<SendAddressPoint> points;

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "points": List<dynamic>.from(points.map((x) => x.toJson())),
  };
}

class SendAddressPoint {
  SendAddressPoint({
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  String location;
  double latitude;
  double longitude;


  Map<String, dynamic> toJson() => {
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
  };
}
