import 'package:cloud_firestore/cloud_firestore.dart';

class HelpFirebaseFunctions {
  bool checkField(DocumentSnapshot snapshot, String field){
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey(field)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}