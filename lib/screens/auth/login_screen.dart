import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLogin = true; // true for login, false for signup
  UserType _selectedUserType = UserType.patient;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo and Title
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PhysioHire',
                      style: AppTheme.textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Welcome back! Sign in to continue'
                          : 'Create your account to get started',
                      style: AppTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Login/Signup Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // User Type Selection (only for signup)
                      if (!_isLogin) ...[
                        Text(
                          'I am a:',
                          style: AppTheme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildUserTypeCard(
                                UserType.patient,
                                'Patient',
                                Icons.person,
                                'Looking for physiotherapy',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildUserTypeCard(
                                UserType.physiotherapist,
                                'Physiotherapist',
                                Icons.medical_services,
                                'Licensed professional',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Name field (only for signup)
                      if (!_isLogin) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Phone field (only for signup)
                      if (!_isLogin) ...[
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!_isLogin && value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Submit Button
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          if (authProvider.error != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.error!),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              authProvider.clearError();
                            });
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  authProvider.isLoading ? null : _handleSubmit,
                              child: authProvider.isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      _isLogin ? 'Sign In' : 'Create Account'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Toggle Login/Signup
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? "Don't have an account? Sign up"
                              : "Already have an account? Sign in",
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Demo Login Buttons
                      _buildDemoSection(),
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

  Widget _buildUserTypeCard(
      UserType type, String title, IconData icon, String subtitle) {
    final isSelected = _selectedUserType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isSelected ? AppTheme.primaryColor : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Quick Demo Login',
          style: AppTheme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _quickLogin(true),
                icon: const Icon(Icons.person),
                label: const Text('Demo Patient'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _quickLogin(false),
                icon: const Icon(Icons.medical_services),
                label: const Text('Demo Physio'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Demo credentials:\nPatient: patient@demo.com\nPhysio: physio@demo.com\nPassword: demo123',
          style: AppTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_isLogin) {
      await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      await authProvider.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        userType: _selectedUserType,
      );
    }

    if (authProvider.isLoggedIn && mounted) {
      final user = authProvider.currentUser;

      // Check if patient needs to complete profile
      if (user?.userType == UserType.patient &&
          (user?.age == null || user?.address == null)) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.profileSetup,
          arguments: {'user': user},
        );
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    }
  }

  void _quickLogin(bool isPatient) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (isPatient) {
      await authProvider.quickLoginAsPatient();
    } else {
      await authProvider.quickLoginAsPhysio();
    }

    if (authProvider.isLoggedIn && mounted) {
      final user = authProvider.currentUser;

      // Check if patient needs to complete profile
      if (user?.userType == UserType.patient &&
          (user?.age == null || user?.address == null)) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.profileSetup,
          arguments: {'user': user},
        );
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    }
  }
}
