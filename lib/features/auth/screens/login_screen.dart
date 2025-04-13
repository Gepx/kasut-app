import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:tugasuts/features/auth/providers/auth_provider.dart'; // Import AuthNotifier
import 'package:tugasuts/features/auth/screens/register_screen.dart'; // Import RegisterScreen

// TODO: Implement Login Screen UI
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const double _buttonHeight = 50.0; // Define as class constant
  bool _isPasswordVisible = false;

  void _navigateToRegister() {
     // Pop the current login screen and push the register screen
     Navigator.pop(context); // Assuming Login is pushed onto Profile
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get AuthNotifier instance (don't listen for changes here)
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // Removed buttonHeight definition from here
    const Color linkColor = Color(0xFF008080); // Teal-like color from image

    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Go back
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false, // Align title to the left (standard)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form( // Wrap in a Form
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch
            children: [
              // Email Field
              Text('Email', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField( // Changed to TextFormField
                controller: _emailController, // Assign controller
                keyboardType: TextInputType.emailAddress,
                validator: (value) { // Add validator
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                     return 'Please enter a valid email address';
                  }
                  return null;
                },
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.primary), // Highlight on focus
                  ),
                   errorBorder: OutlineInputBorder( // Style for validation errors
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.error, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              Text('Password', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField( // Changed to TextFormField
                controller: _passwordController, // Assign controller
                obscureText: !_isPasswordVisible,
                 validator: (value) { // Add validator
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                   enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                   errorBorder: OutlineInputBorder( // Style for validation errors
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.error, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password logic
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: linkColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // "Or continue with" Separator
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Or continue with', style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),

              // Social Login Buttons
              _buildSocialButton(iconPath: 'assets/icons/apple.png', text: 'Apple'), // TODO: Add actual icons
              const SizedBox(height: 12),
              _buildSocialButton(iconPath: 'assets/icons/google.png', text: 'Google'),
              const SizedBox(height: 12),
              _buildSocialButton(iconPath: 'assets/icons/facebook.png', text: 'Facebook'),
              const SizedBox(height: 32),

              // Login Button Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate the form first
                        if (_formKey.currentState!.validate()) {
                          // If valid, simulate login
                          authNotifier.login();
                          // Navigate back
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Enabled color
                        foregroundColor: Colors.white, // Enabled text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, _buttonHeight),
                        elevation: 2, // Add some elevation when enabled
                      ),
                      child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Fingerprint Button
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement fingerprint login
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.all(14), // Adjust padding for square-ish look
                      minimumSize: const Size(_buttonHeight, _buttonHeight), // Make it square-ish
                    ),
                    child: const Icon(Icons.fingerprint, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: textTheme.bodyMedium),
                  TextButton(
                    onPressed: _navigateToRegister,
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text(
                      'Register Here',
                      style: TextStyle(color: linkColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
           ), // Closing parenthesis for Form
        ),
      ),
    ),
    );
  }

  // Helper for Social Buttons (assuming icons are available)
  Widget _buildSocialButton({required String iconPath, required String text}) {
    // TODO: Replace placeholder Icon with Image.asset(iconPath) once icons are added
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: Implement social login for 'text'
      },
      icon: Icon(Icons.apple, color: Colors.black), // Placeholder icon
      label: Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, _buttonHeight), // Stretch width
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}