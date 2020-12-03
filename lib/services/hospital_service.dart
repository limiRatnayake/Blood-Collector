//models & shared widgets
import 'package:blood_collector/models/hospital_model.dart';
import 'package:blood_collector/shared/appConstant.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HospitalDetailsServices extends ChangeNotifier {
  final Firestore _db;
  CollectionReference _ref;

  HospitalDetailsServices() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.HOSPITALS_COLLECTION);
  }
//  Future<QuerySnapshot> getHospitals() {
//     return _ref.getDocuments();
//   }

  Future<List<HospitalListModel>> getHospitals() async {
    try {
      List<DocumentSnapshot> snapshot = (await _ref.getDocuments()).documents;

      List<HospitalListModel> hospitals = snapshot
          .map<HospitalListModel>((doc) => HospitalListModel.fromMap(doc.data))
          .toList();

      return hospitals;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
