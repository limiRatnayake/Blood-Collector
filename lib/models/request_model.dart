class RequestAcceptModel {
  final String docRef;
  final String requesterId;
  final String requestSentOn;
  final String requestStatus;
  final bool rejected;
  final String participantsID;

  RequestAcceptModel({
    this.docRef,
    this.requesterId,
    this.requestSentOn,
    this.requestStatus,
    this.rejected,
    this.participantsID,
  });

  RequestAcceptModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        requesterId = snapshot['requesterId'] ?? "",
        requestSentOn = snapshot['requestSentOn'] ?? "",
        requestStatus = snapshot['requestStatus'] ?? "",
        rejected = snapshot['rejected'] ?? "",
        participantsID = snapshot['participantsID'] ?? "";
  toJson() {
    return {
      "docRef": docRef,
      "requesterId": requesterId,
      "requestSentOn": requestSentOn,
      "requestStatus": requestStatus,
      "rejected": rejected,
      "participantsID": participantsID,
    };
  }
}
