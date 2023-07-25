class ActiveSessionModel {
  ActiveSessionModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<ActiveSessionData> data;

  factory ActiveSessionModel.fromJson(Map<String, dynamic> json) =>
      ActiveSessionModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? []
            : List<ActiveSessionData>.from(
                json["data"].map((x) => ActiveSessionData.fromJson(x))),
      );
}

class ActiveSessionData {
  ActiveSessionData({
    required this.id,
    required this.ipAddress,
    required this.userAgent,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.isMobile,
  });

  String id;
  String ipAddress;
  String userAgent;
  String deviceId;
  String deviceName;
  String platform;
  int isMobile;

  factory ActiveSessionData.fromJson(Map<String, dynamic> json) =>
      ActiveSessionData(
        id: json["id"] ?? "",
        ipAddress: json["ip_address"] ?? "",
        userAgent: json["user_agent"] ?? "",
        deviceId: json["device_id"] ?? "",
        deviceName: json["device_name"] ?? "",
        platform: json["platform"] ?? "",
        isMobile: json["is_mobile"] ?? 0,
      );
}
