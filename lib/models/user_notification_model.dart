class NotificationModel {
  final String notifyId;
  final String notificationId;
  final String notifyBy;
  final String message;

  NotificationModel({
    this.notifyId,
    this.notificationId,
    this.notifyBy,
    this.message,
  });

  NotificationModel.fromMap(Map snapshot)
      : notifyId = snapshot['notifyId'] ?? "",
        notificationId = snapshot['notificationId'] ?? "",
        notifyBy =
            snapshot['notifyBy'] ?? "", //if the value is not there it is empty
        message = snapshot['message'] ?? "";

  toJson() {
    return {
      "notifyId": notifyId,
      "notificationId": notificationId,
      "notifyBy": notifyBy,
      "message": message
    };
  }
}
