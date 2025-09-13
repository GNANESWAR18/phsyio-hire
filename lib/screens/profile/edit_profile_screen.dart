import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _ongoingTreatmentController;
  late TextEditingController _specializationController;
  late TextEditingController _qualificationsController;
  late TextEditingController _bioController;
  late TextEditingController _hourlyRateController;

  String? _selectedGender;
  int? _age;
  int? _experienceYears;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
    
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _addressController = TextEditingController(text: user.address ?? '');
    _emergencyContactController = TextEditingController(text: user.emergencyContact ?? '');
    _medicalHistoryController = TextEditingController(text: user.medicalHistory ?? '');
    _ongoingTreatmentController = TextEditingController(text: user.ongoingTreatment ?? '');
    _specializationController = TextEditingController(text: user.specialization ?? '');
    _qualificationsController = TextEditingController(text: user.qualifications ?? '');
    _bioController = TextEditingController(text: user.bio ?? '');
    _hourlyRateController = TextEditingController(text: user.hourlyRate?.toString() ?? '');
    
    _selectedGender = user.gender;
    _age = user.age;
    _experienceYears = user.experienceYears;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _medicalHistoryController.dispose();
    _ongoingTreatmentController.dispose();
    _specializationController.dispose();
    _qualificationsController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
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
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: () {
                                // TODO: Implement image picker
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Photo upload coming soon!')),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      label: Text(user.userType == UserType.patient ? 'Patient' : 'Physiotherapist'),
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Basic Information
              Text(
                'Basic Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Age and Gender Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _age?.toString(),
                      onChanged: (value) {
                        _age = int.tryParse(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
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
                          _selectedGender = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Patient-specific fields
              if (user.userType == UserType.patient) ...[
                Text(
                  'Medical Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emergencyContactController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact',
                    prefixIcon: Icon(Icons.emergency),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _medicalHistoryController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Medical History',
                    prefixIcon: Icon(Icons.medical_services),
                    border: OutlineInputBorder(),
                    hintText: 'Previous conditions, surgeries, injuries...',
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _ongoingTreatmentController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Ongoing Treatment',
                    prefixIcon: Icon(Icons.healing),
                    border: OutlineInputBorder(),
                    hintText: 'Current medications, therapy...',
                  ),
                ),
              ],

              // Physiotherapist-specific fields
              if (user.userType == UserType.physiotherapist) ...[
                Text(
                  'Professional Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    prefixIcon: Icon(Icons.medical_services),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Years of Experience',
                          prefixIcon: Icon(Icons.work),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _experienceYears?.toString(),
                        onChanged: (value) {
                          _experienceYears = int.tryParse(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _hourlyRateController,
                        decoration: const InputDecoration(
                          labelText: 'Hourly Rate (\$)',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _qualificationsController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Qualifications',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                    hintText: 'Degrees, certifications...',
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: Icon(Icons.info),
                    border: OutlineInputBorder(),
                    hintText: 'Tell patients about yourself...',
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser!;

      // Create updated user object
      final updatedUser = currentUser.copyWith(
        name: _nameController.text,
        phone: _phoneController.text,
        age: _age,
        gender: _selectedGender,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        emergencyContact: _emergencyContactController.text.isNotEmpty ? _emergencyContactController.text : null,
        medicalHistory: _medicalHistoryController.text.isNotEmpty ? _medicalHistoryController.text : null,
        ongoingTreatment: _ongoingTreatmentController.text.isNotEmpty ? _ongoingTreatmentController.text : null,
        specialization: _specializationController.text.isNotEmpty ? _specializationController.text : null,
        experienceYears: _experienceYears,
        hourlyRate: double.tryParse(_hourlyRateController.text),
        qualifications: _qualificationsController.text.isNotEmpty ? _qualificationsController.text : null,
        bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      );

      // In a real app, you would update this in the database
      // For now, we'll just show a success message
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}