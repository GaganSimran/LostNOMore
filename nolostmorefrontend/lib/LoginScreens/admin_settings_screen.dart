import 'package:flutter/material.dart';
import 'admin_panel_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}
//these control the swtiches of the settings
class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool emailNotifications = true;
  bool newLostItemNotification = true;
  bool markPostsPending = true;
// text controllers to put everything inside
  final TextEditingController fullNameController =
  TextEditingController(text: "Admin");
  final TextEditingController emailController =
  TextEditingController(text: "biller@gmail.com");
  final TextEditingController passwordController =
  TextEditingController(text: "*************");
  final TextEditingController officeNameController =
  TextEditingController(text: "Main Security Office");

  final TextEditingController officeEmailController =
  TextEditingController(text: "biller@gmail.com");

  final TextEditingController officePhoneController =
  TextEditingController(text: "(123) 333 - 7777");
  @override
  //building the UI
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Row(
          children: [
            const _Sidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopBar(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Admin Profile",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        _buildInputField(
                                          "Full Name",
                                          fullNameController,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildInputField(
                                          "Email",
                                          emailController,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildPasswordField(),
                                        const SizedBox(height: 28),
                                        const Text(
                                          "Security Office Settings",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        _buildToggleRow(
                                          "Email Notifications",
                                          emailNotifications,
                                              (value) {
                                            setState(() {
                                              emailNotifications = value;
                                            });
                                          },
                                        ),
                                        _buildToggleRow(
                                          "New lost item notification",
                                          newLostItemNotification,
                                              (value) {
                                            setState(() {
                                              newLostItemNotification = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Security Office",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        _buildInputField("Office name", officeNameController),
                                        const SizedBox(height: 12),

                                        _buildInputField("Contact Phone", officePhoneController),
                                        const SizedBox(height: 12),

                                        _buildInputField("Contact Email", officeEmailController),
                                        const SizedBox(height: 12),
                                        const SizedBox(height: 28),
                                        const Text(
                                          "Management Settings",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        _buildToggleRow(
                                          "Mark posts as pending",
                                          markPostsPending,
                                              (value) {
                                            setState(() {
                                              markPostsPending = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D9D9),
                foregroundColor: Colors.black87,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Change Password"),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildToggleRow(
      String label,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1400FF), Color(0xFF0B00B0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Lost & Found",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            //WHENEVER THEY HIT MANAGE POAST RE DIRECT TO THAT PAGE
            const SizedBox(height: 42),
            _SidebarItem(
              title: "Manage Posts",
              icon: Icons.workspace_premium,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPanelScreen(),
                  ),
                );
              },
            ),

            const _SidebarItem(
              title: "Dashboard",
              icon: Icons.home_outlined,
            ),
            const _SidebarItem(
              title: "Reports",
              icon: Icons.assignment_outlined,
            ),
            const _SidebarItem(
              title: "Settings",
              icon: Icons.settings_outlined,
              selected: true,
            ),
            const Spacer(),
            const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 4),
                      Text(
                        "biller@gmail.com",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//EACH MENU ON THE SIDE SAME AS ADMIN PANEL
class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.title,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              icon,
              color: selected ? Colors.orangeAccent : Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Settings",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Icon(Icons.search, color: Colors.black54, size: 28),
        const SizedBox(width: 20),
        SizedBox(
          width: 180,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              border: InputBorder.none,
              isDense: true,
              hintStyle: const TextStyle(color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black54, width: 2),
          ),
          child: const Icon(Icons.person_outline, size: 34),
        ),
      ],
    );
  }
}