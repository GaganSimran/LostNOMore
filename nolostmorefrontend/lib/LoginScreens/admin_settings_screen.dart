import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/input.dart';
import '../data/mock_admin.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController officeNameController;
  late final TextEditingController officeEmailController;
  late final TextEditingController officePhoneController;

  late bool emailNotifications;
  late bool newLostItemNotification;
  late bool markPostsPending;

  @override
  void initState() {
    super.initState();

    fullNameController =
        TextEditingController(text: mockAdminProfile.fullName);
    emailController =
        TextEditingController(text: mockAdminProfile.email);
    passwordController =
        TextEditingController(text: mockAdminProfile.password);
    officeNameController =
        TextEditingController(text: mockAdminProfile.officeName);
    officeEmailController =
        TextEditingController(text: mockAdminProfile.officeEmail);
    officePhoneController =
        TextEditingController(text: mockAdminProfile.officePhone);

    emailNotifications = mockAdminProfile.emailNotifications;
    newLostItemNotification = mockAdminProfile.newLostItemNotification;
    markPostsPending = mockAdminProfile.markPostsPending;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    officeNameController.dispose();
    officeEmailController.dispose();
    officePhoneController.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'Manage Posts':
        Navigator.pushNamed(context, '/panel');
        break;
      case 'Reports':
        Navigator.pushNamed(context, '/reports');
        break;
      case 'Settings':
        break;
    }
  }

  Widget _buildToggleRow(
      String label,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          label: 'Password',
          controller: passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D47FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          child: const Text('Change Password'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          AppSidebar(
            selected: 'Settings',
            onItemTap: (item) => _handleNavigation(context, item),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(title: 'Admin Settings'),
                  const SizedBox(height: 30),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 25),

                            const Text(
                              'Admin Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            CustomInput(
                              label: 'Full Name',
                              controller: fullNameController,
                            ),
                            const SizedBox(height: 15),

                            CustomInput(
                              label: 'Email',
                              controller: emailController,
                            ),
                            const SizedBox(height: 15),

                            _buildPasswordField(),

                            const SizedBox(height: 30),

                            const Text(
                              'Security Office',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            CustomInput(
                              label: 'Office Name',
                              controller: officeNameController,
                            ),
                            const SizedBox(height: 15),

                            CustomInput(
                              label: 'Contact Email',
                              controller: officeEmailController,
                            ),
                            const SizedBox(height: 15),

                            CustomInput(
                              label: 'Contact Phone',
                              controller: officePhoneController,
                            ),
                            const SizedBox(height: 30),

                            const Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            _buildToggleRow(
                              'Email Notifications',
                              emailNotifications,
                                  (value) {
                                setState(() {
                                  emailNotifications = value;
                                });
                              },
                            ),
                            _buildToggleRow(
                              'New Lost Item Notification',
                              newLostItemNotification,
                                  (value) {
                                setState(() {
                                  newLostItemNotification = value;
                                });
                              },
                            ),
                            _buildToggleRow(
                              'Mark Posts as Pending',
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}