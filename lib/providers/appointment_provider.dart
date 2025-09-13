import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../models/user.dart';
import '../models/invoice.dart';
import '../services/mock_database_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final MockDatabaseService _databaseService = MockDatabaseService();

  List<Appointment> _appointments = [];
  List<User> _physiotherapists = [];
  List<Invoice> _invoices = [];
  bool _isLoading = false;
  String? _error;

  List<Appointment> get appointments => _appointments;
  List<User> get physiotherapists => _physiotherapists;
  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get appointments for a specific user (patient or physiotherapist)
  List<Appointment> getAppointmentsForUser(String userId, bool isPatient) {
    if (isPatient) {
      return _appointments.where((apt) => apt.patientId == userId).toList();
    } else {
      return _appointments
          .where((apt) => apt.physiotherapistId == userId)
          .toList();
    }
  }

  // Get upcoming appointments
  List<Appointment> getUpcomingAppointments(String userId, bool isPatient) {
    final userAppointments = getAppointmentsForUser(userId, isPatient);
    final now = DateTime.now();
    return userAppointments
        .where(
          (apt) =>
              apt.status == AppointmentStatus.confirmed &&
              apt.appointmentDate.isAfter(now),
        )
        .toList();
  }

  // Get completed appointments
  List<Appointment> getCompletedAppointments(String userId, bool isPatient) {
    final userAppointments = getAppointmentsForUser(userId, isPatient);
    return userAppointments
        .where((apt) => apt.status == AppointmentStatus.completed)
        .toList();
  }

  // Book a new appointment
  Future<bool> bookAppointment({
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
    _setLoading(true);
    _clearError();

    try {
      final appointment = await _databaseService.bookAppointment(
        patientId: patientId,
        physiotherapistId: physiotherapistId,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        type: type,
        amount: amount,
        notes: notes,
        address: address,
        clinicName: clinicName,
      );

      // Add to local list
      _appointments.add(appointment);
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cancel appointment
  Future<bool> cancelAppointment(String appointmentId, String reason) async {
    _setLoading(true);
    _clearError();

    try {
      final appointmentIndex = _appointments.indexWhere(
        (apt) => apt.id == appointmentId,
      );
      if (appointmentIndex != -1) {
        _appointments[appointmentIndex] = _appointments[appointmentIndex]
            .copyWith(
              status: AppointmentStatus.cancelled,
              cancellationReason: reason,
              updatedAt: DateTime.now(),
            );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reschedule appointment
  Future<bool> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final appointmentIndex = _appointments.indexWhere(
        (apt) => apt.id == appointmentId,
      );
      if (appointmentIndex != -1) {
        _appointments[appointmentIndex] = _appointments[appointmentIndex]
            .copyWith(
              appointmentDate: newDate,
              appointmentTime: newTime,
              status: AppointmentStatus.rescheduled,
              updatedAt: DateTime.now(),
            );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus newStatus,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final appointmentIndex = _appointments.indexWhere(
        (apt) => apt.id == appointmentId,
      );
      if (appointmentIndex != -1) {
        _appointments[appointmentIndex] = _appointments[appointmentIndex]
            .copyWith(status: newStatus, updatedAt: DateTime.now());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load physiotherapists
  Future<void> loadPhysiotherapists({String? specialization}) async {
    _setLoading(true);
    _clearError();

    try {
      _physiotherapists = await _databaseService.getPhysiotherapists(
        specialization: specialization,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load appointments for user
  Future<void> loadUserAppointments(String userId, UserType userType) async {
    _setLoading(true);
    _clearError();

    try {
      _appointments = await _databaseService.getUserAppointments(
        userId,
        userType: userType,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Get appointments for physiotherapist (for physio dashboard)
  List<Appointment> getPhysiotherapistAppointments(String physioId) {
    return _appointments
        .where((apt) => apt.physiotherapistId == physioId)
        .toList();
  }

  // Get pending appointments for physiotherapist
  List<Appointment> getPendingAppointmentsForPhysio(String physioId) {
    return _appointments
        .where(
          (apt) =>
              apt.physiotherapistId == physioId &&
              apt.status == AppointmentStatus.pending,
        )
        .toList();
  }

  // Get today's appointments for physiotherapist
  List<Appointment> getTodayAppointmentsForPhysio(String physioId) {
    final today = DateTime.now();
    return _appointments
        .where(
          (apt) =>
              apt.physiotherapistId == physioId &&
              apt.appointmentDate.year == today.year &&
              apt.appointmentDate.month == today.month &&
              apt.appointmentDate.day == today.day,
        )
        .toList();
  }

  // Accept appointment (for physiotherapists)
  Future<bool> acceptAppointment(String appointmentId) async {
    return await updateAppointmentStatus(
      appointmentId,
      AppointmentStatus.confirmed,
    );
  }

  // Reject appointment (for physiotherapists)
  Future<bool> rejectAppointment(String appointmentId, String reason) async {
    return await cancelAppointment(appointmentId, reason);
  }

  // Complete appointment (for physiotherapists)
  Future<bool> completeAppointment(String appointmentId) async {
    return await updateAppointmentStatus(
      appointmentId,
      AppointmentStatus.completed,
    );
  }

  // Search physiotherapists by specialization
  List<User> searchPhysiotherapists(String query) {
    if (query.isEmpty) {
      return _physiotherapists;
    }

    final filtered = _physiotherapists.where((physio) {
      return physio.name.toLowerCase().contains(query.toLowerCase()) ||
          (physio.specialization?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          (physio.bio?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (physio.qualifications?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();

    // Update the displayed list
    _physiotherapists = filtered.isEmpty ? _physiotherapists : filtered;
    return filtered;
  }

  // Filter physiotherapists by specialization and update display
  Future<void> filterBySpecialization(String specialization) async {
    _setLoading(true);
    _clearError();

    try {
      await loadPhysiotherapists(specialization: specialization);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Filter physiotherapists by price range
  List<User> filterByPriceRange(double minPrice, double maxPrice) {
    return _physiotherapists.where((physio) {
      final rate = physio.hourlyRate ?? 0;
      return rate >= minPrice && rate <= maxPrice;
    }).toList();
  }

  // Filter physiotherapists by rating
  List<User> filterByRating(double minRating) {
    return _physiotherapists.where((physio) {
      return (physio.rating ?? 0) >= minRating;
    }).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Generate invoice for appointment
  Future<Invoice?> generateInvoiceForAppointment(String appointmentId) async {
    _setLoading(true);
    _clearError();

    try {
      final invoice = await _databaseService.generateInvoice(appointmentId);
      _invoices.add(invoice);
      notifyListeners();
      return invoice;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get invoice by ID
  Future<Invoice?> getInvoice(String invoiceId) async {
    _setLoading(true);
    _clearError();

    try {
      final invoice = await _databaseService.getInvoice(invoiceId);
      return invoice;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Load user invoices
  Future<void> loadUserInvoices(String userId, UserType userType) async {
    _setLoading(true);
    _clearError();

    try {
      _invoices = await _databaseService.getUserInvoices(userId, userType);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Get invoices for user
  List<Invoice> getInvoicesForUser(String userId, UserType userType) {
    if (userType == UserType.patient) {
      return _invoices.where((invoice) => invoice.patientId == userId).toList();
    } else if (userType == UserType.physiotherapist) {
      return _invoices
          .where((invoice) => invoice.physiotherapistId == userId)
          .toList();
    }
    return [];
  }

  // Update invoice status
  Future<bool> updateInvoiceStatus(
    String invoiceId,
    InvoiceStatus status,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedInvoice = await _databaseService.updateInvoiceStatus(
        invoiceId,
        status,
      );

      // Update local invoice list
      final index = _invoices.indexWhere((invoice) => invoice.id == invoiceId);
      if (index != -1) {
        _invoices[index] = updatedInvoice;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Share appointment details
  String generateAppointmentShareText(String appointmentId) {
    final invoice = _invoices.firstWhere(
      (inv) => inv.appointmentId == appointmentId,
      orElse: () => throw Exception('Invoice not found'),
    );

    return invoice.generateShareableText();
  }

  // Confirm appointment and generate invoice
  Future<bool> confirmAppointmentAndGenerateInvoice(
    String appointmentId,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // First confirm the appointment
      final success = await updateAppointmentStatus(
        appointmentId,
        AppointmentStatus.confirmed,
      );

      if (success) {
        // Then generate invoice
        final invoice = await generateInvoiceForAppointment(appointmentId);
        return invoice != null;
      }

      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
