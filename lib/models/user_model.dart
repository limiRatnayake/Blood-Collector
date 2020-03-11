class User {
  final String uid;
  final String name;
  final String email;
  final String mobileNo;
  final String address;
  final String bloodGroup;
  final String city;

  User(this.uid, this.name, this.email, this.address, this.mobileNo,
      this.bloodGroup, this.city);

  User.fromMap(Map snapshot)
      : name = snapshot['name'] ?? "", //if the value is not there it is empty
        uid = snapshot['uid'] ?? "",
        email = snapshot['email'] ?? "",
        mobileNo = snapshot['mobileNo'] ?? "",
        address = snapshot['address'] ?? "",
        bloodGroup = snapshot['bloodGroup'] ?? "",
        city = snapshot['city'] ?? "";

  toJson() {
    return {
      "name": name,
      "uid": uid,
      "mobileNo": mobileNo,
      "address": address,
      "bloodGroup": bloodGroup,
      "city": city,
      "email": email,
    };
  }
}
