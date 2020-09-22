class EventModel {
  String docRef;
  String uid;
  String bloodGroup;
  String replacementAvailability;
  String unitsOfBlood;
  String requestClose;
  String hospitalName;
  String hospitalAddress;
  String hospitalLat;
  String hospitalLng;
  String userFName;
  String userLName;
  String userPhoneNumber;
  bool notifyState;
  String nameOftheOrganizer;
  String pickUpStartDate;
  String pickUpEndDate;
  String startTime;
  String endTime;
  String placeName;
  String placeAddress;
  String placeLat;
  String placeLng;
  String orgernizerConatctNo;
  String description;
  String imageName;
  String imageExtention;
  String imageUrl;
  bool approved;
  String rejectReason;
  String createdAt;
  String category;
  bool visibleState;
  int likes;
  int interested;
  EventModel({
    this.docRef,
    this.uid,
    this.bloodGroup,
    this.replacementAvailability,
    this.unitsOfBlood,
    this.requestClose,
    this.hospitalName,
    this.hospitalAddress,
    this.hospitalLat,
    this.hospitalLng,
    this.userFName,
    this.userLName,
    this.userPhoneNumber,
    this.notifyState,
    this.nameOftheOrganizer,
    this.pickUpStartDate,
    this.pickUpEndDate,
    this.startTime,
    this.endTime,
    this.placeName,
    this.placeAddress,
    this.placeLat,
    this.placeLng,
    this.orgernizerConatctNo,
    this.description,
    this.imageName,
    this.imageExtention,
    this.imageUrl,
    this.approved,
    this.rejectReason,
    this.createdAt,
    this.category,
    this.visibleState,
    this.likes,
    this.interested
  });

  EventModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        uid = snapshot['uid'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        replacementAvailability = snapshot['replacementAvailability'] ??
            "", //if the value is not there it is empty
        unitsOfBlood = snapshot['unitsOfBlood'] ?? "",
        requestClose = snapshot['requestClose'] ?? "",
        hospitalName = snapshot['hospitalName'] ?? "",
        hospitalAddress = snapshot['hospitalAddress'] ?? "",
        hospitalLat = snapshot['hospitalLat'] ?? "",
        hospitalLng = snapshot['hospitalLng'] ?? "",
        userFName = snapshot['userFName'] ?? "",
        userLName = snapshot['userLName'] ?? "",
        userPhoneNumber = snapshot['userPhoneNumber'] ?? "",
        notifyState = snapshot['notifyState'] ?? null,
        nameOftheOrganizer = snapshot['nameOftheOrganizer'] ?? "",
        pickUpStartDate = snapshot['pickUpStartDate'] ?? "",
        pickUpEndDate = snapshot['pickUpEndDate'] ?? "",
        startTime = snapshot['startTime'] ?? "",
        endTime = snapshot['endTime'] ?? "",
        placeName = snapshot['placeName'] ?? "",
        placeAddress = snapshot['placeAddress'] ?? "",
        placeLat = snapshot['placeLat'] ?? "",
        placeLng = snapshot['placeLng'] ?? "",
        orgernizerConatctNo = snapshot['orgernizerConatctNo'] ?? "",
        description = snapshot['description'] ?? "",
        imageName = snapshot['imageName'] ?? "",
        imageExtention = snapshot['imageExtention'] ?? "",
        imageUrl = snapshot['imageUrl'] ?? "",
        approved = snapshot['approved'] ?? false,
        rejectReason = snapshot['rejectReason'] ?? "",
        createdAt = snapshot['createdAt'] ?? "",
        category = snapshot['category'] ?? "",
        visibleState = snapshot['visibleState'] ?? null,
        likes = snapshot['likes'] ?? 0,
        interested = snapshot['interested'] ?? 0;

  toJson() {
    return {
      "docRef": docRef,
      "uid": uid,
      "bloodGroup": bloodGroup,
      "replacementAvailability": replacementAvailability,
      "unitsOfBlood": unitsOfBlood,
      "requestClose": requestClose,
      "hospitalName": hospitalName,
      "hospitalAddress": hospitalAddress,
      "hospitalLat": hospitalLat,
      "hospitalLng": hospitalLng,
      "userFName": userFName,
      "userLName": userLName,
      "userPhoneNumber": userPhoneNumber,
      "notifyState": notifyState,
      "nameOftheOrganizer": nameOftheOrganizer,
      "pickUpStartDate": pickUpStartDate,
      "pickUpEndDate": pickUpEndDate,
      "startTime": startTime,
      "endTime": endTime,
      "placeName": placeName,
      "placeAddress": placeAddress,
      "placeLat": placeLat,
      "placeLng": placeLng,
      "orgernizerConatctNo": orgernizerConatctNo,
      "description": description,
      "imageName": imageName,
      "imageExtention": imageExtention,
      "imageUrl": imageUrl,
      "approved": approved,
      "rejectReason": rejectReason,
      "createdAt": createdAt,
      "category": category,
      "visibleState":visibleState,
      "likes": likes,
      "interested": interested,

    };
  }
}
