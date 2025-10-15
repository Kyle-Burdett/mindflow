import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String? id;
  String? name;
  String? email;
  Timestamp? startTime;
  Timestamp? endTime;
  String? password;
  bool? productivity;
  bool? balance;
  bool? reminder;
  Timestamp? reminderTime;
  
  int? totalHoursWorked;

  UserDetails(
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

  factory UserDetails.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserDetails(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      startTime: (data['startTime'] as Timestamp?),
      endTime: (data['startTime'] as Timestamp?),
      productivity: data['productivity'] as bool?,
      balance: data['balance'] as bool?,
      reminder: data['reminder'] as bool?,
      reminderTime: (data['reminderTime'] as Timestamp?),
    );
  }

}