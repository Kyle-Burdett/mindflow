import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/check-in.dart';

class CheckInRepository {
  // format date for keying records in the firestore database. making sure it fits a consistent structure for storing keys.
  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Set check in creates or updates check-in records depending on whether record exists yet.
  Future<bool> setCheckIn(String userId, DailyCheckInModel checkIn) async {
    try {
      print(checkIn.toMap());
      // Storing data in a subcollection under the user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('daily-check-in')
          .doc(formatDate(checkIn.date))
          .set(checkIn.toMap(), SetOptions(merge: true));
    } catch (e) {
      print("Cannot add checkin: $e");
      return false;
    }
    return true;
  }

  // Fetching a single check-in record based on userId and checkInId
  Future<DailyCheckInModel?> fetchCheckInDetails(
    String userId,
    String checkInId,
  ) async {
    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('daily-check-in')
        .doc(checkInId)
        .get();
    final checkIn = DailyCheckInModel.fromDoc(document);
    return checkIn;
  }

  //Fetching all user check-ins and ordering in descending order
  Future<List<DailyCheckInModel>?> fetchAllCheckInDetails(
    String userId, {
    int limit = 7,
  }) async {
    QuerySnapshot<Map<String, dynamic>>? documentData = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .collection('daily-check-in')
        .orderBy("date", descending: true)
        .get();
    if (documentData.docs.isNotEmpty) {
      return documentData.docs
          .map((doc) => DailyCheckInModel.fromDoc(doc))
          .toList();
    } else {
      return [];
    }
  }
}
