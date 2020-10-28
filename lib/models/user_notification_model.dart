class NotificationModel {
  final String notifyId;
  final String docRef;
  final String notificationId;
  final String notifyBy;
  final String message;
  final String hospitalName;
  final String createdAt;

  NotificationModel({
    this.notifyId,
    this.notificationId,
    this.docRef,
    this.notifyBy,
    this.message,
    this.hospitalName,
    this.createdAt,
  });

  NotificationModel.fromMap(Map snapshot)
      : notifyId = snapshot['notifyId'] ?? "",
        docRef = snapshot['docRef'] ?? "",
        notificationId = snapshot['notificationId'] ?? "",
        notifyBy =
            snapshot['notifyBy'] ?? "", //if the value is not there it is empty
        message = snapshot['message'] ?? "",
        hospitalName = snapshot['hospitalName'] ?? "",
        createdAt = snapshot['createdAt'] ?? "";

  toJson() {
    return {
      "notifyId": notifyId,
      "docRef": docRef,
      "notificationId": notificationId,
      "notifyBy": notifyBy,
      "message": message,
      "hospitalName": hospitalName,
      "createdAt": createdAt
    };
  }
}
