class EventLikesModel {
  String docRef;
  bool isLiked;

  EventLikesModel({
    this.docRef,
    this.isLiked
  });

  EventLikesModel.fromMap(Map snapshot) : 
  docRef = snapshot['docRef'] ?? "",
  isLiked = snapshot['isLiked'] ?? false;
  

  toJson() {
    return {
      docRef: isLiked,
    };
  }
}
