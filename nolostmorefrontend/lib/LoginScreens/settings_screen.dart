import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final String bio;

  const SettingsScreen({super.key, required this.username, this.bio = '"Certified Oops, I dropped it specialist."'});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.5;
  double _brightness = 0.5;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    Text(widget.bio, style: const TextStyle(color: Colors.orange, fontSize: 12)),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                      child: const Text('Edit profile', style: TextStyle(color: Colors.blue, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),

          // Appearance Section
          const _SectionHeader(title: 'APPEARANCE'),
          _GroupedContainer(
            child: Column(
              children: [
                _SliderRow(
                  icon: Icons.volume_down,
                  iconRight: Icons.volume_up,
                  value: _volume,
                  onChanged: (v) => setState(() => _volume = v),
                ),
                const Divider(),
                _SliderRow(
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
                  trailing: const Text('Light >', style: TextStyle(color: Colors.blue)),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // System Section
          const _SectionHeader(title: 'SYSTEM'),
          _GroupedContainer(
            child: Column(
              children: [
                _SimpleListTile(title: 'Clear Search History', color: Colors.blue),
                const Divider(),
                _SimpleListTile(title: 'Clear Cache', color: Colors.blue),
                const Divider(),
                _SimpleListTile(title: 'Delete Account', color: Colors.red),
              ],
            ),
          ),

          // Contact Section
          const _SectionHeader(title: 'CONTACT ME'),
          _GroupedContainer(
            child: Column(
              children: [
                _IconListTile(icon: Icons.lightbulb_outline, title: 'Suggest New Feature'),
                const Divider(),
                _IconListTile(icon: Icons.bug_report_outlined, title: 'Report a bug'),
                const Divider(),
                _IconListTile(icon: Icons.info_outline, title: 'About us'),
                const Divider(),
                _IconListTile(icon: Icons.chat_bubble_outline, title: 'Report Issues'),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// --- Helper Widgets ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _GroupedContainer extends StatelessWidget {
  final Widget child;
  const _GroupedContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}

class _SliderRow extends StatelessWidget {
  final IconData icon;
  final IconData iconRight;
  final double value;
  final ValueChanged<double> onChanged;

  const _SliderRow({required this.icon, required this.iconRight, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          Expanded(child: Slider(value: value, onChanged: onChanged, activeColor: Colors.blue, inactiveColor: Colors.grey[400])),
          Icon(iconRight, color: Colors.grey),
        ],
      ),
    );
  }
}

class _SimpleListTile extends StatelessWidget {
  final String title;
  final Color color;
  const _SimpleListTile({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }
}

class _IconListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _IconListTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blue[800], size: 20),
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      onTap: () {},
    );
  }
}