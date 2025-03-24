import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Import the new login page

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _termsAgreed = false; // Checkbox state

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUp() async {
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text.rich(
            TextSpan(
              text: 'I agree ',
              style: const TextStyle(color: Colors.white), // "I agree" in white
              children: [
                TextSpan(
                  text: 'Terms and Conditions',
                  style: const TextStyle(
                    color: Colors.green, // "Terms and Conditions" in green
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Register to enhance your personal safety',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Changed to pure white (#FFFFFF)
              ),
            ),
            const SizedBox(height: 30),

            // Full Name Field
            _buildTextField(
                _fullNameController, 'Enter Your full name', Icons.person),
            const SizedBox(height: 16),

            // Email Field
            _buildTextField(_emailController, 'Your Email', Icons.email,
                isEmail: true),
            const SizedBox(height: 16),

            // Phone Number Field
            _buildTextField(
                _phoneNumberController, 'Your Phone number', Icons.phone,
                isPhone: true),
            const SizedBox(height: 16),

            // Password Field
            _buildTextField(
                _passwordController, 'Create a password', Icons.lock,
                isPassword: true),
            const SizedBox(height: 16),

            // Confirm Password Field
            _buildTextField(
                _confirmPasswordController, 'Confirm Password', Icons.lock,
                isPassword: true),
            const SizedBox(height: 20),

            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: _termsAgreed,
                  onChanged: (value) {
                    setState(() {
                      _termsAgreed = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to Terms and Conditions page (if available)
                    print('Terms and Conditions Clicked');
                  },
                  child: const Text(
                    'I agree with Terms and Conditions',
                    style: TextStyle(
                      color: Color(0xFF559C62), // Green text
                      decoration: TextDecoration.underline, // Underline
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sign Up Button
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                    const Color(0xFF559C62), // Changed button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Changed to pure white
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Already registered? Log in link
            TextButton(
              onPressed: () {
                // Navigate to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: 'Already registered? ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // "Already registered?" in white
                  ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green, // "Log in" in green
                        decoration: TextDecoration.underline,
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false, bool isEmail = false, bool isPhone = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: Colors.grey[800],
        filled: true,
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      obscureText: isPassword,
    );
  }
}
