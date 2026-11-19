import 'package:flutter/material.dart';
import '../services/backup_service.dart';
import '../services/database_helper.dart';
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



            const SizedBox(height: 12),


            const Text(
              "Manage Data",
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Caveat",
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              "Keep your memories safe",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 28),


            _optionTile(
              icon: Icons.cloud_upload_outlined,
              title: "Backup Diaries",
              subtitle: "Save your memories securely",
              iconColor: const Color(0xffCDB8A3),
              onTap: () async {
                try {
                  final success = await BackupService.createBackup();

                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Backup created successfully'
                            : 'Backup cancelled',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Backup failed'),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 14),

            _optionTile(
              icon: Icons.restore_outlined,
              title: "Restore Backup",
              subtitle: "Recover your diary entries",
              iconColor: const Color(0xffAFC8B8),
              onTap: () async {
                final shouldRestore = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Restore Backup',
                        style: TextStyle(
                          fontFamily: 'Caveat',
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: const Text(
                        'Your current diaries will not be deleted. '
                            'The backup will be added to them.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Restore'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldRestore != true) return;

                try {
                  final result = await BackupService.restoreBackup();

                  if (!context.mounted) return;

                  if (result == RestoreResult.success) {
                    Navigator.pop(context, true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Backup restored successfully'),
                      ),
                    );
                  } else if (result == RestoreResult.alreadyRestored) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This backup has already been restored'),
                      ),
                    );
                  }
                } catch (e) {
                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Restore failed'),
                    ),
                  );
                }
              },            ),
            const SizedBox(height: 14),

            const SizedBox(height: 14),

            _optionTile(
              icon: Icons.delete_outline_rounded,
              title: "Delete All Data",
              subtitle: "Permanently delete all your diary entries",
              iconColor: Colors.red.shade300,
              textColor: Colors.red.shade400,
              onTap: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Delete All Data?',
                        style: TextStyle(
                          fontFamily: 'Caveat',
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: const Text(
                        'Are you sure you want to delete all your diaries '
                            'and diary entries? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Delete All'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldDelete != true) return;

                final messenger = ScaffoldMessenger.of(context);

                try {
                  await DatabaseHelper.instance.deleteAllData();

                  if (!context.mounted) return;

                  Navigator.pop(context, true);

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('All diary data deleted successfully'),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete diary data'),
                    ),
                  );
                }
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