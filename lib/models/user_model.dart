class UserModel {
  String uid;
  String userRole;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String bloodGroup;
  String mobileNo;
  String address;
  String userAddLat;
  String userAddLng;
  String email;
  String proPicUrl;
  bool disabled;
  int age;

  String userPreviouslyDonatedOrNot;
  String ifYesHowManyTimes;
  String dateOfLastDonation;
  String medicallyAdvised;
  String vaildIdentitiyCardCheck;
  String freeFromRiskBehaviour;
  String freeFromSeriousCondition;
  String travelAbroad;
  String presentMedialTreatment;
  String undergoneSurgery;
  bool lastDonationDateCheck;

  UserModel({
    this.uid,
    this.userRole,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.bloodGroup,
    this.mobileNo,
    this.address,
    this.userAddLat,
    this.userAddLng,
    this.email,
    this.proPicUrl,
    this.disabled,
    this.age,
    this.userPreviouslyDonatedOrNot,
    this.ifYesHowManyTimes,
    this.dateOfLastDonation,
    this.medicallyAdvised,
    this.vaildIdentitiyCardCheck,
    this.freeFromRiskBehaviour,
    this.freeFromSeriousCondition,
    this.travelAbroad,
    this.presentMedialTreatment,
    this.undergoneSurgery,
    this.lastDonationDateCheck,
  });

  UserModel.fromMap(Map snapshot)
      : uid = snapshot['uid'] ?? "",
        userRole = snapshot['userRole'] ?? "",
        firstName = snapshot['firstName'] ?? "",
        lastName =
            snapshot['lastName'] ?? "", //if the value is not there it is empty
        gender = snapshot['gender'] ?? "",
        birthDate = snapshot['birthDate'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        mobileNo = snapshot['mobileNo'] ?? "",
        address = snapshot['address'] ?? "",
        userAddLat = snapshot['userAddLat'] ?? "",
        userAddLng = snapshot['userAddLng'] ?? "",
        email = snapshot['email'] ?? "",
        proPicUrl = snapshot['proPicUrl'] ?? "",
        disabled = snapshot['disabled'] ?? "",
        age = snapshot['age'] ?? 0,
        userPreviouslyDonatedOrNot =
            snapshot['userPreviouslyDonatedOrNot'] ?? "",
        ifYesHowManyTimes = snapshot['ifYesHowManyTimes'] ?? "",
        dateOfLastDonation = snapshot['dateOfLastDonation'] ?? "",
        medicallyAdvised = snapshot['medicallyAdvised'] ?? "",
        vaildIdentitiyCardCheck = snapshot['vaildIdentitiyCardCheck'] ?? "",
        freeFromRiskBehaviour = snapshot['freeFromRiskBehaviour'] ?? "",
        freeFromSeriousCondition = snapshot['freeFromSeriousCondition'] ?? "",
        travelAbroad = snapshot['travelAbroad'] ?? "",
        presentMedialTreatment = snapshot['presentMedialTreatment'] ?? "",
        undergoneSurgery = snapshot['undergoneSurgery'] ?? "",
        lastDonationDateCheck = snapshot['lastDonationDateCheck'] ?? "";

  toJson() {
    return {
      "uid": uid,
      "userRole": userRole,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate,
      "bloodGroup": bloodGroup,
      "mobileNo": mobileNo,
      "address": address,
      "email": email,
      "userAddLat": userAddLat,
      "userAddLng": userAddLng,
      "proPicUrl": proPicUrl,
      "disabled": disabled,
      "age": age,
      "userPreviouslyDonatedOrNot": userPreviouslyDonatedOrNot,
      "ifYesHowManyTimes": ifYesHowManyTimes,
      "dateOfLastDonation": dateOfLastDonation,
      "medicallyAdvised": medicallyAdvised,
      "vaildIdentitiyCardCheck": vaildIdentitiyCardCheck,
      "freeFromRiskBehaviour": freeFromRiskBehaviour,
      "freeFromSeriousCondition": freeFromSeriousCondition,
      "travelAbroad": travelAbroad,
      "presentMedialTreatment": presentMedialTreatment,
      "undergoneSurgery": undergoneSurgery,
      "lastDonationDateCheck": lastDonationDateCheck
    };
  }
}
