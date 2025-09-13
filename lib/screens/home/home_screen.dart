import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../../config/routes.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/payment_methods_screen.dart';
import '../profile/help_support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load physiotherapists when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AppointmentProvider>(context, listen: false)
            .loadPhysiotherapists();
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome, ${user.name}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: _getBodyContent(user),
          bottomNavigationBar: _buildBottomNav(user),
        );
      },
    );
  }

  Widget _getBodyContent(User user) {
    if (user.userType == UserType.patient) {
      return _buildPatientView();
    } else {
      return _buildPhysioView();
    }
  }

  Widget _buildPatientView() {
    switch (_currentIndex) {
      case 0:
        return _buildSearchScreen();
      case 1:
        return _buildAppointmentsScreen();
      case 2:
        return _buildProfileScreen();
      default:
        return _buildSearchScreen();
    }
  }

  Widget _buildPhysioView() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardScreen();
      case 1:
        return _buildAppointmentsScreen();
      case 2:
        return _buildProfileScreen();
      default:
        return _buildDashboardScreen();
    }
  }

  Widget _buildSearchScreen() {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find Physiotherapists',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              // Quick Appointment Creation Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showQuickAppointmentDialog(context),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Create New Appointment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name, specialization or keywords',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  _performSearch(value, appointmentProvider);
                },
              ),

              const SizedBox(height: 20),

              // Quick Filters
              Text(
                'Popular Specializations',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSpecializationChip('Sports Physiotherapy'),
                  _buildSpecializationChip('Orthopedic Physiotherapy'),
                  _buildSpecializationChip('Neurological Physiotherapy'),
                  _buildSpecializationChip('Pediatric Physiotherapy'),
                  _buildSpecializationChip('Geriatric Physiotherapy'),
                ],
              ),

              const SizedBox(height: 30),

              // Error handling
              if (appointmentProvider.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appointmentProvider.error!,
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          appointmentProvider.clearError();
                          appointmentProvider.loadPhysiotherapists();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),

              // Physiotherapists List
              Expanded(
                child: appointmentProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : appointmentProvider.physiotherapists.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount:
                                appointmentProvider.physiotherapists.length,
                            itemBuilder: (context, index) {
                              final physio =
                                  appointmentProvider.physiotherapists[index];
                              return _buildPhysioCardFromUser(physio);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardScreen() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        // Load user appointments when dashboard is opened
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (appointmentProvider.appointments.isEmpty) {
            appointmentProvider.loadUserAppointments(user.id, user.userType);
          }
        });

        // Calculate real stats from appointments
        final physioAppointments = appointmentProvider.getPhysiotherapistAppointments(user.id);
        final completedAppointments = physioAppointments.where((apt) => apt.status == AppointmentStatus.completed).toList();
        final totalEarnings = completedAppointments.fold(0.0, (sum, apt) => sum + apt.amount);
        final todayAppointments = appointmentProvider.getTodayAppointmentsForPhysio(user.id);
        final pendingAppointments = appointmentProvider.getPendingAppointmentsForPhysio(user.id);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Dashboard',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      appointmentProvider.loadUserAppointments(user.id, user.userType);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Stats Cards with real data
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Total Earnings', '\$${totalEarnings.toStringAsFixed(0)}', Icons.attach_money),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Total Appointments', '${physioAppointments.length}', Icons.calendar_today),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Today\'s Appointments', '${todayAppointments.length}', Icons.today),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Pending Requests', '${pendingAppointments.length}', Icons.pending_actions),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Rating', '${user.rating?.toStringAsFixed(1) ?? '0.0'}', Icons.star),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Reviews', '${user.totalReviews ?? 0}', Icons.reviews),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Pending appointments section
              if (pendingAppointments.isNotEmpty) ...[
                Text(
                  'Pending Appointment Requests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: pendingAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = pendingAppointments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.schedule, color: Colors.orange),
                          title: Text('Appointment Request'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${appointment.appointmentDate.day}/${appointment.appointmentDate.month} at ${appointment.appointmentTime}'),
                              Text('${_getAppointmentTypeText(appointment.type)} - \$${appointment.amount.toStringAsFixed(0)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => _acceptAppointment(appointment.id, appointmentProvider),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _rejectAppointment(appointment.id, appointmentProvider),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                Text(
                  'Recent Activities',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                
                Expanded(
                  child: completedAppointments.isNotEmpty 
                    ? ListView.builder(
                        itemCount: completedAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = completedAppointments[index];
                          return _buildActivityItem(
                            'Completed appointment - ${_getAppointmentTypeText(appointment.type)}',
                            '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}',
                          );
                        },
                      )
                    : const Center(
                        child: Text('No recent activities'),
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _acceptAppointment(String appointmentId, AppointmentProvider provider) async {
    final success = await provider.acceptAppointment(appointmentId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment accepted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept appointment: ${provider.error}')),
      );
    }
  }

  void _rejectAppointment(String appointmentId, AppointmentProvider provider) async {
    final success = await provider.rejectAppointment(appointmentId, 'Rejected by physiotherapist');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment rejected')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject appointment: ${provider.error}')),
      );
    }
  }

  Widget _buildAppointmentsScreen() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Appointments',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        appointmentProvider.loadUserAppointments(user.id, user.userType);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Error handling
                if (appointmentProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            appointmentProvider.error!,
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            appointmentProvider.clearError();
                            appointmentProvider.loadUserAppointments(user.id, user.userType);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),

                // Tabs for different appointment states
                Expanded(
                  child: Column(
                    children: [
                      if (_tabController != null) ...[
                        TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'Upcoming'),
                            Tab(text: 'Completed'),
                            Tab(text: 'Cancelled'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: appointmentProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildAppointmentsList('upcoming'),
                                    _buildAppointmentsList('completed'),
                                    _buildAppointmentsList('cancelled'),
                                  ],
                                ),
                        ),
                      ] else ...[
                        const Center(child: CircularProgressIndicator()),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileScreen() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser!;
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 8),
              
              Chip(
                label: Text(user.userType == UserType.patient ? 'Patient' : 'Physiotherapist'),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              
              const SizedBox(height: 30),
              
              // Profile Options
              Expanded(
                child: ListView(
                  children: [
                    _buildProfileOption(
                      Icons.person, 
                      'Edit Profile', 
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      ),
                    ),
                    _buildProfileOption(Icons.notifications, 'Notifications', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications feature coming soon!')),
                      );
                    }),
                    _buildProfileOption(
                      Icons.payment, 
                      'Payment Methods', 
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
                      ),
                    ),
                    _buildProfileOption(
                      Icons.help, 
                      'Help & Support', 
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                      ),
                    ),
                    _buildProfileOption(Icons.privacy_tip, 'Privacy Policy', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy Policy coming soon!')),
                      );
                    }),
                    _buildProfileOption(Icons.info, 'About', () {
                      _showAboutDialog(context);
                    }),
                    const Divider(),
                    _buildProfileOption(
                      Icons.logout, 
                      'Logout', 
                      () => _showLogoutDialog(context),
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(User user) {
    if (user.userType == UserType.patient) {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    } else {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    }
  }

  Widget _buildSpecializationChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
        appointmentProvider.loadPhysiotherapists(specialization: text);
      },
    );
  }

  Widget _buildPhysioCard(String name, String specialization, double rating, String price, String availability) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(name[0]),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(specialization),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' $rating'),
                const Spacer(),
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            Text(availability, style: const TextStyle(fontSize: 10)),
          ],
        ),
        onTap: () {
          // Navigate to physiotherapist detail
        },
      ),
    );
  }

     Widget _buildPhysioCardFromUser(User physio) {
     return Card(
       margin: const EdgeInsets.only(bottom: 12),
       child: ListTile(
         leading: CircleAvatar(
           backgroundColor: Theme.of(context).primaryColor,
           child: Text(physio.name[0].toUpperCase()),
         ),
         title: Text(physio.name),
         subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(physio.specialization ?? 'Physiotherapist'),
             Row(
               children: [
                 Icon(Icons.star, color: Colors.amber, size: 16),
                 Text(' ${physio.rating?.toStringAsFixed(1) ?? '0.0'}'),
                 Text(' (${physio.totalReviews ?? 0} reviews)'),
                 const Spacer(),
                 Text(
                   '\$${physio.hourlyRate?.toStringAsFixed(0) ?? '0'}/hour',
                   style: const TextStyle(fontWeight: FontWeight.bold),
                 ),
               ],
             ),
           ],
         ),
         trailing: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const Icon(Icons.check_circle, color: Colors.green),
             Text(
               'Available',
               style: TextStyle(
                 fontSize: 10,
                 color: Colors.grey[600],
               ),
             ),
           ],
         ),
         onTap: () {
           // Navigate to booking screen
           Navigator.of(context).pushNamed(
             AppRoutes.booking,
             arguments: {'physiotherapist': physio},
           );
         },
       ),
     );
   }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No physiotherapists found. Try adjusting your search or filters.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query, AppointmentProvider appointmentProvider) {
    if (query.isEmpty) {
      appointmentProvider.loadPhysiotherapists();
    } else {
      // Filter existing physiotherapists by the search query
      final filteredPhysios = appointmentProvider.searchPhysiotherapists(query);
      // The search method in provider will handle the filtering
      appointmentProvider.notifyListeners();
    }
  }

  void _showQuickAppointmentDialog(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Appointment'),
          content: const Text('Choose a physiotherapist to book an appointment with:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Check if there are any physiotherapists available
                if (appointmentProvider.physiotherapists.isNotEmpty) {
                  // Show list of physiotherapists to choose from
                  _showPhysiotherapistSelectionDialog(context);
                } else {
                  // Load physiotherapists first
                  appointmentProvider.loadPhysiotherapists().then((_) {
                    if (appointmentProvider.physiotherapists.isNotEmpty) {
                      _showPhysiotherapistSelectionDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No physiotherapists available')),
                      );
                    }
                  });
                }
              },
              child: const Text('Choose Physiotherapist'),
            ),
          ],
        );
      },
    );
  }

  void _showPhysiotherapistSelectionDialog(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Physiotherapist'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: appointmentProvider.physiotherapists.length,
              itemBuilder: (context, index) {
                final physio = appointmentProvider.physiotherapists[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(physio.name[0].toUpperCase()),
                  ),
                  title: Text(physio.name),
                  subtitle: Text(physio.specialization ?? 'Physiotherapist'),
                  trailing: Text('\$${physio.hourlyRate?.toStringAsFixed(0) ?? '0'}/hr'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(
                      AppRoutes.booking,
                      arguments: {'physiotherapist': physio},
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 12, color: Colors.blue),
      title: Text(title),
      subtitle: Text(time),
    );
  }

  Widget _buildAppointmentsList(String type) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        final authProvider = Provider.of<AuthProvider>(context);
        final user = authProvider.currentUser;
        
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Appointment> appointments;
        
        switch (type) {
          case 'upcoming':
            appointments = appointmentProvider.getUpcomingAppointments(user.id, user.userType == UserType.patient);
            break;
          case 'completed':
            appointments = appointmentProvider.getCompletedAppointments(user.id, user.userType == UserType.patient);
            break;
          case 'cancelled':
            appointments = appointmentProvider.getAppointmentsForUser(user.id, user.userType == UserType.patient)
                .where((apt) => apt.status == AppointmentStatus.cancelled)
                .toList();
            break;
          default:
            appointments = [];
        }

        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  type == 'upcoming' ? Icons.event_available : 
                  type == 'completed' ? Icons.check_circle_outline : Icons.cancel_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${type} appointments',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCardFromData(appointment, user.userType);
          },
        );
      },
    );
  }

    Widget _buildAppointmentCard(String doctor, String specialization, String time, String type, String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'upcoming':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(doctor),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(specialization),
            Text(time),
            Text(type, style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Show appointment options
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentCardFromData(Appointment appointment, UserType userType) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (appointment.status) {
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusText = 'Pending';
        break;
      case AppointmentStatus.confirmed:
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle;
        statusText = 'Confirmed';
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Cancelled';
        break;
      case AppointmentStatus.rescheduled:
        statusColor = Colors.purple;
        statusIcon = Icons.update;
        statusText = 'Rescheduled';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userType == UserType.patient 
                          ? 'Appointment with Provider'
                          : 'Appointment with Patient',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${appointment.appointmentDate.day}/${appointment.appointmentDate.month} at ${appointment.appointmentTime}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getAppointmentTypeText(appointment.type),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${appointment.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAppointmentTypeText(AppointmentType type) {
    switch (type) {
      case AppointmentType.homeVisit:
        return 'Home Visit';
      case AppointmentType.clinicSession:
        return 'Clinic Session';
      case AppointmentType.virtualConsultation:
        return 'Virtual Consultation';
    }
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Appointment Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Date & Time', 
                        '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year} at ${appointment.appointmentTime}'),
                    _buildDetailRow('Type', _getAppointmentTypeText(appointment.type)),
                    _buildDetailRow('Status', appointment.status.toString().split('.').last),
                    _buildDetailRow('Amount', '\$${appointment.amount.toStringAsFixed(2)}'),
                    if (appointment.notes != null)
                      _buildDetailRow('Notes', appointment.notes!),
                    if (appointment.address != null)
                      _buildDetailRow('Address', appointment.address!),
                    if (appointment.clinicName != null)
                      _buildDetailRow('Clinic', appointment.clinicName!),
                    const SizedBox(height: 20),
                    if (appointment.status == AppointmentStatus.confirmed) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCancelDialog(appointment);
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel Appointment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Appointment appointment) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this appointment?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for cancellation (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Appointment'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelAppointment(appointment.id, reasonController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(String appointmentId, String reason) async {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    
    final success = await appointmentProvider.cancelAppointment(
      appointmentId, 
      reason.isNotEmpty ? reason : 'Cancelled by user'
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment cancelled successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel appointment: ${appointmentProvider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: 'PhysioHire',
          applicationVersion: '1.0.0',
          applicationIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.health_and_safety,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          children: const [
            Text('Your comprehensive physiotherapy platform connecting patients with certified physiotherapists.'),
            SizedBox(height: 16),
            Text('© 2024 PhysioHire Team. All rights reserved.'),
          ],
        );
      },
    );
  }
}
