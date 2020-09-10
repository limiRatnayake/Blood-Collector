class EventLikesModel {
  String docRef;

  EventLikesModel({
    this.docRef,
  });

  EventLikesModel.fromMap(Map snapshot) : docRef = snapshot['docRef'] ?? "";

  toJson() {
    return {
      "docRef": docRef,
    };
  }
}
