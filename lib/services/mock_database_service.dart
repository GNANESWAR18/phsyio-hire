import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/appointment.dart';
import '../models/invoice.dart';
import '../models/review.dart' as review_model;

class MockDatabaseService {
  // Mock physiotherapist users
  static final List<User> _mockPhysiotherapists = [
    User(
      id: '2',
      email: 'sarah.wilson@physio.com',
      name: 'Dr. Sarah Wilson',
      phone: '+1234567891',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      specialization: 'Sports Physiotherapy',
      experienceYears: 8,
      hourlyRate: 80.0,
      qualifications: 'DPT, Sports Medicine',
      licenseNumber: 'PT12345',
      isVerified: true,
      certificates: [
        'Certified Sports Physiotherapist',
        'Manual Therapy Specialist',
      ],
      bio:
          'Specialized in sports injuries and rehabilitation. Former team physiotherapist for professional athletes.',
      rating: 4.8,
      totalReviews: 125,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      workingHours: '9:00 AM - 6:00 PM',
    ),
    User(
      id: '3',
      email: 'michael.johnson@physio.com',
      name: 'Dr. Michael Johnson',
      phone: '+1234567892',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
      specialization: 'Orthopedic Physiotherapy',
      experienceYears: 12,
      hourlyRate: 95.0,
      qualifications: 'DPT, Orthopedic Specialist',
      licenseNumber: 'PT67890',
      isVerified: true,
      certificates: ['Orthopedic Specialist', 'Pain Management Certified'],
      bio:
          'Expert in post-surgical rehabilitation and chronic pain management. 12+ years helping patients recover.',
      rating: 4.9,
      totalReviews: 87,
      availableDays: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
      workingHours: '8:00 AM - 5:00 PM',
    ),
    User(
      id: '4',
      email: 'emma.davis@physio.com',
      name: 'Dr. Emma Davis',
      phone: '+1234567893',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      specialization: 'Neurological Physiotherapy',
      experienceYears: 6,
      hourlyRate: 75.0,
      qualifications: 'DPT, Neurological Specialist',
      licenseNumber: 'PT11111',
      isVerified: true,
      certificates: [
        'Neuro Physiotherapy Specialist',
        'Stroke Recovery Certified',
      ],
      bio:
          'Specialized in stroke recovery and neurological conditions. Compassionate care for complex cases.',
      rating: 4.7,
      totalReviews: 64,
      availableDays: ['Tuesday', 'Thursday', 'Friday', 'Saturday'],
      workingHours: '10:00 AM - 7:00 PM',
    ),
    User(
      id: '5',
      email: 'james.brown@physio.com',
      name: 'Dr. James Brown',
      phone: '+1234567894',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 250)),
      specialization: 'Pediatric Physiotherapy',
      experienceYears: 5,
      hourlyRate: 70.0,
      qualifications: 'DPT, Pediatric Specialist',
      licenseNumber: 'PT22222',
      isVerified: true,
      certificates: ['Pediatric Physiotherapy Specialist'],
      bio:
          'Gentle and patient care for children with developmental delays and injuries.',
      rating: 4.6,
      totalReviews: 43,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
      workingHours: '9:00 AM - 4:00 PM',
    ),
    User(
      id: '6',
      email: 'lisa.garcia@physio.com',
      name: 'Dr. Lisa Garcia',
      phone: '+1234567895',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      specialization: 'Geriatric Physiotherapy',
      experienceYears: 10,
      hourlyRate: 85.0,
      qualifications: 'DPT, Geriatric Specialist',
      licenseNumber: 'PT33333',
      isVerified: true,
      certificates: [
        'Geriatric Physiotherapy Specialist',
        'Fall Prevention Certified',
      ],
      bio:
          'Specialized in elderly care, fall prevention, and mobility improvement for seniors.',
      rating: 4.8,
      totalReviews: 92,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      workingHours: '8:00 AM - 5:00 PM',
    ),
    User(
      id: '7',
      email: 'robert.lee@physio.com',
      name: 'Dr. Robert Lee',
      phone: '+1234567896',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      specialization: 'Cardiopulmonary Physiotherapy',
      experienceYears: 7,
      hourlyRate: 90.0,
      qualifications: 'DPT, Cardiopulmonary Specialist',
      licenseNumber: 'PT44444',
      isVerified: true,
      certificates: [
        'Cardiopulmonary Specialist',
        'ICU Physiotherapy Certified',
      ],
      bio:
          'Expert in respiratory and cardiac rehabilitation, helping patients recover from heart and lung conditions.',
      rating: 4.9,
      totalReviews: 78,
      availableDays: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
      workingHours: '7:00 AM - 6:00 PM',
    ),
    User(
      id: '8',
      email: 'maria.rodriguez@physio.com',
      name: 'Dr. Maria Rodriguez',
      phone: '+1234567897',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      specialization: 'Women\'s Health Physiotherapy',
      experienceYears: 6,
      hourlyRate: 75.0,
      qualifications: 'DPT, Women\'s Health Specialist',
      licenseNumber: 'PT55555',
      isVerified: true,
      certificates: ['Women\'s Health Specialist', 'Pelvic Floor Certified'],
      bio:
          'Specialized in women\'s health issues including pregnancy-related pain and pelvic floor disorders.',
      rating: 4.7,
      totalReviews: 56,
      availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Saturday'],
      workingHours: '9:00 AM - 7:00 PM',
    ),
    User(
      id: '9',
      email: 'david.kim@physio.com',
      name: 'Dr. David Kim',
      phone: '+1234567898',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      specialization: 'Vestibular Physiotherapy',
      experienceYears: 8,
      hourlyRate: 88.0,
      qualifications: 'DPT, Vestibular Specialist',
      licenseNumber: 'PT66666',
      isVerified: true,
      certificates: ['Vestibular Specialist', 'Balance Disorders Certified'],
      bio:
          'Expert in treating dizziness, vertigo, and balance disorders with specialized vestibular rehabilitation.',
      rating: 4.8,
      totalReviews: 67,
      availableDays: ['Monday', 'Tuesday', 'Thursday', 'Friday'],
      workingHours: '8:30 AM - 5:30 PM',
    ),
    User(
      id: '10',
      email: 'jennifer.white@physio.com',
      name: 'Dr. Jennifer White',
      phone: '+1234567899',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      specialization: 'Aquatic Physiotherapy',
      experienceYears: 5,
      hourlyRate: 72.0,
      qualifications: 'DPT, Aquatic Therapy Specialist',
      licenseNumber: 'PT77777',
      isVerified: true,
      certificates: ['Aquatic Therapy Specialist', 'Hydrotherapy Certified'],
      bio:
          'Specialized in water-based therapy for pain relief and rehabilitation in a low-impact environment.',
      rating: 4.6,
      totalReviews: 45,
      availableDays: ['Monday', 'Wednesday', 'Friday', 'Sunday'],
      workingHours: '10:00 AM - 6:00 PM',
    ),
    User(
      id: '11',
      email: 'alex.chen@physio.com',
      name: 'Dr. Alex Chen',
      phone: '+1234567800',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
      specialization: 'Hand Therapy',
      experienceYears: 9,
      hourlyRate: 95.0,
      qualifications: 'DPT, Hand Therapy Specialist',
      licenseNumber: 'PT88888',
      isVerified: true,
      certificates: ['Hand Therapy Specialist', 'Splinting Certified'],
      bio:
          'Expert in hand and upper extremity rehabilitation, treating complex hand injuries and conditions.',
      rating: 4.9,
      totalReviews: 89,
      availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      workingHours: '8:00 AM - 5:00 PM',
    ),
    User(
      id: '12',
      email: 'sophie.martin@physio.com',
      name: 'Dr. Sophie Martin',
      phone: '+1234567801',
      userType: UserType.physiotherapist,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      specialization: 'Lymphatic Physiotherapy',
      experienceYears: 4,
      hourlyRate: 68.0,
      qualifications: 'DPT, Lymphatic Specialist',
      licenseNumber: 'PT99999',
      isVerified: true,
      certificates: ['Lymphatic Drainage Specialist', 'Lymphedema Certified'],
      bio:
          'Specialized in lymphatic drainage and lymphedema management for post-surgical and cancer patients.',
      rating: 4.5,
      totalReviews: 34,
      availableDays: ['Monday', 'Tuesday', 'Thursday', 'Saturday'],
      workingHours: '9:00 AM - 5:00 PM',
    ),
  ];

  // Mock appointments
  static final List<Appointment> _mockAppointments = [
    Appointment(
      id: 'apt1',
      patientId: '1',
      physiotherapistId: '2',
      appointmentDate: DateTime.now().add(const Duration(days: 2)),
      appointmentTime: '10:00 AM',
      type: AppointmentType.homeVisit,
      status: AppointmentStatus.confirmed,
      amount: 80.0,
      notes: 'Knee pain after running',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isPaid: true,
      address: '123 Main St, City, State',
    ),
    Appointment(
      id: 'apt2',
      patientId: '1',
      physiotherapistId: '3',
      appointmentDate: DateTime.now().subtract(const Duration(days: 7)),
      appointmentTime: '2:00 PM',
      type: AppointmentType.virtualConsultation,
      status: AppointmentStatus.completed,
      amount: 95.0,
      notes: 'Follow-up for back pain',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      isPaid: true,
      meetingLink: 'https://meet.google.com/abc-defg-hij',
    ),
  ];

  // Mock invoices
  static final List<Invoice> _mockInvoices = [
    Invoice(
      id: 'INV-20241201-0001',
      appointmentId: 'apt1',
      patientId: '1',
      physiotherapistId: '2',
      patientName: 'John Doe',
      physiotherapistName: 'Dr. Sarah Wilson',
      appointmentDate: DateTime.now().add(const Duration(days: 2)),
      appointmentTime: '10:00 AM',
      appointmentType: AppointmentType.homeVisit,
      amount: 80.0,
      taxAmount: 8.0,
      totalAmount: 88.0,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      notes: 'Knee pain after running',
      address: '123 Main St, City, State',
      status: InvoiceStatus.pending,
    ),
  ];

  // Mock reviews
  static final List<review_model.Review> _mockReviews = [
    review_model.Review(
      id: 'rev1',
      appointmentId: 'apt2',
      patientId: '1',
      physiotherapistId: '3',
      rating: 5.0,
      comment:
          'Excellent service! Dr. Johnson was very professional and helped me understand my condition better.',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      patientName: 'John Doe',
    ),
  ];

  Future<List<User>> getPhysiotherapists({
    String? specialization,
    String? location,
    double? minRating,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    var filtered = List<User>.from(_mockPhysiotherapists);

    if (specialization != null && specialization.isNotEmpty) {
      filtered = filtered
          .where(
            (physio) =>
                physio.specialization?.toLowerCase().contains(
                  specialization.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }

    if (location != null && location.isNotEmpty) {
      // For now, we'll filter by working hours as a proxy for location
      // In a real app, you'd have a location field
      filtered = filtered
          .where(
            (physio) =>
                physio.workingHours?.toLowerCase().contains(
                  location.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }

    if (minRating != null) {
      filtered = filtered
          .where((physio) => (physio.rating ?? 0) >= minRating)
          .toList();
    }

    // Sort by rating (highest first)
    filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    return filtered;
  }

  Future<User?> getPhysiotherapistProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _mockPhysiotherapists.firstWhere((physio) => physio.id == userId);
    } catch (e) {
      return null;
    }
  }

  Future<Appointment> bookAppointment({
    required String patientId,
    required String physiotherapistId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required AppointmentType type,
    required double amount,
    String? notes,
    String? address,
    String? clinicName,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final newAppointment = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      physiotherapistId: physiotherapistId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      type: type,
      status: AppointmentStatus.pending,
      amount: amount,
      notes: notes,
      createdAt: DateTime.now(),
      isPaid: false,
      address: address,
      clinicName: clinicName,
    );

    _mockAppointments.add(newAppointment);
    return newAppointment;
  }

  Future<List<Appointment>> getUserAppointments(
    String userId, {
    UserType? userType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (userType == UserType.patient) {
      return _mockAppointments.where((apt) => apt.patientId == userId).toList();
    } else if (userType == UserType.physiotherapist) {
      return _mockAppointments
          .where((apt) => apt.physiotherapistId == userId)
          .toList();
    }

    return [];
  }

  Future<Appointment> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockAppointments.indexWhere(
      (apt) => apt.id == appointmentId,
    );
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    final updatedAppointment = _mockAppointments[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    _mockAppointments[index] = updatedAppointment;
    return updatedAppointment;
  }

  Future<bool> processPayment(
    String appointmentId, {
    required double amount,
  }) async {
    // Simulate payment processing
    await Future.delayed(const Duration(milliseconds: 2000));

    final index = _mockAppointments.indexWhere(
      (apt) => apt.id == appointmentId,
    );
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    // Mock payment success (90% success rate)
    final success = DateTime.now().millisecond % 10 != 0;

    if (success) {
      final updatedAppointment = _mockAppointments[index].copyWith(
        status: AppointmentStatus.confirmed,
        isPaid: true,
        updatedAt: DateTime.now(),
      );

      _mockAppointments[index] = updatedAppointment;
      return true;
    }

    return false;
  }

  Future<review_model.Review> addReview({
    required String appointmentId,
    required String patientId,
    required String physiotherapistId,
    required double rating,
    required String comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newReview = review_model.Review(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      appointmentId: appointmentId,
      patientId: patientId,
      physiotherapistId: physiotherapistId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    _mockReviews.add(newReview);

    // Update physiotherapist rating
    _updatePhysiotherapistRating(physiotherapistId);

    return newReview;
  }

  Future<List<review_model.Review>> getPhysiotherapistReviews(
    String physiotherapistId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockReviews
        .where((review) => review.physiotherapistId == physiotherapistId)
        .toList();
  }

  void _updatePhysiotherapistRating(String physiotherapistId) {
    final reviews = _mockReviews
        .where((review) => review.physiotherapistId == physiotherapistId)
        .toList();

    if (reviews.isNotEmpty) {
      // Calculate average rating (would be used to update database in real app)
      final averageRating =
          reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

      final index = _mockPhysiotherapists.indexWhere(
        (physio) => physio.id == physiotherapistId,
      );
      if (index != -1) {
        // In a real app, this would update the database with the new average rating
        // For now, we just calculate it but don't persist it in this mock
        // Using debugPrint instead of print for production code
        debugPrint(
          'Updated rating for physiotherapist $physiotherapistId: $averageRating',
        );
      }
    }
  }

  // Mock video call functionality
  Future<String> startVideoCall(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Return a mock video call URL or session ID
    return 'mock_video_session_${appointmentId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> endVideoCall(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock ending video call
  }

  // Generate invoice for appointment
  Future<Invoice> generateInvoice(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final appointment = _mockAppointments.firstWhere(
      (apt) => apt.id == appointmentId,
      orElse: () => throw Exception('Appointment not found'),
    );

    // Get patient and physiotherapist details
    final patient = await _getUserById(appointment.patientId);
    final physiotherapist = await _getUserById(appointment.physiotherapistId);

    if (patient == null || physiotherapist == null) {
      throw Exception('User not found');
    }

    final invoice = Invoice.fromAppointment(
      appointment,
      patient,
      physiotherapist,
    );
    _mockInvoices.add(invoice);

    // Update appointment with invoice ID
    final appointmentIndex = _mockAppointments.indexWhere(
      (apt) => apt.id == appointmentId,
    );
    if (appointmentIndex != -1) {
      _mockAppointments[appointmentIndex] = _mockAppointments[appointmentIndex]
          .copyWith(invoiceId: invoice.id);
    }

    return invoice;
  }

  // Get invoice by ID
  Future<Invoice?> getInvoice(String invoiceId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      return _mockInvoices.firstWhere((invoice) => invoice.id == invoiceId);
    } catch (e) {
      return null;
    }
  }

  // Get invoices for user
  Future<List<Invoice>> getUserInvoices(
    String userId,
    UserType userType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (userType == UserType.patient) {
      return _mockInvoices
          .where((invoice) => invoice.patientId == userId)
          .toList();
    } else if (userType == UserType.physiotherapist) {
      return _mockInvoices
          .where((invoice) => invoice.physiotherapistId == userId)
          .toList();
    }

    return [];
  }

  // Update invoice status
  Future<Invoice> updateInvoiceStatus(
    String invoiceId,
    InvoiceStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockInvoices.indexWhere(
      (invoice) => invoice.id == invoiceId,
    );
    if (index == -1) {
      throw Exception('Invoice not found');
    }

    final updatedInvoice = _mockInvoices[index].copyWith(
      status: status,
      paidAt: status == InvoiceStatus.paid ? DateTime.now() : null,
    );

    _mockInvoices[index] = updatedInvoice;
    return updatedInvoice;
  }

  // Helper method to get user by ID
  Future<User?> _getUserById(String userId) async {
    // This would typically query a user database
    // For now, we'll return a mock user based on the ID
    if (userId == '1') {
      return User(
        id: '1',
        email: 'john.doe@example.com',
        name: 'John Doe',
        phone: '+1234567890',
        userType: UserType.patient,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
    }

    // Check if it's a physiotherapist
    try {
      return _mockPhysiotherapists.firstWhere((physio) => physio.id == userId);
    } catch (e) {
      return null;
    }
  }
}
