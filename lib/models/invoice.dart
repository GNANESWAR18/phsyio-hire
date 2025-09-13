import 'appointment.dart';
import 'user.dart';

class Invoice {
  final String id;
  final String appointmentId;
  final String patientId;
  final String physiotherapistId;
  final String patientName;
  final String physiotherapistName;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AppointmentType appointmentType;
  final double amount;
  final double taxAmount;
  final double totalAmount;
  final DateTime createdAt;
  final String? notes;
  final String? clinicName;
  final String? address;
  final String? meetingLink;
  final InvoiceStatus status;
  final String? paymentMethod;
  final DateTime? paidAt;

  const Invoice({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.physiotherapistId,
    required this.patientName,
    required this.physiotherapistName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    required this.amount,
    required this.taxAmount,
    required this.totalAmount,
    required this.createdAt,
    this.notes,
    this.clinicName,
    this.address,
    this.meetingLink,
    required this.status,
    this.paymentMethod,
    this.paidAt,
  });

  // Generate unique invoice ID
  static String generateInvoiceId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'INV-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-$random';
  }

  // Create invoice from appointment
  factory Invoice.fromAppointment(
      Appointment appointment, User patient, User physiotherapist) {
    final taxRate = 0.1; // 10% tax
    final taxAmount = appointment.amount * taxRate;
    final totalAmount = appointment.amount + taxAmount;

    return Invoice(
      id: generateInvoiceId(),
      appointmentId: appointment.id,
      patientId: appointment.patientId,
      physiotherapistId: appointment.physiotherapistId,
      patientName: patient.name,
      physiotherapistName: physiotherapist.name,
      appointmentDate: appointment.appointmentDate,
      appointmentTime: appointment.appointmentTime,
      appointmentType: appointment.type,
      amount: appointment.amount,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
      notes: appointment.notes,
      clinicName: appointment.clinicName,
      address: appointment.address,
      meetingLink: appointment.meetingLink,
      status: appointment.isPaid ? InvoiceStatus.paid : InvoiceStatus.pending,
      paymentMethod: appointment.isPaid ? 'Credit Card' : null,
      paidAt: appointment.isPaid ? DateTime.now() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'patientId': patientId,
      'physiotherapistId': physiotherapistId,
      'patientName': patientName,
      'physiotherapistName': physiotherapistName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'appointmentType': appointmentType.toString(),
      'amount': amount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'clinicName': clinicName,
      'address': address,
      'meetingLink': meetingLink,
      'status': status.toString(),
      'paymentMethod': paymentMethod,
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      appointmentId: json['appointmentId'],
      patientId: json['patientId'],
      physiotherapistId: json['physiotherapistId'],
      patientName: json['patientName'],
      physiotherapistName: json['physiotherapistName'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      appointmentTime: json['appointmentTime'],
      appointmentType: AppointmentType.values.firstWhere(
        (e) => e.toString() == json['appointmentType'],
      ),
      amount: json['amount'].toDouble(),
      taxAmount: json['taxAmount'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes'],
      clinicName: json['clinicName'],
      address: json['address'],
      meetingLink: json['meetingLink'],
      status: InvoiceStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      paymentMethod: json['paymentMethod'],
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Invoice copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? physiotherapistId,
    String? patientName,
    String? physiotherapistName,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentType? appointmentType,
    double? amount,
    double? taxAmount,
    double? totalAmount,
    DateTime? createdAt,
    String? notes,
    String? clinicName,
    String? address,
    String? meetingLink,
    InvoiceStatus? status,
    String? paymentMethod,
    DateTime? paidAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      physiotherapistId: physiotherapistId ?? this.physiotherapistId,
      patientName: patientName ?? this.patientName,
      physiotherapistName: physiotherapistName ?? this.physiotherapistName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentType: appointmentType ?? this.appointmentType,
      amount: amount ?? this.amount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      clinicName: clinicName ?? this.clinicName,
      address: address ?? this.address,
      meetingLink: meetingLink ?? this.meetingLink,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  // Generate shareable text for appointment details
  String generateShareableText() {
    final buffer = StringBuffer();
    buffer.writeln('🏥 PHYSIOHIRE APPOINTMENT CONFIRMATION');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');
    buffer.writeln('📋 Invoice ID: $id');
    buffer.writeln('👤 Patient: $patientName');
    buffer.writeln('👨‍⚕️ Physiotherapist: $physiotherapistName');
    buffer.writeln('📅 Date: ${_formatDate(appointmentDate)}');
    buffer.writeln('⏰ Time: $appointmentTime');
    buffer.writeln('🏥 Type: ${_formatAppointmentType(appointmentType)}');

    if (clinicName != null) {
      buffer.writeln('🏢 Clinic: $clinicName');
    }
    if (address != null) {
      buffer.writeln('🏠 Address: $address');
    }
    if (meetingLink != null) {
      buffer.writeln('🔗 Meeting Link: $meetingLink');
    }

    buffer.writeln('');
    buffer.writeln('💰 PAYMENT DETAILS');
    buffer.writeln('─────────────────');
    buffer.writeln('Service Fee: \$${amount.toStringAsFixed(2)}');
    buffer.writeln('Tax (10%): \$${taxAmount.toStringAsFixed(2)}');
    buffer.writeln('Total: \$${totalAmount.toStringAsFixed(2)}');
    buffer.writeln('Status: ${_formatStatus(status)}');

    if (notes != null && notes!.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('📝 Notes: $notes');
    }

    buffer.writeln('');
    buffer.writeln('Generated on: ${_formatDate(createdAt)}');
    buffer.writeln('Thank you for choosing PhysioHire!');

    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAppointmentType(AppointmentType type) {
    switch (type) {
      case AppointmentType.homeVisit:
        return 'Home Visit';
      case AppointmentType.clinicSession:
        return 'Clinic Session';
      case AppointmentType.virtualConsultation:
        return 'Virtual Consultation';
    }
  }

  String _formatStatus(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.pending:
        return 'Pending Payment';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.overdue:
        return 'Overdue';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum InvoiceStatus {
  pending,
  paid,
  overdue,
  cancelled,
}
