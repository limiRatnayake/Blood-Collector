class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;
  final String email;
  final String mobileNo;
  final String address;
  final String bloodGroup;
  final String city;

  User(this.uid, this.firstName, this.lastName, this.birthDate, this.gender, this.email, this.address,
      this.mobileNo, this.bloodGroup, this.city);

  User.fromMap(Map snapshot)
      : firstName = snapshot['firstName'] ?? "",
        lastName = snapshot['lastName'] ?? "", //if the value is not there it is empty
        gender = snapshot['gender'] ?? "",
        uid = snapshot['uid'] ?? "",
        email = snapshot['email'] ?? "",
        mobileNo = snapshot['mobileNo'] ?? "",
        address = snapshot['address'] ?? "",
        birthDate = snapshot['birthDate'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        city = snapshot['city'] ?? "";

  toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "gender" : gender,
      "uid": uid,
      "mobileNo": mobileNo,
      "address": address,
      "bloodGroup": bloodGroup,
      "birthDate" : birthDate,
      "city": city,
      "email": email,
    };
  }
}
