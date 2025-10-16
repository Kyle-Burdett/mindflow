import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/check-in.dart';

class CheckInRepository {
  Future<bool> addCheckIn(String userId, DailyCheckInModel checkIn) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('daily-check-in').doc(checkIn.date.toString())
      .set(checkIn.toMap(),SetOptions(merge: true));
    } catch (e) {
      print("Cannot add checkin: $e");
      return false;
    }
    return true;
  }

  Future<DailyCheckInModel?> fetchCheckInDetails(String userId, String checkInId) async {
      final document = await FirebaseFirestore.instance.collection('users').doc(userId).collection('daily-check-in').doc(checkInId).get();
      final checkIn = DailyCheckInModel.fromDoc(document);
      return checkIn;
  }
}