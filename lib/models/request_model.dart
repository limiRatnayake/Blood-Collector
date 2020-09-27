class RequestAcceptModel {
  final String docRef;
  final String requesterId;
  final String requestSentOn;
  final String requestStatus;

  RequestAcceptModel({
    this.docRef,
    this.requesterId,
    this.requestSentOn,
    this.requestStatus,
  });

  RequestAcceptModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        requesterId = snapshot['requesterId'] ?? "",
        requestSentOn = snapshot['requestSentOn'] ?? "",
        requestStatus = snapshot['requestStatus'] ?? "";
  toJson() {
    return {
      "docRef": docRef,
      "requesterId": requesterId,
      "requestSentOn": requestSentOn,
      "requestStatus": requestStatus,
    };
  }
}
