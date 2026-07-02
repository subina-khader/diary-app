import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class ProfileOptionsSheet extends StatelessWidget {
  const ProfileOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
      decoration: const BoxDecoration(
        color: Color(0xffFFF8F7),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

            CircleAvatar(
              radius: 34,
              backgroundColor: const Color(0xffF6E6E7),
              child: Icon(
                Icons.person,
                size: 34,
                color: Colors.brown.shade400,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "My Profile",
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Caveat",
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              "Manage your diary account",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 28),

            _optionTile(
              icon: Icons.edit_outlined,
              title: "Edit Profile",
              subtitle: "Update your name and profile",
              iconColor: const Color(0xffD8A7AF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
            },
            ),

            const SizedBox(height: 14),

            _optionTile(
              icon: Icons.cloud_upload_outlined,
              title: "Backup Diaries",
              subtitle: "Save your memories securely",
              iconColor: const Color(0xffCDB8A3),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 14),

            _optionTile(
              icon: Icons.restore_outlined,
              title: "Restore Backup",
              subtitle: "Recover your diary entries",
              iconColor: const Color(0xffAFC8B8),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 14),

            _optionTile(
              icon: Icons.logout_rounded,
              title: "Logout",
              subtitle: "Sign out of your account",
              iconColor: Colors.red.shade300,
              textColor: Colors.red.shade400,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Color textColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}