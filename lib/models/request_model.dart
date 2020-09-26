class RequestAcceptModel {
  final String requesterId;
  final String requestSentOn;
  final String requestStatus;

  RequestAcceptModel({
    this.requesterId,
    this.requestSentOn,
    this.requestStatus,
  });

  RequestAcceptModel.fromMap(Map snapshot)
      : requesterId = snapshot['requesterId'] ?? "",
        requestSentOn = snapshot['requestSentOn'] ?? "",
        requestStatus = snapshot['requestStatus'] ?? "";
  toJson() {
    return {
      "requesterId": requesterId,
      "requestSentOn": requestSentOn,
      "requestStatus": requestStatus,
    };
  }
}
