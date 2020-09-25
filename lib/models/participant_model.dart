class ParticipantModel {
  final String docRef;
  final String uid;
  final String participantName;
  final String participatedStatus;

  ParticipantModel(
      {this.docRef, this.uid, this.participantName, this.participatedStatus});

  ParticipantModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        uid = snapshot['uid'] ?? "",
        participantName = snapshot['participantName'] ?? "",
        participatedStatus = snapshot['participatedStatus'] ?? "";

  toJson() {
    return {
      "docRef": docRef,
      "uid": uid,
      "participantName": participantName,
      "participatedStatus": participatedStatus
    };
  }
}
