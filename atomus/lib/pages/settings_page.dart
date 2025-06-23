import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050811),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Rafael Antunes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'rafinhasbr@gmail.com',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        // Ação para editar
                      },
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFF222531),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 6, right: 6),
                  child: Column(
                    children: [
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildSwitchSetting('Notifications',
                          Icons.notifications_active_rounded, false),
                      _buildSwitchSetting(
                          'Theme', Icons.color_lens_rounded, true),
                      _buildSwitchSetting('Background play',
                          Icons.play_circle_fill_rounded, false),
                      _buildSwitchSetting(
                          'Download via WiFi only', Icons.wifi_rounded, true),
                      _buildSwitchSetting(
                          'Autoplay', Icons.play_arrow_rounded, false),
                      const SizedBox(height: 20),
                      _buildLanguageSetting('Language', 'English'),
                      _buildLanguageSetting('Notifications', 'Enabled'),
                      _buildLanguageSetting('Theme', 'Light'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(String title, IconData icon, bool value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildLanguageSetting(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      onTap: () {
        // Ação para o item
      },
    );
  }
}
