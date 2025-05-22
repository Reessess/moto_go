// lib/models/user_model.dart
class UserModel {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final String dob;

  UserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
    );
  }
}
