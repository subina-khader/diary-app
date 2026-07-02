import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    if (user != null) {
      nameController.text = user!.displayName ?? "";
      emailController.text = user!.email ?? "";
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffFDF2F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFDF2F5),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [



                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xffF4D8DD),
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Color(0xff8D6E63),
                      ),
                    ),




                const SizedBox(height: 6),

                const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Caveat",
                    fontWeight: FontWeight.w600,
                    color: Color(0xff5D4037),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "Update your personal information",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white,
                    )
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personal Information",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                      controller: nameController,
                      decoration: inputDecoration(
                        hint: "Full Name",
                        icon: Icons.person_outline,
                      ),
                    ),


                  const SizedBox(height: 18),

                  TextFormField(
                    controller: emailController,
                    decoration: inputDecoration(
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),
                  ),





                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC97A8D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        try {
                          if (nameController.text.trim() != user!.displayName) {
                            await user!.updateDisplayName(
                              nameController.text.trim(),
                            );
                          }

                          if (emailController.text.trim() != user!.email) {
                            await user!.verifyBeforeUpdateEmail(
                              emailController.text.trim(),
                            );
                          }

                          if (passwordController.text.isNotEmpty) {
                            await user!.updatePassword(
                              passwordController.text,
                            );
                          }

                          await user!.reload();

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile updated successfully."),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message ?? "Update failed")),
                          );
                        }
                      },
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                        const SizedBox(height: 10),

                      ]),
                ),

                const SizedBox(height: 25),


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.white,
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Account & Security",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: Color(0xffC97A8D),
                      ),
                      title: const Text(
                        "Change Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        "Reset your password via email",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final email = FirebaseAuth.instance.currentUser?.email;

                        if (email != null) {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: email,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Password reset link has been sent to your email.",
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  ],),
                ),
                const SizedBox(height: 35),

              ],
            ),
          ),
        ),
      ),
    );
  }
}