class SavedEventModel {
  String docRef;

  String savedAt;

  SavedEventModel({
    this.docRef,
    this.savedAt,
  });

  SavedEventModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        savedAt = snapshot['savedAt'] ?? "";

  toJson() {
    return {
      "docRef": docRef,
      "savedAt": savedAt,
    };
  }
}
