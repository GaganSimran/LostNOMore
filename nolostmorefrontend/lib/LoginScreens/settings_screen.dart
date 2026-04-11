import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final String bio;

  const SettingsScreen({
    super.key,
    required this.username,
    this.bio = '"Certified Oops, I dropped it specialist."',
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.5;
  double _brightness = 0.5;
  bool _isDarkMode = false;

  String profileImage = ""; // you can load from backend later

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

          // ================= PROFILE =================
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : const NetworkImage('https://via.placeholder.com/150'),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.username,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),

                    Text(widget.bio,
                        style: const TextStyle(
                            color: Colors.orange, fontSize: 12)),

                    TextButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              userId: 1,
                              currentName: widget.username,
                              currentBio: widget.bio,
                              currentImage: profileImage,
                            ),
                          ),
                        );

                        if (updated == true) {
                          setState(() {});
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

          // ================= APPEARANCE =================
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
                  value: _brightness,
                  onChanged: (v) => setState(() => _brightness = v),
                ),

                const Divider(),

                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: _isDarkMode,
                  onChanged: (v) => setState(() => _isDarkMode = v),
                  activeColor: Colors.blue,
                ),

                const Divider(),

                ListTile(
                  title: const Text('Color Theme'),
                  trailing: const Text('Light >',
                      style: TextStyle(color: Colors.blue)),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ================= SYSTEM =================
          const SectionHeader(title: 'SYSTEM'),

          GroupedContainer(
            child: Column(
              children: [
                SimpleListTile(
                    title: 'Clear Search History', color: Colors.blue),

                const Divider(),

                SimpleListTile(
                    title: 'Clear Cache', color: Colors.blue),

                const Divider(),

                SimpleListTile(
                    title: 'Delete Account', color: Colors.red),
              ],
            ),
          ),

          // ================= CONTACT =================
          const SectionHeader(title: 'CONTACT ME'),

          GroupedContainer(
            child: Column(
              children: [
                IconListTile(
                    icon: Icons.lightbulb_outline,
                    title: 'Suggest New Feature'),

                const Divider(),

                IconListTile(
                    icon: Icons.bug_report_outlined,
                    title: 'Report a bug'),

                const Divider(),

                IconListTile(
                    icon: Icons.info_outline,
                    title: 'About us'),

                const Divider(),

                IconListTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Report Issues'),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

//
// ================= HELPER WIDGETS =================
//

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
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

  const SimpleListTile({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: () {},
    );
  }
}

class IconListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const IconListTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blue[800], size: 20),
      title: const Text(
        "",
        style: TextStyle(color: Colors.grey),
      ),
      subtitle: Text(title),
      onTap: () {},
    );
  }
}