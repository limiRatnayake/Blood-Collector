class NotificationModel {
  final String userNotifyId;
  final String uid;
  final String notificationId;
  final String message;
  final String bloodGroup;
  final String createdAt;
  final String closeOn;

  NotificationModel({
    this.userNotifyId,
    this.uid,
    this.notificationId,
    this.message,
    this.bloodGroup,
    this.createdAt,
    this.closeOn,
  });

  NotificationModel.fromMap(Map snapshot)
      : userNotifyId = snapshot['userNotifyId'] ?? "",
        uid = snapshot['uid'] ?? "",
        notificationId = snapshot['notificationId'] ?? "",
        message =
            snapshot['message'] ?? "", //if the value is not there it is empty
        bloodGroup = snapshot['bloodGroup'] ??
            "", //if the value is not there it is empty
        createdAt = snapshot['createdAt'] ?? "",
        closeOn = snapshot['closeOn'] ?? "";

  toJson() {
    return {
      "userNotifyId": userNotifyId,
      "uid": uid,
      "notificationId": notificationId,
      "message": message,
      "bloodGroup": bloodGroup,
      "createdAt": createdAt,
      "closeOn": closeOn,
    };
  }
}
