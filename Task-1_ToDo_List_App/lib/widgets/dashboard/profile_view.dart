import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../category_management_dialog.dart';
import 'dialogs.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _showDailyGoalDialog(BuildContext context, Box settingsBox) {
    final currentGoal = settingsBox.get('dailyGoal', defaultValue: 5);
    final controller = TextEditingController(text: currentGoal.toString());

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Set Daily Goal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How many tasks do you want to complete daily?',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Daily Goal',
                    hintText: 'Enter number of tasks',
                    prefixIcon: const Icon(
                      Icons.track_changes,
                      color: Color(0xFF7C4DFF),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C4DFF),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final goal = int.tryParse(controller.text);
                  if (goal != null && goal > 0) {
                    settingsBox.put('dailyGoal', goal);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Daily goal set to $goal tasks'),
                        backgroundColor: const Color(0xFF7C4DFF),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox('settings'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF9F5FF),
                  Color(0xFFF3E8FF),
                  Color(0xFFEEF2FF),
                ],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
              ),
            ),
          );
        }

        final box = snapshot.data!;
        String userName = box.get('userName', defaultValue: '') ?? '';
        String profileImagePath =
            box.get('profileImagePath', defaultValue: '') ?? '';

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF9F5FF), Color(0xFFF3E8FF), Color(0xFFEEF2FF)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header with profile
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Profile Picture
                        GestureDetector(
                          onTap: () {
                            DashboardDialogs.showImageSourceDialog(
                              context,
                              box,
                              () => setState(() {}),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child:
                                profileImagePath.isNotEmpty
                                    ? ClipOval(
                                      child: Image.file(
                                        File(profileImagePath),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Center(
                                      child: Text(
                                        userName.isNotEmpty
                                            ? userName
                                                .substring(
                                                  0,
                                                  userName.length >= 2 ? 2 : 1,
                                                )
                                                .toUpperCase()
                                            : '',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7C4DFF),
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          userName.isEmpty ? 'User' : userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            DashboardDialogs.showEditNameDialog(
                              context,
                              box,
                              () => setState(() {}),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C4DFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Color(0xFF7C4DFF),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Color(0xFF7C4DFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Options List
                  ProfileOption(
                    icon: Icons.track_changes,
                    title: 'Daily Goal',
                    subtitle: ValueListenableBuilder<Box>(
                      valueListenable: box.listenable(),
                      builder: (context, settingsBox, _) {
                        final dailyGoal = settingsBox.get(
                          'dailyGoal',
                          defaultValue: 5,
                        );
                        return Text('$dailyGoal tasks per day');
                      },
                    ),
                    onTap: () {
                      _showDailyGoalDialog(context, box);
                    },
                  ),
                  ProfileOption(
                    icon: Icons.category_outlined,
                    title: 'Manage Categories',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CategoryManagementDialog(),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Help center coming soon!'),
                        ),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Task Manager',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(
                          Icons.check_circle,
                          size: 48,
                          color: Color(0xFF7C4DFF),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final dynamic subtitle;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF7C4DFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7C4DFF), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        subtitle:
            subtitle != null
                ? (subtitle is String
                    ? Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    )
                    : subtitle)
                : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
