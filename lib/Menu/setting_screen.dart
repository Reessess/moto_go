import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;
  bool _locationAccess = true;
  bool _soundEffects = true;
  bool _vibrationFeedback = true;
  String _language = 'English';

  // Simulate clearing cache
  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared successfully')),
    );
  }

  Widget _buildRoundedTile({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // square curve corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // subtle background
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          _buildRoundedTile(
            child: SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
              secondary: const Icon(Icons.notifications),
            ),
          ),
          _buildRoundedTile(
            child: SwitchListTile(
              title: const Text('Location Access'),
              value: _locationAccess,
              onChanged: (val) {
                setState(() {
                  _locationAccess = val;
                });
              },
              secondary: const Icon(Icons.location_on),
            ),
          ),
          _buildRoundedTile(
            child: SwitchListTile(
              title: const Text('Sound Effects'),
              value: _soundEffects,
              onChanged: (val) {
                setState(() {
                  _soundEffects = val;
                });
              },
              secondary: const Icon(Icons.volume_up),
            ),
          ),
          _buildRoundedTile(
            child: SwitchListTile(
              title: const Text('Vibration Feedback'),
              value: _vibrationFeedback,
              onChanged: (val) {
                setState(() {
                  _vibrationFeedback = val;
                });
              },
              secondary: const Icon(Icons.vibration),
            ),
          ),
          _buildRoundedTile(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: Text(_language),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ['English', 'Tagalog', 'Ilocano']
                          .map((lang) => RadioListTile<String>(
                        title: Text(lang),
                        value: lang,
                        groupValue: _language,
                        onChanged: (val) {
                          setState(() {
                            _language = val!;
                            Navigator.pop(context);
                          });
                        },
                      ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildRoundedTile(
            child: ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Cache'),
              onTap: _clearCache,
            ),
          ),
          const SizedBox(height: 16),
          _buildRoundedTile(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'MotoGO',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.motorcycle, size: 40),
                  children: const [
                    Text('MotoGO is a bike rental app.'),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
