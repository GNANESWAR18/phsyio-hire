# PhysioHiree 🏥

A comprehensive physiotherapy platform that connects patients with licensed physiotherapists, enabling seamless appointment booking, management, and healthcare coordination.

## ✨ Features

### 🔐 Authentication & User Management
- **Multi-role Support**: Patient and Physiotherapist accounts
- **Secure Login/Registration**: Email-based authentication with demo accounts
- **Profile Management**: Complete user profiles with medical information
- **Quick Demo Access**: Instant access with demo credentials

### 👥 Patient Features
- **Physiotherapist Search**: Browse and search physiotherapists by specialization
- **Appointment Creation**: Easy appointment booking with multiple options
- **Profile Setup**: Complete medical history and personal information
- **Appointment Management**: View, cancel, and track appointment status
- **Quick Appointment Button**: Prominent button for creating new appointments

### 🩺 Physiotherapist Features
- **Professional Dashboard**: Overview of earnings, appointments, and ratings
- **Appointment Management**: View and manage patient appointments
- **Profile Customization**: Specialization, experience, and certification details
- **Real-time Updates**: Immediate notification of new appointment requests

### 📅 Appointment System
- **Multiple Types**: Home visits, clinic sessions, and virtual consultations
- **Status Tracking**: Pending, confirmed, completed, cancelled, and rescheduled
- **Real-time Updates**: Instant reflection of appointments across user types
- **Flexible Scheduling**: Date and time selection with notes and location

### 🎨 User Interface
- **Modern Design**: Clean, intuitive Material Design interface
- **Responsive Layout**: Optimized for mobile and tablet devices
- **Tabbed Navigation**: Organized content with easy switching
- **Search & Filters**: Advanced filtering by specialization, rating, and price

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android Emulator or physical device

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/physiohiree.git
   cd physiohiree
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

### Demo Accounts
- **Patient Demo**: `patient@demo.com` / `demo123`
- **Physiotherapist Demo**: `physio@demo.com` / `demo123`

## 🏗️ Architecture

### State Management
- **Provider Pattern**: Efficient state management with ChangeNotifier
- **Separation of Concerns**: Clear separation between UI, business logic, and data

### Data Models
- **User Model**: Comprehensive user information with role-specific fields
- **Appointment Model**: Complete appointment tracking with status management
- **Review Model**: Rating and feedback system

### Services
- **Mock Database Service**: Simulated backend for development and testing
- **Authentication Service**: User authentication and session management
- **Appointment Service**: Appointment creation, management, and status updates

## 📱 Screens & Navigation

### Main Screens
1. **Welcome Screen**: App introduction with quick demo access
2. **Login/Signup**: User authentication with role selection
3. **Profile Setup**: Patient profile completion (age, medical history, etc.)
4. **Home Screen**: Main dashboard with role-specific content
5. **Booking Screen**: Appointment creation and management
6. **Appointments Tab**: View and manage existing appointments

### Navigation Flow
```
Welcome → Login/Signup → Profile Setup (if patient) → Home Screen
                ↓
        [Search Physiotherapists] → [Book Appointment] → [Appointment Created]
                ↓
        [View Appointments] → [Manage Status] → [Complete/Cancel]
```

## 🔧 Technical Implementation

### Key Components
- **AppointmentProvider**: Manages appointment state and operations
- **AuthProvider**: Handles user authentication and profile data
- **MockDatabaseService**: Simulates real database operations
- **Responsive UI**: Adaptive layouts for different screen sizes

### Appointment Creation Flow
1. Patient searches for physiotherapist
2. Clicks "Create New Appointment" button
3. Selects appointment type, date, time, and adds notes
4. Appointment is created with "Pending" status
5. Physiotherapist sees appointment in their dashboard
6. Physiotherapist can accept, reject, or modify appointment

### Real-time Updates
- Appointments appear immediately for both patients and physiotherapists
- Status changes are reflected across all user interfaces
- Provider pattern ensures consistent state management

## 🎯 Use Cases

### For Patients
- Find qualified physiotherapists in their area
- Book appointments based on availability and preferences
- Track appointment status and history
- Manage personal medical information

### For Physiotherapists
- Receive appointment requests from patients
- Manage appointment schedule and availability
- Track earnings and patient feedback
- Maintain professional profile and credentials

## 🚧 Development Status

### ✅ Completed Features
- User authentication and role management
- Patient profile setup and management
- Physiotherapist search and filtering
- Appointment creation and booking
- Real-time appointment status updates
- Responsive UI with modern design

### 🔄 In Progress
- Payment processing integration
- Video consultation features
- Advanced scheduling algorithms
- Push notifications

### 📋 Planned Features
- Electronic health records
- Prescription management
- Insurance integration
- Multi-language support
- Advanced analytics dashboard

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team
- Check the documentation for common solutions

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI inspiration
- Open source community for libraries and tools
- Beta testers for valuable feedback

---

**PhysioHiree** - Connecting patients with quality physiotherapy care, one appointment at a time. 🏥✨
