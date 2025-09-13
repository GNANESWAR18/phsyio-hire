import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/invoice.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';

class ProfessionalInvoiceScreen extends StatefulWidget {
  final String invoiceId;

  const ProfessionalInvoiceScreen({super.key, required this.invoiceId});

  @override
  State<ProfessionalInvoiceScreen> createState() =>
      _ProfessionalInvoiceScreenState();
}

class _ProfessionalInvoiceScreenState extends State<ProfessionalInvoiceScreen> {
  Invoice? _invoice;
  bool _isLoading = true;
  String? _error;
  bool _showSuccessBanner = true;

  @override
  void initState() {
    super.initState();
    _loadInvoice();

    // Auto-dismiss success banner after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showSuccessBanner) {
        setState(() {
          _showSuccessBanner = false;
        });
      }
    });
  }

  Future<void> _loadInvoice() async {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    try {
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Professional Invoice'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_invoice != null) ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareInvoice,
              tooltip: 'Share Invoice',
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _downloadInvoice,
              tooltip: 'Download Invoice',
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/home', (route) => false);
              },
              tooltip: 'Back to Home',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Success Banner
          if (_showSuccessBanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointment Booked Successfully!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Invoice: ${_invoice?.id ?? 'Loading...'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showSuccessBanner = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          // Invoice Content
          Expanded(child: _buildBody()),
        ],
      ),
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
            Text(_error!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadInvoice, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_invoice == null) {
      return const Center(
        child: Text('Invoice not found', style: TextStyle(fontSize: 18)),
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildInvoiceContent(),
      ),
    );
  }

  Widget _buildInvoiceContent() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInvoiceHeader(),
          const SizedBox(height: 32),
          _buildCompanyDetails(),
          const SizedBox(height: 24),
          _buildBillingDetails(),
          const SizedBox(height: 32),
          _buildInvoiceTable(),
          const SizedBox(height: 24),
          _buildPaymentSummary(),
          const SizedBox(height: 32),
          _buildPaymentStatus(),
          const SizedBox(height: 24),
          if (_invoice!.notes != null && _invoice!.notes!.isNotEmpty)
            _buildNotesSection(),
          const SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHYSIOHIRE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Professional Physiotherapy Services',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'INVOICE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _invoice!.id,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FROM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'PhysioHire Ltd.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('123 Healthcare Avenue'),
              const Text('Medical District, MD 12345'),
              const Text('Phone: (555) 123-4567'),
              const Text('Email: billing@physiohire.com'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BILL TO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _invoice!.patientName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (_invoice!.address != null) ...[
                Text(_invoice!.address!),
                const SizedBox(height: 4),
              ],
              Text('Patient ID: ${_invoice!.patientId}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDetailItem(
              'Invoice Date',
              _formatDate(_invoice!.createdAt),
            ),
          ),
          Expanded(
            child: _buildDetailItem(
              'Appointment Date',
              _formatDate(_invoice!.appointmentDate),
            ),
          ),
          Expanded(
            child: _buildDetailItem(
              'Due Date',
              _formatDate(_invoice!.createdAt.add(const Duration(days: 30))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildInvoiceTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'DESCRIPTION',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'QTY',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'RATE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'AMOUNT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_formatAppointmentType(_invoice!.appointmentType)} Session',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Physiotherapy session with Dr. ${_invoice!.physiotherapistName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${_formatDate(_invoice!.appointmentDate)} at ${_invoice!.appointmentTime}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      if (_invoice!.clinicName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Location: ${_invoice!.clinicName}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '\$${_invoice!.amount.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '\$${_invoice!.amount.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Subtotal:',
                    '\$${_invoice!.amount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Tax (10%):',
                    '\$${_invoice!.taxAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 2),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'TOTAL:',
                    '\$${_invoice!.totalAmount.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Theme.of(context).primaryColor : Colors.grey[700],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Theme.of(context).primaryColor : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getStatusColor(_invoice!.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(_invoice!.status), width: 2),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(_invoice!.status),
            color: _getStatusColor(_invoice!.status),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Status: ${_getStatusText(_invoice!.status)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(_invoice!.status),
                  ),
                ),
                if (_invoice!.paymentMethod != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Payment Method: ${_invoice!.paymentMethod}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
                if (_invoice!.paidAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Paid on: ${_formatDateTime(_invoice!.paidAt!)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOTES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber[200]!),
          ),
          child: Text(
            _invoice!.notes!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.amber[800],
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'Thank you for choosing PhysioHire!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'For any questions regarding this invoice, please contact us at billing@physiohire.com or (555) 123-4567',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Invoice generated on ${_formatDateTime(DateTime.now())}',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _shareInvoice() {
    if (_invoice == null) return;

    final shareText = _invoice!.generateShareableText();
    Share.share(shareText, subject: 'PhysioHire Invoice - ${_invoice!.id}');
  }

  void _downloadInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF download feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
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

  String _getStatusText(InvoiceStatus status) {
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
}
