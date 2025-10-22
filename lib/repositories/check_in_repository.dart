import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/check-in.dart';

class CheckInRepository {

  // DocumentSnapshot? _lastCheckIn;

  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<bool> addCheckIn(String userId, DailyCheckInModel checkIn) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('daily-check-in').doc(formatDate(checkIn.date))
      .set(checkIn.toMap(), SetOptions(merge: true));
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

  Future<List<DailyCheckInModel>?> fetchAllCheckInDetails(String userId, {int limit = 7}) async {
    
      // Query query = FirebaseFirestore.instance.collection('users').doc(userId).collection('daily-check-in').orderBy("date").limit(limit);

      // if (_lastCheckIn != null) {
      //   query = query.startAfterDocument(_lastCheckIn!);
      // }

      // QuerySnapshot<Map<String, dynamic>>? documentData = (await query.get()) as QuerySnapshot<Map<String, dynamic>>?;
      
    QuerySnapshot<Map<String, dynamic>>? documentData = await FirebaseFirestore.instance.collection('users').doc(userId).collection('daily-check-in').orderBy("date").get();

    if (documentData.docs.isNotEmpty) {
      return documentData.docs.map((doc) => DailyCheckInModel.fromDoc(doc)).toList();
    } else {
      return [];
    }
  }
}