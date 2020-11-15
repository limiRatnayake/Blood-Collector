class NotificationModel {
  String notifyId;
  String docRef;
  String notificationId;
  String notifyBy;
  String message;
  String hospitalName;
  String organizersName;
  String eventHeldOn;

  // Timestamp createdOn;

  NotificationModel({
    this.notifyId,
    this.docRef,
    this.notificationId,
    this.notifyBy,
    this.message,
    this.hospitalName,
    this.organizersName,
    this.eventHeldOn,
    // this.createdOn,
  });

  NotificationModel.fromMap(Map snapshot)
      : notifyId = snapshot['notifyId'] ?? "",
        docRef = snapshot['docRef'] ?? "",
        notificationId = snapshot['notificationId'] ?? "",
        notifyBy =
            snapshot['notifyBy'] ?? "", //if the value is not there it is empty
        message = snapshot['message'] ?? "",
        hospitalName = snapshot['hospitalName'] ?? "",
        organizersName = snapshot['organizersName'] ?? "",
        eventHeldOn = snapshot['eventHeldOn'] ?? "";
  // createdOn = snapshot['createdOn'] ?? null;

  toJson() {
    return {
      "notifyId": notifyId,
      "docRef": docRef,
      "notificationId": notificationId,
      "notifyBy": notifyBy,
      "message": message,
      "hospitalName": hospitalName,
      "organizersName": organizersName,
      "eventHeldOn": eventHeldOn,
      // "createdAt": createdOn
    };
  }
}
