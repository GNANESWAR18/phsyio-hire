class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserType userType;
  final String? profilePicture;
  final DateTime createdAt;
  final bool isActive;

  // Patient-specific fields
  final int? age;
  final String? gender;
  final String? medicalHistory;
  final String? ongoingTreatment;
  final String? address;
  final String? emergencyContact;

  // Physiotherapist-specific fields
  final String? specialization;
  final int? experienceYears;
  final double? hourlyRate;
  final String? qualifications;
  final String? licenseNumber;
  final bool? isVerified;
  final List<String>? certificates;
  final String? bio;
  final double? rating;
  final int? totalReviews;
  final List<String>? availableDays;
  final String? workingHours;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
    this.profilePicture,
    required this.createdAt,
    this.isActive = true,
    this.age,
    this.gender,
    this.medicalHistory,
    this.ongoingTreatment,
    this.address,
    this.emergencyContact,
    this.specialization,
    this.experienceYears,
    this.hourlyRate,
    this.qualifications,
    this.licenseNumber,
    this.isVerified,
    this.certificates,
    this.bio,
    this.rating,
    this.totalReviews,
    this.availableDays,
    this.workingHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'userType': userType.toString(),
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'age': age,
      'gender': gender,
      'medicalHistory': medicalHistory,
      'ongoingTreatment': ongoingTreatment,
      'address': address,
      'emergencyContact': emergencyContact,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'hourlyRate': hourlyRate,
      'qualifications': qualifications,
      'licenseNumber': licenseNumber,
      'isVerified': isVerified,
      'certificates': certificates,
      'bio': bio,
      'rating': rating,
      'totalReviews': totalReviews,
      'availableDays': availableDays,
      'workingHours': workingHours,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == json['userType'],
      ),
      profilePicture: json['profilePicture'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
      age: json['age'],
      gender: json['gender'],
      medicalHistory: json['medicalHistory'],
      ongoingTreatment: json['ongoingTreatment'],
      address: json['address'],
      emergencyContact: json['emergencyContact'],
      specialization: json['specialization'],
      experienceYears: json['experienceYears'],
      hourlyRate: json['hourlyRate']?.toDouble(),
      qualifications: json['qualifications'],
      licenseNumber: json['licenseNumber'],
      isVerified: json['isVerified'],
      certificates: json['certificates'] != null
          ? List<String>.from(json['certificates'])
          : null,
      bio: json['bio'],
      rating: json['rating']?.toDouble(),
      totalReviews: json['totalReviews'],
      availableDays: json['availableDays'] != null
          ? List<String>.from(json['availableDays'])
          : null,
      workingHours: json['workingHours'],
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserType? userType,
    String? profilePicture,
    DateTime? createdAt,
    bool? isActive,
    int? age,
    String? gender,
    String? medicalHistory,
    String? ongoingTreatment,
    String? address,
    String? emergencyContact,
    String? specialization,
    int? experienceYears,
    double? hourlyRate,
    String? qualifications,
    String? licenseNumber,
    bool? isVerified,
    List<String>? certificates,
    String? bio,
    double? rating,
    int? totalReviews,
    List<String>? availableDays,
    String? workingHours,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      ongoingTreatment: ongoingTreatment ?? this.ongoingTreatment,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      qualifications: qualifications ?? this.qualifications,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      isVerified: isVerified ?? this.isVerified,
      certificates: certificates ?? this.certificates,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      availableDays: availableDays ?? this.availableDays,
      workingHours: workingHours ?? this.workingHours,
    );
  }
}

enum UserType {
  patient,
  physiotherapist,
}
