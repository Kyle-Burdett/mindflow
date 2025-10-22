import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mindflow/view-models/user_view_model.dart'; // Ensure this path is correct

// --- Constants (adjust to match your design in signIN-signUP.dart) ---
const double spacing = 4.0;
const Color primaryColor = Color(0xFFB66623); // Orange/Brown color
const Color backgroundColor = Color(0xFFFFF1E6); // Light Beige background

// ---------------- FORGOT PASSWORD PAGE ----------------
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  // State to manage the flow (Email input -> Code input)
  bool _isCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          // Use an AppBar if you want the back button, otherwise, custom leading
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () => context.pop(), // Pop back to the previous screen (Sign In)
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacing * 8),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Forgot password',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: spacing * 2),
                    const Text(
                      'Sign in to continue your wellness journey',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: spacing * 8),

                    // --- Email Input ---
                    const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: spacing * 2),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_outline, color: primaryColor),
                        hintText: 'Type here...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: spacing * 4),

                    // --- Send Code Button (Only visible before code is sent) ---
                    if (!_isCodeSent)
                      SizedBox(
                        width: 150, // Fixed width to match the image
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor.withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(vertical: spacing * 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: model.isLoading ? null : () async {
                            // --- CALL VIEW MODEL TO SEND RESET EMAIL ---
                            bool success = await model.sendPasswordResetEmail(context, _emailController.text);
                            if (success) {
                              setState(() {
                                _isCodeSent = true;
                              });
                            }
                          },
                          child: model.isLoading
                              ? const Center(child: SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          ))
                              : const Text(
                            'Send Code',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                    // --- Code Input (Visible after code is sent) ---
                    if (_isCodeSent)
                      Padding(
                        padding: const EdgeInsets.only(top: spacing * 4),
                        child: TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.visibility_off_outlined, color: primaryColor),
                            hintText: 'Enter code here...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: spacing * 8),

                    // --- Sign In / Reset Password Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(spacing * 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                        ),
                        onPressed: model.isLoading ? null : () {
                          // NOTE: Firebase Auth typically handles the 'code' (link click) directly.
                          // This button would usually be for the NEW password input after the link is clicked.
                          // Based on your UI (with a visible "Send Code" button), I'll make this
                          // button navigate back to sign in, assuming the actual password
                          // change happens via the email link.
                          if (_isCodeSent) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password reset email sent. Please check your inbox!')),
                            );
                            context.go('/sign-in');
                          } else {
                            // If code hasn't been sent, this button doesn't do anything useful in a standard flow.
                            // However, since the image says "Sign In," we can assume a simplified flow.
                            context.go('/sign-in');
                          }
                        },
                        child: const Text(
                          'Sign In',

                            style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: spacing * 6),

                    // --- Back to Sign In ---
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/sign-in'),
                        child: const Text(
                          '←Back to Sign In',
                          style: TextStyle(
                            color: primaryColor,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
