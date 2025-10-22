import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  DateTime? startTime;
  DateTime? endTime;
  String? password;
  bool? productivity;
  bool? balance;
  bool? reminder;
  DateTime? reminderTime;
  
  int? totalHoursWorked;

  UserModel(
      {this.id,
      this.balance,
      this.endTime,
      this.name,
      this.password,
      this.productivity,
      this.reminder,
      this.reminderTime,
      this.startTime,
      this.totalHoursWorked});

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      productivity: data['productivity'] as bool?,
      balance: data['balance'] as bool?,
      reminder: data['reminder'] as bool?,
      reminderTime: (data['reminderTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': Timestamp.fromDate(startTime!),
      'endTime': Timestamp.fromDate(endTime!),
      'productivity': productivity,
      'balance': balance,
      'reminder': reminder,
      'reminderTime': reminderTime != null ? Timestamp.fromDate(reminderTime!) : FieldValue.serverTimestamp(),
    };
  }
}