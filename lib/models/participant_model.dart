class ParticipantModel {
  final String docRef;
  final String uid;
  final String participantName;

  ParticipantModel({
    this.docRef,
    this.uid,
    this.participantName,
  });

  ParticipantModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        uid = snapshot['uid'] ?? "",
        participantName = snapshot['participantName'] ?? "";

  toJson() {
    return {
      "docRef": docRef,
      "uid": uid,
      "participantName": participantName,
    };
  }
}
