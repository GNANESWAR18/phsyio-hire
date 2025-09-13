import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: '1',
      type: PaymentType.creditCard,
      title: 'Visa ending in 1234',
      subtitle: 'Expires 12/25',
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      type: PaymentType.creditCard,
      title: 'Mastercard ending in 5678',
      subtitle: 'Expires 03/26',
      isDefault: false,
    ),
    PaymentMethod(
      id: '3',
      type: PaymentType.paypal,
      title: 'PayPal',
      subtitle: 'john.doe@email.com',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Payment Methods',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your payment methods for appointments',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods List
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = _paymentMethods[index];
                  return _buildPaymentMethodCard(paymentMethod);
                },
              ),
            ),

            // Add New Payment Method Button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddPaymentMethodDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add New Payment Method'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod) {
    IconData icon;
    Color iconColor;
    
    switch (paymentMethod.type) {
      case PaymentType.creditCard:
        icon = Icons.credit_card;
        iconColor = Colors.blue;
        break;
      case PaymentType.debitCard:
        icon = Icons.credit_card;
        iconColor = Colors.green;
        break;
      case PaymentType.paypal:
        icon = Icons.payment;
        iconColor = Colors.orange;
        break;
      case PaymentType.applePay:
        icon = Icons.phone_android;
        iconColor = Colors.black;
        break;
      case PaymentType.googlePay:
        icon = Icons.phone_android;
        iconColor = Colors.red;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Row(
          children: [
            Text(paymentMethod.title),
            if (paymentMethod.isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(paymentMethod.subtitle),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handlePaymentMethodAction(value, paymentMethod),
          itemBuilder: (BuildContext context) => [
            if (!paymentMethod.isDefault)
              const PopupMenuItem<String>(
                value: 'setDefault',
                child: Row(
                  children: [
                    Icon(Icons.star_outline),
                    SizedBox(width: 8),
                    Text('Set as Default'),
                  ],
                ),
              ),
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          child: const Icon(Icons.more_vert),
        ),
      ),
    );
  }

  void _handlePaymentMethodAction(String action, PaymentMethod paymentMethod) {
    switch (action) {
      case 'setDefault':
        setState(() {
          for (var method in _paymentMethods) {
            method.isDefault = method.id == paymentMethod.id;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${paymentMethod.title} set as default')),
        );
        break;
      case 'edit':
        _showEditPaymentMethodDialog(paymentMethod);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(paymentMethod);
        break;
    }
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Payment Method'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.credit_card, color: Colors.blue),
                title: Text('Credit Card'),
                subtitle: Text('Visa, Mastercard, Amex'),
              ),
              ListTile(
                leading: Icon(Icons.credit_card, color: Colors.green),
                title: Text('Debit Card'),
                subtitle: Text('Bank debit card'),
              ),
              ListTile(
                leading: Icon(Icons.payment, color: Colors.orange),
                title: Text('PayPal'),
                subtitle: Text('Pay with PayPal account'),
              ),
              ListTile(
                leading: Icon(Icons.phone_android, color: Colors.black),
                title: Text('Apple Pay'),
                subtitle: Text('Touch ID or Face ID'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment method setup coming soon!')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPaymentMethodDialog(PaymentMethod paymentMethod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Payment Method'),
          content: Text('Edit ${paymentMethod.title}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment method editing coming soon!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(PaymentMethod paymentMethod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Payment Method'),
          content: Text('Are you sure you want to delete ${paymentMethod.title}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _paymentMethods.remove(paymentMethod);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${paymentMethod.title} deleted')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String title;
  final String subtitle;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.isDefault = false,
  });
}

enum PaymentType {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
}