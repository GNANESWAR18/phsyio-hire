import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/invoice.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import 'professional_invoice_screen.dart';

class InvoiceScreen extends StatefulWidget {
  final String invoiceId;

  const InvoiceScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  Invoice? _invoice;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    try {
      // First try to get from local list
      final localInvoice = appointmentProvider.invoices
          .where((inv) => inv.id == widget.invoiceId)
          .firstOrNull;

      if (localInvoice != null) {
        setState(() {
          _invoice = localInvoice;
          _isLoading = false;
        });
        return;
      }

      // If not found locally, try to load from database
      final invoice = await appointmentProvider.getInvoice(widget.invoiceId);
      if (invoice != null) {
        setState(() {
          _invoice = invoice;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Invoice not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading invoice: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_invoice != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareInvoice(context),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading invoice...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadInvoice, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_invoice == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Invoice not found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInvoiceHeader(context, _invoice!),
          const SizedBox(height: 24),
          _buildInvoiceDetails(context, _invoice!),
          const SizedBox(height: 24),
          _buildPaymentDetails(context, _invoice!),
          const SizedBox(height: 24),
          _buildActionButtons(context, _invoice!),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(BuildContext context, Invoice invoice) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'INVOICE',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        invoice.id,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PhysioHire Appointment',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(invoice.status),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(
                            invoice.status,
                          ).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(invoice.status),
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(invoice.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generated on',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          _formatDateTime(invoice.createdAt),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (invoice.paidAt != null) ...[
                      Icon(Icons.payment, color: Colors.green[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Paid ${_formatDate(invoice.paidAt!)}',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails(BuildContext context, Invoice invoice) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_note,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Appointment Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildEnhancedDetailRow(
              context,
              'Patient',
              invoice.patientName,
              Icons.person,
              Colors.blue,
            ),
            _buildEnhancedDetailRow(
              context,
              'Physiotherapist',
              'Dr. ${invoice.physiotherapistName}',
              Icons.medical_services,
              Colors.green,
            ),
            _buildEnhancedDetailRow(
              context,
              'Date',
              _formatDate(invoice.appointmentDate),
              Icons.calendar_today,
              Colors.orange,
            ),
            _buildEnhancedDetailRow(
              context,
              'Time',
              invoice.appointmentTime,
              Icons.access_time,
              Colors.purple,
            ),
            _buildEnhancedDetailRow(
              context,
              'Type',
              _formatAppointmentType(invoice.appointmentType),
              _getAppointmentTypeIcon(invoice.appointmentType),
              _getAppointmentTypeColor(invoice.appointmentType),
            ),
            if (invoice.clinicName != null)
              _buildEnhancedDetailRow(
                context,
                'Clinic',
                invoice.clinicName!,
                Icons.local_hospital,
                Colors.red,
              ),
            if (invoice.address != null)
              _buildEnhancedDetailRow(
                context,
                'Address',
                invoice.address!,
                Icons.location_on,
                Colors.teal,
              ),
            if (invoice.meetingLink != null)
              _buildEnhancedDetailRow(
                context,
                'Meeting Link',
                invoice.meetingLink!,
                Icons.video_call,
                Colors.indigo,
                isLink: true,
              ),
            if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.note, color: Colors.amber[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      invoice.notes!,
                      style: TextStyle(color: Colors.amber[800], height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(BuildContext context, Invoice invoice) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Payment Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildEnhancedPaymentRow(
                    context,
                    'Service Fee',
                    invoice.amount,
                    Icons.medical_services,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildEnhancedPaymentRow(
                    context,
                    'Tax (10%)',
                    invoice.taxAmount,
                    Icons.receipt,
                    Colors.orange,
                  ),
                  const Divider(height: 24),
                  _buildEnhancedPaymentRow(
                    context,
                    'Total Amount',
                    invoice.totalAmount,
                    Icons.account_balance_wallet,
                    Theme.of(context).colorScheme.primary,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            if (invoice.paymentMethod != null || invoice.paidAt != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: invoice.status == InvoiceStatus.paid
                      ? Colors.green[50]
                      : Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: invoice.status == InvoiceStatus.paid
                        ? Colors.green[200]!
                        : Colors.amber[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    if (invoice.paymentMethod != null)
                      _buildEnhancedDetailRow(
                        context,
                        'Payment Method',
                        invoice.paymentMethod!,
                        Icons.credit_card,
                        Colors.green,
                      ),
                    if (invoice.paidAt != null)
                      _buildEnhancedDetailRow(
                        context,
                        'Paid On',
                        _formatDateTime(invoice.paidAt!),
                        Icons.check_circle,
                        Colors.green,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Invoice invoice) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _openProfessionalView(context, invoice.id),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Professional Invoice View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _shareInvoice(context),
            icon: const Icon(Icons.share),
            label: const Text('Share Invoice'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _copyInvoiceId(context, invoice.id),
            icon: const Icon(Icons.copy),
            label: const Text('Copy Invoice ID'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        if (invoice.status == InvoiceStatus.pending) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _markAsPaid(context, invoice.id),
              icon: const Icon(Icons.payment),
              label: const Text('Mark as Paid'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _shareInvoice(BuildContext context) {
    if (_invoice == null) return;

    try {
      final shareText = _invoice!.generateShareableText();

      // Use Share.share to share the invoice details
      Share.share(
        shareText,
        subject: 'PhysioHire Appointment Invoice - ${_invoice!.id}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing invoice: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyInvoiceId(BuildContext context, String invoiceId) {
    Clipboard.setData(ClipboardData(text: invoiceId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice ID copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openProfessionalView(BuildContext context, String invoiceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfessionalInvoiceScreen(invoiceId: invoiceId),
      ),
    );
  }

  void _markAsPaid(BuildContext context, String invoiceId) async {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    final success = await appointmentProvider.updateInvoiceStatus(
      invoiceId,
      InvoiceStatus.paid,
    );

    if (success) {
      // Update local invoice
      setState(() {
        _invoice = _invoice!.copyWith(
          status: InvoiceStatus.paid,
          paidAt: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invoice marked as paid'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating invoice: ${appointmentProvider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.pending:
        return Colors.orange;
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.overdue:
        return Colors.red;
      case InvoiceStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.overdue:
        return 'Overdue';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
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

  // Enhanced helper methods
  Widget _buildEnhancedDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                if (isLink)
                  GestureDetector(
                    onTap: () {
                      // Handle link tap
                    },
                    child: Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPaymentRow(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16 : 14,
              color: Colors.grey[800],
            ),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 16,
            color: isTotal ? Theme.of(context).colorScheme.primary : color,
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.pending:
        return Icons.schedule;
      case InvoiceStatus.paid:
        return Icons.check_circle;
      case InvoiceStatus.overdue:
        return Icons.warning;
      case InvoiceStatus.cancelled:
        return Icons.cancel;
    }
  }

  IconData _getAppointmentTypeIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.homeVisit:
        return Icons.home;
      case AppointmentType.clinicSession:
        return Icons.local_hospital;
      case AppointmentType.virtualConsultation:
        return Icons.video_call;
    }
  }

  Color _getAppointmentTypeColor(AppointmentType type) {
    switch (type) {
      case AppointmentType.homeVisit:
        return Colors.green;
      case AppointmentType.clinicSession:
        return Colors.blue;
      case AppointmentType.virtualConsultation:
        return Colors.purple;
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
