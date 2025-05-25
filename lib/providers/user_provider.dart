import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  String? get username => _userData?['username'];
  String? get firstName => _userData?['first_name'];
  String? get middleName => _userData?['middle_name'];
  String? get lastName => _userData?['last_name'];
  String? get email => _userData?['email'];
  String? get phone => _userData?['phone'];
  String? get dob => _userData?['dob'];
  String? get userId => _userData?['id']?.toString();

  void setUserData(Map<String, dynamic> data) {
    _userData = data;
    notifyListeners();
  }

  void setUsername(String username) {
    _userData ??= {};
    _userData!['username'] = username;
    notifyListeners();
  }

  void setFirstName(String firstName) {
    _userData ??= {};
    _userData!['first_name'] = firstName;
    notifyListeners();
  }

  // Add other setters as needed

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }

  /// New method to reset password by calling your backend API
  Future<Map<String, dynamic>> resetPassword({
    required String username,
    required String email,
    required String phone,
    required String newPassword,
  }) async {
    final url = Uri.parse('http://192.168.5.129:3000/api/auth/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'phone': phone,
          'newPassword': newPassword,
        }),
      );

      // Debug print the raw response
      print('Reset password response status: ${response.statusCode}');
      print('Reset password response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'] ?? 'Password reset successfully',
          };
        } else {
          // API responded with 200 but indicated failure in body
          return {
            'success': false,
            'message': data['message'] ?? 'Password reset failed',
          };
        }
      } else {
        // Non-200 HTTP status code
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Catch any exceptions like network errors, JSON parsing errors, etc
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
