import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class MockAuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'all_users';
  
  // Mock database of users
  static final List<User> _mockUsers = [
    User(
      id: '1',
      email: 'patient@demo.com',
      name: 'John Doe',
      phone: '+1234567890',
      userType: UserType.patient,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      age: 35,
      gender: 'Male',
      address: '123 Main St, New York, NY 10001',
      emergencyContact: '+1234567891',
      medicalHistory: 'Previous sports injury to right knee, mild hypertension',
      ongoingTreatment: 'None currently',
    ),
    User(
      id: '2',
      email: 'physio@demo.com', 
      name: 'Dr. Sarah Wilson',
      phone: '+1234567891',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      specialization: 'Sports Physiotherapy',
      experienceYears: 8,
      hourlyRate: 80.0,
      qualifications: 'DPT from NYU, Sports Medicine Certification',
      licenseNumber: 'PT12345NY',
      isVerified: true,
      rating: 4.8,
      totalReviews: 45,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      workingHours: '9:00 AM - 6:00 PM',
      bio: 'Specialized in sports injuries and rehabilitation with 8+ years of experience. I help athletes and active individuals recover from injuries and improve performance.',
      certificates: ['Sports Medicine', 'Manual Therapy', 'Dry Needling'],
    ),
    User(
      id: '3',
      email: 'physio2@demo.com',
      name: 'Dr. Mike Johnson',
      phone: '+1234567892', 
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      specialization: 'Orthopedic Physiotherapy',
      experienceYears: 12,
      hourlyRate: 95.0,
      qualifications: 'DPT from Columbia University, Orthopedic Clinical Specialist',
      licenseNumber: 'PT67890NY',
      isVerified: true,
      rating: 4.9,
      totalReviews: 78,
      availableDays: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
      workingHours: '8:00 AM - 5:00 PM',
      bio: 'Orthopedic specialist with over 12 years of experience treating musculoskeletal conditions. Expert in post-surgical rehabilitation and chronic pain management.',
      certificates: ['Orthopedic Clinical Specialist', 'McKenzie Method', 'Graston Technique'],
    ),
    User(
      id: '4',
      email: 'physio3@demo.com',
      name: 'Dr. Emily Chen',
      phone: '+1234567893',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      specialization: 'Neurological Physiotherapy',
      experienceYears: 6,
      hourlyRate: 85.0,
      qualifications: 'DPT from UCSF, Neurological Rehabilitation Certificate',
      licenseNumber: 'PT11111CA',
      isVerified: true,
      rating: 4.7,
      totalReviews: 32,
      availableDays: ['Tuesday', 'Thursday', 'Friday', 'Sunday'],
      workingHours: '10:00 AM - 7:00 PM',
      bio: 'Neurological physiotherapy specialist focusing on stroke recovery, spinal cord injuries, and movement disorders. Passionate about helping patients regain independence.',
      certificates: ['Neurological Rehabilitation', 'Bobath Technique', 'FES Therapy'],
    ),
    User(
      id: '5',
      email: 'physio4@demo.com',
      name: 'Dr. James Rodriguez',
      phone: '+1234567894',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      specialization: 'Pediatric Physiotherapy',
      experienceYears: 10,
      hourlyRate: 75.0,
      qualifications: 'DPT from University of Miami, Pediatric Physical Therapy Certification',
      licenseNumber: 'PT22222FL',
      isVerified: true,
      rating: 4.9,
      totalReviews: 89,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      workingHours: '9:00 AM - 4:00 PM',
      bio: 'Pediatric physiotherapy expert specializing in developmental delays, cerebral palsy, and sports injuries in children and adolescents.',
      certificates: ['Pediatric Physical Therapy', 'NDT Certification', 'Sensory Integration'],
    ),
    User(
      id: '6',
      email: 'physio5@demo.com',
      name: 'Dr. Lisa Thompson',
      phone: '+1234567895',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      specialization: 'Geriatric Physiotherapy',
      experienceYears: 15,
      hourlyRate: 90.0,
      qualifications: 'DPT from Northwestern University, Board Certified Geriatric Clinical Specialist',
      licenseNumber: 'PT33333IL',
      isVerified: true,
      rating: 4.8,
      totalReviews: 67,
      availableDays: ['Monday', 'Wednesday', 'Friday'],
      workingHours: '8:30 AM - 3:30 PM',
      bio: 'Geriatric specialist with 15 years of experience helping older adults maintain mobility, prevent falls, and manage age-related conditions.',
      certificates: ['Geriatric Clinical Specialist', 'Fall Prevention', 'Vestibular Rehabilitation'],
    ),
    User(
      id: '7',
      email: 'patient2@demo.com',
      name: 'Jane Smith',
      phone: '+1234567896',
      userType: UserType.patient,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      age: 42,
      gender: 'Female',
      address: '456 Oak Ave, Los Angeles, CA 90210',
      emergencyContact: '+1234567897',
      medicalHistory: 'Chronic lower back pain, previous car accident 2019',
      ongoingTreatment: 'Physical therapy sessions twice weekly',
    ),
    User(
      id: '8',
      email: 'patient3@demo.com',
      name: 'Robert Johnson',
      phone: '+1234567898',
      userType: UserType.patient,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      age: 28,
      gender: 'Male',
      address: '789 Pine St, Chicago, IL 60601',
      emergencyContact: '+1234567899',
      medicalHistory: 'Tennis elbow, shoulder impingement syndrome',
      ongoingTreatment: 'Sports rehabilitation program',
    ),
  ];

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> _saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    _currentUser = user;
  }

  Future<void> _clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _currentUser = null;
  }

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _currentUser = User.fromJson(userData);
        return _currentUser;
      } catch (e) {
        // Clear invalid data
        await _clearCurrentUser();
      }
    }
    
    return null;
  }

  Future<User> signInWithEmail(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // For demo purposes, any password works
    final user = _mockUsers.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('User not found. Use demo emails: patient@demo.com or physio@demo.com'),
    );
    
    await _saveCurrentUser(user);
    return user;
  }

  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType userType,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 2000));
    
    // Check if user already exists
    final existingUser = _mockUsers.where(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
    
    if (existingUser.isNotEmpty) {
      throw Exception('User with this email already exists');
    }
    
    // Create new user
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      phone: phone,
      userType: userType,
      createdAt: DateTime.now(),
    );
    
    // Add to mock database
    _mockUsers.add(newUser);
    
    await _saveCurrentUser(newUser);
    return newUser;
  }

  Future<void> signOut() async {
    await _clearCurrentUser();
  }

  Future<void> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final userExists = _mockUsers.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
    
    if (!userExists) {
      throw Exception('No user found with this email address');
    }
    
    // In a real app, this would send a password reset email
    // For demo, we just simulate success
  }

  Future<User> updateProfile({
    required String name,
    required String phone,
    String? profilePicture,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final updatedUser = _currentUser!.copyWith(
      name: name,
      phone: phone,
      profilePicture: profilePicture,
    );
    
    // Update in mock database
    final index = _mockUsers.indexWhere((user) => user.id == _currentUser!.id);
    if (index != -1) {
      _mockUsers[index] = updatedUser;
    }
    
    await _saveCurrentUser(updatedUser);
    return updatedUser;
  }

  // Quick login methods for demo
  Future<User> quickLoginAsPatient() async {
    return signInWithEmail('patient@demo.com', 'demo123');
  }

  Future<User> quickLoginAsPhysio() async {
    return signInWithEmail('physio@demo.com', 'demo123');
  }
}
