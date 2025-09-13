import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help you?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find answers to common questions or get in touch with our support team',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions
            _buildSection(
              'Quick Actions',
              [
                _buildActionTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Live Chat',
                  subtitle: 'Chat with our support team',
                  onTap: () => _showComingSoonDialog(context, 'Live Chat'),
                ),
                _buildActionTile(
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'Send us an email',
                  onTap: () => _showEmailDialog(context),
                ),
                _buildActionTile(
                  icon: Icons.phone_outlined,
                  title: 'Call Support',
                  subtitle: '+1 (555) 123-4567',
                  onTap: () => _showCallDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Frequently Asked Questions
            _buildSection(
              'Frequently Asked Questions',
              [
                _buildFAQTile(
                  'How do I book an appointment?',
                  'You can book an appointment by searching for physiotherapists in your area, selecting one, and choosing your preferred date and time.',
                ),
                _buildFAQTile(
                  'Can I cancel or reschedule my appointment?',
                  'Yes, you can cancel or reschedule your appointment up to 24 hours before the scheduled time through the app.',
                ),
                _buildFAQTile(
                  'How do I make payments?',
                  'You can add payment methods in your profile settings. Payments are processed securely after your appointment.',
                ),
                _buildFAQTile(
                  'What if I need to change my profile information?',
                  'You can update your profile information anytime by going to Profile > Edit Profile.',
                ),
                _buildFAQTile(
                  'How do I leave a review?',
                  'After completing an appointment, you\'ll receive a notification to rate and review your physiotherapist.',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Account & Billing
            _buildSection(
              'Account & Billing',
              [
                _buildActionTile(
                  icon: Icons.account_circle_outlined,
                  title: 'Account Issues',
                  subtitle: 'Login, password, profile problems',
                  onTap: () => _showComingSoonDialog(context, 'Account Support'),
                ),
                _buildActionTile(
                  icon: Icons.receipt_outlined,
                  title: 'Billing & Payments',
                  subtitle: 'Payment issues, refunds',
                  onTap: () => _showComingSoonDialog(context, 'Billing Support'),
                ),
                _buildActionTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Data protection, security concerns',
                  onTap: () => _showComingSoonDialog(context, 'Privacy Support'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // App Information
            _buildSection(
              'App Information',
              [
                _buildInfoTile('Version', '1.0.0'),
                _buildInfoTile('Last Updated', 'December 2024'),
                _buildInfoTile('Developer', 'PhysioHire Team'),
              ],
            ),

            const SizedBox(height: 32),

            // Contact Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(Icons.email, 'support@physiohire.com'),
                    const SizedBox(height: 8),
                    _buildContactItem(Icons.phone, '+1 (555) 123-4567'),
                    const SizedBox(height: 8),
                    _buildContactItem(Icons.access_time, 'Mon-Fri, 9 AM - 6 PM EST'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text('$feature is coming soon! We\'re working hard to bring you this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send us an email at:'),
              SizedBox(height: 8),
              SelectableText(
                'support@physiohire.com',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('We typically respond within 24 hours.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email app integration coming soon!')),
                );
              },
              child: const Text('Send Email'),
            ),
          ],
        );
      },
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Call Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Call us at:'),
              SizedBox(height: 8),
              SelectableText(
                '+1 (555) 123-4567',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text('Support hours: Monday - Friday, 9 AM - 6 PM EST'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone dialer integration coming soon!')),
                );
              },
              child: const Text('Call Now'),
            ),
          ],
        );
      },
    );
  }
}