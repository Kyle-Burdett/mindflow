import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
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
      this.email,
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
      email: data['email'] ?? '',
      startTime: (data['startTime'] as DateTime?),
      endTime: (data['startTime'] as DateTime?),
      productivity: data['productivity'] as bool?,
      balance: data['balance'] as bool?,
      reminder: data['reminder'] as bool?,
      reminderTime: (data['reminderTime'] as DateTime?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'startTime': startTime ?? FieldValue.serverTimestamp(),
      'endTime': endTime ?? FieldValue.serverTimestamp(),
      'productivity': productivity,
      'balance': balance,
      'reminder': reminder,
      'reminderTime': reminderTime ?? FieldValue.serverTimestamp(),
    };
  }
}