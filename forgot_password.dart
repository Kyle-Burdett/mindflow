import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mindflow/view-models/user_view_model.dart';

// --- Constants ---
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
  // 1. ADDED: Key to manage the form state for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State to manage the flow (Email input -> Code input)
  bool _isCodeSent = false;

  // Simple regex to check for email format
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: backgroundColor,

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
                // 2. WRAPPED: Column in Form
                child: Form(
                  key: _formKey,
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
                      // 3. CHANGED: TextField to TextFormField & ADDED Validator
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address.'; // Handles blank field (AUTH_FGP_004 style)
                          }
                          if (!_emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address.'; // Handles invalid format (AUTH_FGP_003 fix)
                          }
                          return null; // Input is valid
                        },
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

                      // --- Send code button ---
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
                              // 4. ADDED: Validation check before calling view model
                              if (_formKey.currentState!.validate()) {
                                // --- CALL VIEW MODEL TO SEND RESET EMAIL ---
                                bool success = await model.sendPasswordResetEmail(context, _emailController.text);
                                if (success) {
                                  setState(() {
                                    _isCodeSent = true;
                                  });
                                }
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
                            if (_isCodeSent) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password reset email sent. Please check your inbox!')),
                              );
                              context.go('/sign-in');
                            } else {
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
          ),
        );
      },
    );
  }
}