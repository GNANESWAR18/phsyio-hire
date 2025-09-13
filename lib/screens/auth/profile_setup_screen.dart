import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../home/home_screen.dart';
import '../../config/routes.dart';

class ProfileSetupScreen extends StatefulWidget {
  final User user;

  const ProfileSetupScreen({super.key, required this.user});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _ongoingTreatmentController = TextEditingController();

  String _selectedGender = 'Male';
  bool _hasMedicalHistory = false;
  bool _hasOngoingTreatment = false;

  @override
  void dispose() {
    _ageController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _medicalHistoryController.dispose();
    _ongoingTreatmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        widget.user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome, ${widget.user.name}!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let\'s complete your profile to get started',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Age Field
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Gender Selection
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your full address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Emergency Contact
              TextFormField(
                controller: _emergencyContactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact',
                  prefixIcon: Icon(Icons.emergency),
                  border: OutlineInputBorder(),
                  hintText: 'Phone number of emergency contact person',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter emergency contact';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Medical History Section
              Text(
                'Medical Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Medical History Toggle
              SwitchListTile(
                title: const Text('Do you have any medical history?'),
                subtitle:
                    const Text('Previous injuries, surgeries, or conditions'),
                value: _hasMedicalHistory,
                onChanged: (bool value) {
                  setState(() {
                    _hasMedicalHistory = value;
                  });
                },
              ),

              if (_hasMedicalHistory) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _medicalHistoryController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Medical History',
                    prefixIcon: Icon(Icons.medical_services),
                    border: OutlineInputBorder(),
                    hintText: 'Describe your medical history...',
                  ),
                  validator: (value) {
                    if (_hasMedicalHistory &&
                        (value == null || value.isEmpty)) {
                      return 'Please describe your medical history';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // Ongoing Treatment Toggle
              SwitchListTile(
                title: const Text('Are you currently under any treatment?'),
                subtitle: const Text('Medications, therapy, or ongoing care'),
                value: _hasOngoingTreatment,
                onChanged: (bool value) {
                  setState(() {
                    _hasOngoingTreatment = value;
                  });
                },
              ),

              if (_hasOngoingTreatment) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ongoingTreatmentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Ongoing Treatment',
                    prefixIcon: Icon(Icons.healing),
                    border: OutlineInputBorder(),
                    hintText: 'Describe your current treatment...',
                  ),
                  validator: (value) {
                    if (_hasOngoingTreatment &&
                        (value == null || value.isEmpty)) {
                      return 'Please describe your ongoing treatment';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Complete Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 16),

              // Skip Button
              TextButton(
                onPressed: _skipProfile,
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Update user profile with new information
      final updatedUser = widget.user.copyWith(
        age: int.tryParse(_ageController.text),
        gender: _selectedGender,
        address: _addressController.text,
        emergencyContact: _emergencyContactController.text,
        medicalHistory:
            _hasMedicalHistory ? _medicalHistoryController.text : null,
        ongoingTreatment:
            _hasOngoingTreatment ? _ongoingTreatmentController.text : null,
      );

      // In a real app, you would save this to the database
      // await _authProvider.updateUserProfile(updatedUser);

      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _skipProfile() {
    // Navigate to home screen without updating profile
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }
}
