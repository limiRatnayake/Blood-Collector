class NotificationModel {
  final String uid;
  final String docRef;
  final String message;
  final String bloodGroup;
  final String createdAt;
  final String closeOn;

  NotificationModel({
    this.uid,
    this.docRef,
    this.message,
    this.bloodGroup,
    this.createdAt,
    this.closeOn,
  });

  NotificationModel.fromMap(Map snapshot)
      : uid = snapshot['uid'] ?? "",
        docRef = snapshot['docRef'] ?? "",
        message =
            snapshot['message'] ?? "", //if the value is not there it is empty
        bloodGroup = snapshot['bloodGroup'] ??
            "", //if the value is not there it is empty
        createdAt = snapshot['createdAt'] ?? "",
        closeOn = snapshot['closeOn'] ?? "";

  toJson() {
    return {
      "uid": uid,
      "docRef": docRef,
      "message": message,
      "bloodGroup": bloodGroup,
      "createdAt": createdAt,
      "closeOn": closeOn,
    };
  }
}