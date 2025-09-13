import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';

class BookingScreen extends StatefulWidget {
  final User physiotherapist;

  const BookingScreen({super.key, required this.physiotherapist});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';
  AppointmentType _selectedType = AppointmentType.clinicSession;
  String? _selectedClinic;

  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  final List<String> _clinics = [
    'City Center Clinic',
    'Sports Medicine Center',
    'Rehabilitation Institute',
    'Community Health Center',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
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
              // Physiotherapist Info Card
              _buildPhysioCard(),

              const SizedBox(height: 24),

              // Appointment Type Selection
              Text(
                'Appointment Type',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildAppointmentTypeSelector(),

              const SizedBox(height: 24),

              // Date Selection
              Text(
                'Select Date',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildDateSelector(),

              const SizedBox(height: 24),

              // Time Selection
              Text(
                'Select Time',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildTimeSelector(),

              const SizedBox(height: 24),

              // Additional Fields based on appointment type
              if (_selectedType == AppointmentType.homeVisit) ...[
                Text(
                  'Home Visit Details',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Home Address',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your complete home address',
                  ),
                  validator: (value) {
                    if (_selectedType == AppointmentType.homeVisit &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter your home address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],

              if (_selectedType == AppointmentType.clinicSession) ...[
                Text(
                  'Clinic Selection',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedClinic,
                  decoration: const InputDecoration(
                    labelText: 'Select Clinic',
                    prefixIcon: Icon(Icons.local_hospital),
                    border: OutlineInputBorder(),
                  ),
                  items: _clinics.map((String clinic) {
                    return DropdownMenuItem<String>(
                      value: clinic,
                      child: Text(clinic),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClinic = newValue;
                    });
                  },
                  validator: (value) {
                    if (_selectedType == AppointmentType.clinicSession &&
                        (value == null || value.isEmpty)) {
                      return 'Please select a clinic';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Notes Field
              Text(
                'Additional Notes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                  hintText: 'Any specific concerns or requirements...',
                ),
              ),

              const SizedBox(height: 24),

              // Price Display
              _buildPriceCard(),

              const SizedBox(height: 32),

              // Book Button
              ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhysioCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                widget.physiotherapist.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.physiotherapist.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.physiotherapist.specialization ?? 'Physiotherapist',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${widget.physiotherapist.rating ?? 0.0}'),
                      Text(
                        ' (${widget.physiotherapist.totalReviews ?? 0} reviews)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTypeSelector() {
    return Column(
      children: [
        RadioListTile<AppointmentType>(
          title: const Text('Clinic Session'),
          subtitle: const Text('Visit the physiotherapist at their clinic'),
          value: AppointmentType.clinicSession,
          groupValue: _selectedType,
          onChanged: (AppointmentType? value) {
            setState(() {
              _selectedType = value!;
            });
          },
        ),
        RadioListTile<AppointmentType>(
          title: const Text('Home Visit'),
          subtitle: const Text('Physiotherapist visits you at home'),
          value: AppointmentType.homeVisit,
          groupValue: _selectedType,
          onChanged: (AppointmentType? value) {
            setState(() {
              _selectedType = value!;
            });
          },
        ),
        RadioListTile<AppointmentType>(
          title: const Text('Virtual Consultation'),
          subtitle: const Text('Online video consultation'),
          value: AppointmentType.virtualConsultation,
          groupValue: _selectedType,
          onChanged: (AppointmentType? value) {
            setState(() {
              _selectedType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().add(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 16),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _timeSlots.map((time) {
        final isSelected = _selectedTime == time;
        return ChoiceChip(
          label: Text(time),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedTime = selected ? time : _selectedTime;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceCard() {
    double basePrice = widget.physiotherapist.hourlyRate ?? 0.0;
    double totalPrice = basePrice;

    // Add surcharge for home visits
    if (_selectedType == AppointmentType.homeVisit) {
      totalPrice += 20.0; // $20 surcharge for home visits
    }

    return Card(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Base Rate (1 hour)'),
                Text('\$${basePrice.toStringAsFixed(2)}'),
              ],
            ),
            if (_selectedType == AppointmentType.homeVisit) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Home Visit Surcharge'), Text('\$20.00')],
              ),
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    if (authProvider.currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to book an appointment'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      double basePrice = widget.physiotherapist.hourlyRate ?? 0.0;
      double totalPrice = basePrice;

      if (_selectedType == AppointmentType.homeVisit) {
        totalPrice += 20.0;
      }

      final success = await appointmentProvider.bookAppointment(
        patientId: authProvider.currentUser!.id,
        physiotherapistId: widget.physiotherapist.id,
        appointmentDate: _selectedDate,
        appointmentTime: _selectedTime,
        type: _selectedType,
        amount: totalPrice,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        address: _selectedType == AppointmentType.homeVisit
            ? _addressController.text
            : null,
        clinicName: _selectedType == AppointmentType.clinicSession
            ? _selectedClinic
            : null,
      );

      if (success) {
        // Generate invoice for the appointment
        final appointment = appointmentProvider.appointments.last;
        final invoice = await appointmentProvider.generateInvoiceForAppointment(
          appointment.id,
        );

        if (invoice != null && mounted) {
          // Navigate directly to the invoice screen instead of showing SnackBar
          Navigator.of(context).pushReplacementNamed(
            '/professional-invoice',
            arguments: {'invoiceId': invoice.id},
          );
        } else {
          // Navigate back if invoice generation failed
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment booked successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error booking appointment: ${appointmentProvider.error}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
