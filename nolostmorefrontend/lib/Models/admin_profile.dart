//i created the models to structure my data
class AdminProfile {
  final String fullName;
  final String email;
  final String password;
  final String officeName;
  final String officeEmail;
  final String officePhone;
  final bool emailNotifications;
  final bool newLostItemNotification;
  final bool markPostsPending;

  const AdminProfile({
    required this.fullName,
    required this.email,
    required this.password,
    required this.officeName,
    required this.officeEmail,
    required this.officePhone,
    required this.emailNotifications,
    required this.newLostItemNotification,
    required this.markPostsPending,
  });
}