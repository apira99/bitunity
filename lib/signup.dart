import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'login.dart'; // Import the login.dart file
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'encryptionhelper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _childNameController = TextEditingController();
  final _parentEmailController = TextEditingController();
  final _parentMobileController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late DatabaseHelper _dbHelper;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _parentEmailController.dispose();
    _parentMobileController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF9C7AA4))),
        const SizedBox(height: 4.0),
        Container(
          width: 330,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF76587D),
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFFFFFFF).withOpacity(0.45),
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
              border: InputBorder.none,
              isDense: true,
              errorStyle: const TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            validator: validator,
            autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            onChanged: (value) {
              if (_submitted) {
                _formKey.currentState!.validate();
              }
            },
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter parent email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _resetForm() {
    _childNameController.clear();
    _parentEmailController.clear();
    _parentMobileController.clear();
    _ageController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _submitted = false;
    });
  }

  void _submitForm() async {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> signupDetails = {
        'childName': _childNameController.text,
        'parentEmail': _parentEmailController.text,
        'parentMobile': _parentMobileController.text,
        'age': _ageController.text,
        'password': _passwordController.text,
      };

      int result = await _dbHelper.insertSignupDetails(signupDetails);

      if (result != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to signup. Please try again.')),
        );
      }
      _resetForm();
    }
  }

  Future<void> _signupWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        // Handle user data here, such as sending it to your backend for account creation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook signup successful: ${userData['name']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook signup failed: ${result.status}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during Facebook signup: $e')),
      );
    }
  }

  Future<void> _signupWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Handle user data here, such as sending it to your backend for account creation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google signup successful: ${googleUser.displayName}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google signup failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during Google signup: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Child Name',
                  controller: _childNameController,
                  hintText: 'Enter child name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter child name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Parent\'s Email',
                  controller: _parentEmailController,
                  hintText: 'example@example.com',
                  validator: _validateEmail,
                ),
                _buildTextField(
                  label: 'Parent\'s Mobile Number',
                  controller: _parentMobileController,
                  hintText: '+123 456 789',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter parent mobile number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Age',
                  controller: _ageController,
                  hintText: 'Age in years',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age in years';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: '●●●●●●●●',
                  obscureText: true,
                  validator: _validatePassword,
                ),
                _buildTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  hintText: '●●●●●●●●',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Text(
                    'By continuing, you agree to Terms of Use and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: Color(0xFF461555),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Center(
                  child: Column(
                    children: [
                      _buildCustomButton('Reset', _resetForm),
                      _buildCustomButton('Sign Up', _submitForm),
                      const SizedBox(height: 4.0),
                      const Text(
                        'or sign up with',
                        style: TextStyle(
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                          color: Color(0xFF461555),
                          height: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton('assets/images/facebook.png', _signupWithFacebook),
                          _buildSocialButton('assets/images/google.png', _signupWithGoogle),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w300,
                              fontSize: 16.0,
                              color: Color(0xFF461555),
                              height: 0.5,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Color(0xFF461555),
                                height: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFF461555),
        borderRadius: BorderRadius.circular(19.0),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        minWidth: 186.0,
        height: 40.0,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(right: 19.0),
        padding: const EdgeInsets.all(10.0),
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}