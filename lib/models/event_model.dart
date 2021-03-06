import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String docRef;
  String uid;
  String bloodGroup;
  String replacementAvailability;
  String unitsOfBlood;
  int unitsFilled;
  Timestamp requestClose;
  String hospitalName;
  String hospitalAddress;
  String hospitalLat;
  String hospitalLng;
  String userFName;
  String userLName;
  String userPhoneNumber;
  String patientName;
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
  int savedEvents;
  int userAccepted;
  int notifyCount;
  int totalParticipants;
  int actualParticipants;
  int avoidParticipants;
  String status;
  String submitListStatus;
  String districts;
  String area;

  EventModel(
      {this.docRef,
      this.uid,
      this.bloodGroup,
      this.replacementAvailability,
      this.unitsOfBlood,
      this.unitsFilled,
      this.requestClose,
      this.hospitalName,
      this.hospitalAddress,
      this.hospitalLat,
      this.hospitalLng,
      this.userFName,
      this.userLName,
      this.userPhoneNumber,
      this.patientName,
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
      this.savedEvents,
      this.userAccepted,
      this.notifyCount,
      this.totalParticipants,
      this.actualParticipants,
      this.avoidParticipants,
      this.status,
      this.submitListStatus,
      this.districts,
      this.area});

  EventModel.fromMap(Map snapshot)
      : docRef = snapshot['docRef'] ?? "",
        uid = snapshot['uid'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        replacementAvailability = snapshot['replacementAvailability'] ??
            "", //if the value is not there it is empty
        unitsOfBlood = snapshot['unitsOfBlood'] ?? "",
        unitsFilled = snapshot['unitsFilled'] ?? 0,
        requestClose = snapshot['requestClose'] ?? null,
        hospitalName = snapshot['hospitalName'] ?? "",
        hospitalAddress = snapshot['hospitalAddress'] ?? "",
        hospitalLat = snapshot['hospitalLat'] ?? "",
        hospitalLng = snapshot['hospitalLng'] ?? "",
        userFName = snapshot['userFName'] ?? "",
        userLName = snapshot['userLName'] ?? "",
        userPhoneNumber = snapshot['userPhoneNumber'] ?? "",
        patientName = snapshot['patientName'] ?? "",
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
        savedEvents = snapshot['savedEvents'] ?? 0,
        userAccepted = snapshot['userAccepted'] ?? 0,
        notifyCount = snapshot['notifyCount'] ?? 0,
        totalParticipants = snapshot['totalParticipants'] ?? 0,
        actualParticipants = snapshot['actualParticipants'] ?? 0,
        avoidParticipants = snapshot['avoidParticipants'] ?? 0,
        status = snapshot['status'] ?? "",
        submitListStatus = snapshot['submitListStatus'] ?? "",
        districts = snapshot['districts'] ?? "",
        area = snapshot['area'] ?? "";

  toJson() {
    return {
      "docRef": docRef,
      "uid": uid,
      "bloodGroup": bloodGroup,
      "replacementAvailability": replacementAvailability,
      "unitsOfBlood": unitsOfBlood,
      "unitsFilled": unitsFilled,
      "requestClose": requestClose,
      "hospitalName": hospitalName,
      "hospitalAddress": hospitalAddress,
      "hospitalLat": hospitalLat,
      "hospitalLng": hospitalLng,
      "userFName": userFName,
      "userLName": userLName,
      "userPhoneNumber": userPhoneNumber,
      "patientName": patientName,
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
      "visibleState": visibleState,
      "likes": likes,
      "savedEvents": savedEvents,
      "userAccepted": userAccepted,
      "notifyCount": notifyCount,
      "totalParticipants": totalParticipants,
      "actualParticipants": actualParticipants,
      "avoidParticipants": avoidParticipants,
      "status": status,
      "submitListStatus": submitListStatus,
      "districts": districts,
      "area": area,
    };
  }
}
