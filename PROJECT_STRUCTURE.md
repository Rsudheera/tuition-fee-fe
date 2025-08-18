# Tuition Fee Management System

A Flutter application for teachers to manage their tuition classes, students, and payments.

## Features

- **Teacher Authentication**: Register and login functionality
- **Class Management**: Create, update, and manage tuition classes
- **Student Management**: Add students and assign them to classes
- **Payment Tracking**: Monitor monthly payments and track payment status
- **Dashboard**: Overview of classes, students, and payments

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── core/                              # Core functionality
│   ├── constants/                     # App constants
│   │   ├── app_constants.dart         # General app constants
│   │   └── api_endpoints.dart         # API endpoint definitions
│   ├── themes/                        # App theming
│   │   └── app_theme.dart             # Material theme configuration
│   └── utils/                         # Utility functions
│       ├── date_utils.dart            # Date formatting utilities
│       └── validation_utils.dart      # Form validation utilities
├── data/                              # Data layer
│   ├── models/                        # Data models
│   │   ├── teacher.dart               # Teacher model
│   │   ├── tuition_class.dart         # Class model
│   │   ├── student.dart               # Student model
│   │   ├── payment.dart               # Payment model
│   │   └── models.dart                # Export file for all models
│   ├── services/                      # External services
│   │   └── api_service.dart           # HTTP API service
│   └── repositories/                  # Data repositories
│       ├── auth_repository.dart       # Authentication operations
│       ├── class_repository.dart      # Class CRUD operations
│       └── repositories.dart          # Export file for repositories
└── presentation/                      # UI layer
    ├── screens/                       # App screens
    │   ├── auth/                      # Authentication screens
    │   │   └── login_screen.dart      # Login screen
    │   ├── dashboard/                 # Dashboard screens
    │   │   └── dashboard_screen.dart  # Main dashboard with tabs
    │   ├── classes/                   # Class management screens
    │   ├── students/                  # Student management screens
    │   └── payments/                  # Payment management screens
    ├── widgets/                       # Reusable widgets
    │   └── common/                    # Common widgets
    │       └── common_widgets.dart    # Buttons, text fields, etc.
    └── providers/                     # State management (Provider)
```

## Architecture

This project follows a **Clean Architecture** pattern with clear separation of concerns:

### 1. **Core Layer** (`core/`)

Contains app-wide utilities, constants, and configurations that are used across the entire application.

### 2. **Data Layer** (`data/`)

- **Models**: Plain Dart classes representing data structures
- **Services**: External service integrations (API, storage, etc.)
- **Repositories**: Data access layer that abstracts the data sources

### 3. **Presentation Layer** (`presentation/`)

- **Screens**: Complete UI screens
- **Widgets**: Reusable UI components
- **Providers**: State management using Provider package

## Key Models

### Teacher

- Personal information (name, email, phone)
- Authentication credentials
- Profile management

### TuitionClass

- Class details (name, subject, description)
- Payment information (monthly fee)
- Schedule and capacity management
- Teacher association

### Student

- Personal information and contact details
- Academic information (grade, school)
- Class assignments
- Parent contact information

### Payment

- Payment tracking for students
- Monthly fee management
- Payment status (pending, paid, overdue)
- Due date and payment history

## Getting Started

1. **Install Dependencies**:

   ```bash
   flutter pub get
   ```

2. **Update Backend URL**:
   Update the `baseUrl` in `lib/core/constants/app_constants.dart` with your backend API URL.

3. **Run the App**:
   ```bash
   flutter run
   ```

## Dependencies

- `http`: HTTP client for API communication
- `provider`: State management
- `shared_preferences`: Local data persistence
- `intl`: Date formatting and internationalization

## Future Enhancements

- [ ] Student registration screens
- [ ] Class creation and management screens
- [ ] Payment tracking and reporting
- [ ] Notification system
- [ ] Data export functionality
- [ ] Multi-language support
- [ ] Dark theme support

## Development Guidelines

1. **File Naming**: Use snake_case for file names
2. **Class Naming**: Use PascalCase for class names
3. **Variable Naming**: Use camelCase for variables and functions
4. **Import Organization**: Group imports (dart:, package:, relative)
5. **Code Documentation**: Add comments for complex logic
6. **Error Handling**: Implement proper try-catch blocks
7. **State Management**: Use Provider for state management
8. **Testing**: Write unit tests for business logic

## Contributing

1. Follow the established folder structure
2. Maintain clean architecture principles
3. Write meaningful commit messages
4. Add proper error handling
5. Update documentation for new features
