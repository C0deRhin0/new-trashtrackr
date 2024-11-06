import 'package:cloud_firestore/cloud_firestore.dart';

class Concern {
  String name;
  String email;
  String phoneNumber;
  String concern;
  Timestamp createdOn;

  Concern({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.concern,
    required this.createdOn,
  });

  // Factory constructor for creating a Concern from Firestore JSON data
  Concern.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          phoneNumber: json['phoneNumber']! as String,
          concern: json['concern']! as String,
          createdOn: json['createdOn']! as Timestamp,
        );

  // Method for converting Concern to Firestore JSON format
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'concern': concern,
      'createdOn': createdOn,
    };
  }
}
