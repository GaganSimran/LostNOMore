import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/mock_admin.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/input.dart';
import '../models/admin_profile.dart';


class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;

  late final TextEditingController officeNameController;
  late final TextEditingController officeEmailController;
  late final TextEditingController officePhoneController;

  late bool emailNotifications;
  late bool newLostItemNotification;
  late bool markPostsPending;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    fullNameController = TextEditingController(
      text: user?.displayName ?? 'Francis Biller',
    );

    emailController = TextEditingController(
      text: user?.email ?? '',
    );


    officeNameController = TextEditingController(
      text: mockAdminProfile.officeName,
    );
    officeEmailController = TextEditingController(
      text: mockAdminProfile.officeEmail,
    );
    officePhoneController = TextEditingController(
      text: mockAdminProfile.officePhone,
    );


  }


//as i said before so when we click this it redirects to the navigation we selected
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
