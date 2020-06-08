class HospitalListModel {
   final String id;
  final String bloodBankName;
  final String bloodBankAddress;
  final String description;
  final String hospitalLatitude;
  final String hospitalLongitude;

  HospitalListModel({
    this.id,
    this.bloodBankName,
    this.bloodBankAddress,
    this.description,
    this.hospitalLatitude,
    this.hospitalLongitude,
  });

  HospitalListModel.fromMap(Map snapshot)
      : id = snapshot['id'] ?? "",
        bloodBankName = snapshot['bloodBankName'] ?? "",
        bloodBankAddress = snapshot['bloodBankAddress'] ?? "", //if the value is not there it is empty
        description = snapshot['description'] ?? "",
        hospitalLatitude = snapshot['hospitalLatitude'] ?? "",
        hospitalLongitude = snapshot['hospitalLongitude'] ?? "";

  toJson() {
    return {
      "id" : id,
      "bloodBankName": bloodBankName,
      "bloodBankAddress": bloodBankAddress,
      "description": description,
      "hospitalLatitude": hospitalLatitude,
      "hospitalLongitude": hospitalLongitude,
    };
  }
}
