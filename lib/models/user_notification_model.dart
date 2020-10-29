import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notifyId;
  final String docRef;
  final String notificationId;
  final String notifyBy;
  final String message;
  final String hospitalName;
  final Timestamp createdOn;

  NotificationModel({
    this.notifyId,
    this.notificationId,
    this.docRef,
    this.notifyBy,
    this.message,
    this.hospitalName,
    this.createdOn,
  });

  NotificationModel.fromMap(Map snapshot)
      : notifyId = snapshot['notifyId'] ?? "",
        docRef = snapshot['docRef'] ?? "",
        notificationId = snapshot['notificationId'] ?? "",
        notifyBy =
            snapshot['notifyBy'] ?? "", //if the value is not there it is empty
        message = snapshot['message'] ?? "",
        hospitalName = snapshot['hospitalName'] ?? "",
        createdOn = snapshot['createdOn'] ?? null;

  toJson() {
    return {
      "notifyId": notifyId,
      "docRef": docRef,
      "notificationId": notificationId,
      "notifyBy": notifyBy,
      "message": message,
      "hospitalName": hospitalName,
      "createdAt": createdOn
    };
  }
}
