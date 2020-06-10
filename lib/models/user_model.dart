class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;
  final String bloodGroup;
  final String mobileNo;
  final String city;
  final String address;
  final String email;

  UserModel(
    this.uid,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.bloodGroup,
    this.mobileNo,
    this.city,
    this.address,
    this.email,
  );

  UserModel.fromMap(Map snapshot)
      : uid = snapshot['uid'] ?? "",
        firstName = snapshot['firstName'] ?? "",
        lastName =
            snapshot['lastName'] ?? "", //if the value is not there it is empty
        gender = snapshot['gender'] ?? "",
        birthDate = snapshot['birthDate'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        mobileNo = snapshot['mobileNo'] ?? "",
        city = snapshot['city'] ?? "",
        address = snapshot['address'] ?? "",
        email = snapshot['email'] ?? "";

  toJson() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate,
      "bloodGroup": bloodGroup,
      "mobileNo": mobileNo,
      "city": city,
      "address": address,
      "email": email,
    };
  }
}
