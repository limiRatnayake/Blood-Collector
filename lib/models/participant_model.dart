class ParticipantModel {
  final String participantId;
  final String docRef;
  final String uid;
  final String bloodGroup;
  final String participantName;
  final String participatedStatus;
  final String lastModifyDate;

  ParticipantModel(
      {this.participantId,
      this.docRef,
      this.uid,
      this.bloodGroup,
      this.participantName,
      this.participatedStatus,
      this.lastModifyDate});

  ParticipantModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        participantId = snapshot['participantId'] ?? "",
        uid = snapshot['uid'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        participantName = snapshot['participantName'] ?? "",
        participatedStatus = snapshot['participatedStatus'] ?? "",
        lastModifyDate = snapshot['lastModifyDate'] ?? "";

  toJson() {
    return {
      "participantId": participantId,
      "docRef": docRef,
      "uid": uid,
      "bloodGroup": bloodGroup,
      "participantName": participantName,
      "participatedStatus": participatedStatus,
      "lastModifyDate": lastModifyDate
    };
  }
}
