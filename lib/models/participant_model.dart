class ParticipantModel {
  final String participantId;
  final String docRef;
  final String uid;
  final String participantName;
  final String participatedStatus;

  ParticipantModel(
      {this.participantId,
      this.docRef,
      this.uid,
      this.participantName,
      this.participatedStatus});

  ParticipantModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        participantId = snapshot['participantId'] ?? "",
        uid = snapshot['uid'] ?? "",
        participantName = snapshot['participantName'] ?? "",
        participatedStatus = snapshot['participatedStatus'] ?? "";

  toJson() {
    return {
      "participantId": participantId,
      "docRef": docRef,
      "uid": uid,
      "participantName": participantName,
      "participatedStatus": participatedStatus
    };
  }
}
