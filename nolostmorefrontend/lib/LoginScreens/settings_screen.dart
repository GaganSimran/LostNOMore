import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'EditProfileScreen.dart';
import 'login_screen.dart';
import 'app_config.dart';
import 'about_us_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final String bio;
  final int userId;
  final double brightness;
  final bool isDarkMode;
  final Function(double) onBrightnessChanged;
  final Function(bool) onThemeChanged;
  final Function(Map<String, dynamic>) onProfileUpdated;
  final String profileImage;

  const SettingsScreen({
    super.key,
    required this.username,
    required this.brightness,
    required this.isDarkMode,
    required this.onBrightnessChanged,
    required this.onThemeChanged,
    required this.profileImage,
    required this.userId,
    required this.onProfileUpdated,
    this.bio = '"Certified Oops, I dropped it specialist."',
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class GroupedContainer extends StatelessWidget {
  final Widget child;

  const GroupedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class SliderRow extends StatelessWidget {
  final IconData icon;
  final IconData iconRight;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderRow({
    super.key,
    required this.icon,
    required this.iconRight,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          Expanded(
            child: Slider(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey[400],
            ),
          ),
          Icon(iconRight, color: Colors.grey),
        ],
      ),
    );
  }
}

class SimpleListTile extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const SimpleListTile({
    super.key,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

class IconListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const IconListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blue[800], size: 20),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.5;

  String profileImage = "";
  late String username;
  late String bio;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    bio = widget.bio;
    profileImage = widget.profileImage;
  }

  void _showReportDialog(String type) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Submit $type"),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(hintText: "Write here..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await http.post(
                  Uri.parse(AppConfig.reports),
                  headers: {"Content-Type": "application/json"},
                  body: '{"type":"$type","message":"${controller.text}"}',
                );
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                                (route) => false,
                          );
                        },
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "Are you sure you want to permanently delete your account? This cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteAccount();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      await http.delete(
        Uri.parse("${AppConfig.users}/$uid"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      await user.delete();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete account")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage:
                profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                child:
                profileImage.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    Text(bio,
                        style: const TextStyle(
                            color: Colors.orange, fontSize: 12)),
                    TextButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              userId: widget.userId,
                              currentName: username,
                              currentBio: bio,
                              currentImage: profileImage,
                            ),
                          ),
                        );

                        if (updated != null) {
                          setState(() {
                            username = updated["name"] ?? username;
                            bio = updated["bio"] ?? bio;
                            profileImage = updated["image"] ?? profileImage;
                          });

                          widget.onProfileUpdated({
                            "name": username,
                            "bio": bio,
                            "image": profileImage,
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text(
                        'Edit profile',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          const SectionHeader(title: 'APPEARANCE'),
          GroupedContainer(
            child: Column(
              children: [
                SliderRow(
                  icon: Icons.volume_down,
                  iconRight: Icons.volume_up,
                  value: _volume,
                  onChanged: (v) => setState(() => _volume = v),
                ),
                const Divider(),
                SliderRow(
                  icon: Icons.wb_sunny_outlined,
                  iconRight: Icons.wb_sunny,
                  value: widget.brightness,
                  onChanged: widget.onBrightnessChanged,
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: widget.isDarkMode,
                  onChanged: widget.onThemeChanged,
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'SYSTEM'),
          GroupedContainer(
            child: Column(
              children: [
                SimpleListTile(
                    title: 'Clear Search History', color: Colors.blue),
                const Divider(),
                SimpleListTile(title: 'Clear Cache', color: Colors.blue),
                const Divider(),
                SimpleListTile(title: 'Delete Account', color: Colors.red, onTap: _showDeleteAccountDialog),
                const Divider(),
                SimpleListTile(
                  title: 'Logout',
                  color: Colors.red,
                  onTap: _showLogoutDialog,
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'CONTACT ME'),
          GroupedContainer(
            child: Column(
              children: [
                IconListTile(
                    icon: Icons.lightbulb_outline,
                    title: 'Suggest New Feature',
                    onTap: () => _showReportDialog("feature")),
                const Divider(),
                IconListTile(
                    icon: Icons.bug_report_outlined,
                    title: 'Report a bug',
                    onTap: () => _showReportDialog("bug")),
                const Divider(),
                IconListTile(
                    icon: Icons.info_outline,
                    title: 'About us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutUsScreen()),
                      );
                    }),
                const Divider(),
                IconListTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Report Issues',
                    onTap: () => _showReportDialog("issue")),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}