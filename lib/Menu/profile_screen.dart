import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/user_provider.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>> fetchProfile(String username) async {
    final response = await http.get(
      Uri.parse('http://192.168.5.129:3000/api/auth/profile?username=$username'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      Map<String, dynamic> data = jsonBody['data'] ?? {};

      if (data['dob'] != null && data['dob'] is String) {
        data['dob'] = data['dob'].toString().split('T')[0];
      }
      return data;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Widget _buildInfoTile({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.orange,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username;

    if (username == null || username.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Profile'),
        ),
        body: const Center(child: Text('No user logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Profile'),
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfile(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final data = snapshot.data!;
          final fullName = '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}';
          final profileImageUrl = data['profile_image'] ?? ''; // Adjust if your API key is different

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatar(fullName: fullName, imageUrl: profileImageUrl),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoTile(label: 'First Name', value: data['first_name'] ?? ''),
                      _buildInfoTile(label: 'Middle Name', value: data['middle_name'] ?? ''),
                      _buildInfoTile(label: 'Last Name', value: data['last_name'] ?? ''),
                      _buildInfoTile(label: 'Username', value: data['username'] ?? ''),
                      _buildInfoTile(label: 'Email', value: data['email'] ?? ''),
                      _buildInfoTile(label: 'Phone Number', value: data['phone'] ?? ''),
                      _buildInfoTile(label: 'Birthdate', value: data['dob'] ?? ''),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            final updated = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(initialData: data),
                              ),
                            );

                            if (updated == true) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile updated successfully')),
                              );
                            }
                          },
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String fullName;
  final String imageUrl;

  const ProfileAvatar({
    Key? key,
    required this.fullName,
    required this.imageUrl,
  }) : super(key: key);

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(fullName);

    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.orange.shade300,
      backgroundImage: (imageUrl.isNotEmpty)
          ? NetworkImage(imageUrl)
          : null,
      child: (imageUrl.isEmpty)
          ? Text(
        initials,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      )
          : null,
    );
  }
}
