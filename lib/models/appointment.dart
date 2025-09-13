enum AppointmentType {
  homeVisit,
  clinicSession,
  virtualConsultation,
}

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  rescheduled,
}

class Appointment {
  final String id;
  final String patientId;
  final String physiotherapistId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AppointmentType type;
  final AppointmentStatus status;
  final double amount;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? paymentId;
  final bool isPaid;
  final String? meetingLink; // For virtual consultations
  final String? address; // For home visits
  final String? clinicName; // For clinic sessions
  final String? invoiceId; // Associated invoice ID

  const Appointment({
    required this.id,
    required this.patientId,
    required this.physiotherapistId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.type,
    required this.status,
    required this.amount,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    this.updatedAt,
    this.paymentId,
    this.isPaid = false,
    this.meetingLink,
    this.address,
    this.clinicName,
    this.invoiceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'physiotherapistId': physiotherapistId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'type': type.toString(),
      'status': status.toString(),
      'amount': amount,
      'notes': notes,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'paymentId': paymentId,
      'isPaid': isPaid,
      'meetingLink': meetingLink,
      'address': address,
      'clinicName': clinicName,
      'invoiceId': invoiceId,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      physiotherapistId: json['physiotherapistId'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      appointmentTime: json['appointmentTime'],
      type: AppointmentType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      amount: json['amount'].toDouble(),
      notes: json['notes'],
      cancellationReason: json['cancellationReason'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      paymentId: json['paymentId'],
      isPaid: json['isPaid'] ?? false,
      meetingLink: json['meetingLink'],
      address: json['address'],
      clinicName: json['clinicName'],
      invoiceId: json['invoiceId'],
    );
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? physiotherapistId,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentType? type,
    AppointmentStatus? status,
    double? amount,
    String? notes,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? paymentId,
    bool? isPaid,
    String? meetingLink,
    String? address,
    String? clinicName,
    String? invoiceId,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      physiotherapistId: physiotherapistId ?? this.physiotherapistId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentId: paymentId ?? this.paymentId,
      isPaid: isPaid ?? this.isPaid,
      meetingLink: meetingLink ?? this.meetingLink,
      address: address ?? this.address,
      clinicName: clinicName ?? this.clinicName,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class Review {
  final String id;
  final String appointmentId;
  final String patientId;
  final String physiotherapistId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.physiotherapistId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'patientId': patientId,
      'physiotherapistId': physiotherapistId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      appointmentId: json['appointmentId'],
      patientId: json['patientId'],
      physiotherapistId: json['physiotherapistId'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
