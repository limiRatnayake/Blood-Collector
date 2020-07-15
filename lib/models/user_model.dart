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
   bool disabled;

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
    this.disabled
  });

  UserModel.fromMap(Map snapshot)
      : uid = snapshot['uid'] ?? "",
       userRole = snapshot['userRole'] ?? "",
        firstName = snapshot['firstName'] ?? "",
        lastName = snapshot['lastName'] ?? "", //if the value is not there it is empty
        gender = snapshot['gender'] ?? "",
        birthDate = snapshot['birthDate'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        mobileNo = snapshot['mobileNo'] ?? "",
        address = snapshot['address'] ?? "",
        userAddLat = snapshot['userAddLat'] ?? "",
        userAddLng = snapshot['userAddLng'] ?? "",
        email = snapshot['email'] ?? "",
        disabled = snapshot['disabled'] ?? "";

  toJson() {
    return {
      "uid": uid,
      "userRole" : userRole,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate,
      "bloodGroup": bloodGroup,
      "mobileNo": mobileNo,
      "address": address,
      "email": email,
      "userAddLat":userAddLat,
      "userAddLng": userAddLng,
      "disabled":disabled
    };
  }
}
