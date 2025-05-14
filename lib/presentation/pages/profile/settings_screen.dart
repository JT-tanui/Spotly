import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../widgets/buttons/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  String _distanceUnit = 'miles';
  String _language = 'English';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _locationEnabled = prefs.getBool('location_enabled') ?? true;
        _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
        _distanceUnit = prefs.getString('distance_unit') ?? 'miles';
        _language = prefs.getString('language') ?? 'English';
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load settings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', _notificationsEnabled);
      await prefs.setBool('location_enabled', _locationEnabled);
      await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
      await prefs.setString('distance_unit', _distanceUnit);
      await prefs.setString('language', _language);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account section
                  _buildSectionHeader('Account'),
                  ListTile(
                    leading: Icon(Icons.person, size: 20),
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile/edit');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security, size: 20),
                    title: const Text(
                      'Security',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      // Navigate to security settings
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, size: 20),
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      _showSignOutDialog();
                    },
                  ),

                  const Divider(),

                  // Notifications section
                  _buildSectionHeader('Notifications'),
                  SwitchListTile(
                    title: const Text(
                      'Enable Notifications',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Receive updates about your events',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _notificationsEnabled,
                    secondary: const Icon(Icons.notifications, size: 20),
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  ListTile(
                    enabled: _notificationsEnabled,
                    leading: Icon(Icons.event, size: 20),
                    title: const Text(
                      'Event Reminders',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      // Navigate to event reminder settings
                    },
                  ),

                  const Divider(),

                  // Privacy section
                  _buildSectionHeader('Privacy & Location'),
                  SwitchListTile(
                    title: const Text(
                      'Enable Location Services',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Discover events near you',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _locationEnabled,
                    secondary: const Icon(Icons.location_on, size: 20),
                    onChanged: (value) {
                      setState(() {
                        _locationEnabled = value;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip, size: 20),
                    title: const Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.launch, size: 18),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.description, size: 20),
                    title: const Text(
                      'Terms of Service',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.launch, size: 18),
                    onTap: () {
                      // Open terms of service
                    },
                  ),

                  const Divider(),

                  // Appearance section
                  _buildSectionHeader('Appearance'),
                  SwitchListTile(
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Switch between light and dark themes',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _darkModeEnabled,
                    secondary: const Icon(Icons.dark_mode, size: 20),
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                      // In a real app, you would use a theme provider
                      // ThemeProvider.of(context).toggleTheme();
                    },
                  ),

                  const Divider(),

                  // Preferences section
                  _buildSectionHeader('Preferences'),
                  ListTile(
                    leading: Icon(Icons.straighten, size: 20),
                    title: const Text(
                      'Distance Unit',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: DropdownButton<String>(
                      value: _distanceUnit,
                      items: const [
                        DropdownMenuItem(
                          value: 'miles',
                          child: Text('Miles'),
                        ),
                        DropdownMenuItem(
                          value: 'kilometers',
                          child: Text('Kilometers'),
                        ),
                      ],
                      underline: Container(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _distanceUnit = value;
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.language, size: 20),
                    title: const Text(
                      'Language',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: DropdownButton<String>(
                      value: _language,
                      items: const [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'Spanish',
                          child: Text('Spanish'),
                        ),
                        DropdownMenuItem(
                          value: 'French',
                          child: Text('French'),
                        ),
                      ],
                      underline: Container(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _language = value;
                          });
                        }
                      },
                    ),
                  ),

                  const Divider(),

                  // About section
                  _buildSectionHeader('About'),
                  ListTile(
                    leading: Icon(Icons.info, size: 20),
                    title: const Text(
                      'App Version',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: Icon(Icons.help, size: 20),
                    title: const Text(
                      'Help & Support',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      // Navigate to help and support
                    },
                  ),

                  const SizedBox(height: 24),

                  // Save button
                  PrimaryButton(
                    text: 'Save Settings',
                    onPressed: _saveSettings,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutEvent());
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
