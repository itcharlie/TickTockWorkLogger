# TickTockWorkLogger

TickTockWorkLogger is a streamlined Flutter application designed to empower individuals and small businesses in efficiently managing staff and meticulously tracking work hours and tips. This tool simplifies daily work entry recording and provides comprehensive summaries for all team members, enhancing organizational efficiency and financial oversight.

## This software is not Production ready!!! use at your own risk

## Features

- **Staff Management**: Add, edit, and delete staff members.
- **Work Tracking**: Record hours worked and tips earned for each staff member by date.
- **Summary Generation**: View an overall summary including total hours, total tips, and total staff count.
- **Modular Architecture**: Built with a feature-based structure for better maintainability.
- **State Management**: Utilizes the `provider` package for efficient state handling.

## Project Structure

The project follows a modular structure within the `lib/` directory:

- `lib/main.dart`: App entry point and root widget.
- `lib/models/`: Data model classes for `StaffMember` and `WorkEntry`.
- `lib/providers/`: State management logic (`StaffProvider`).
- `lib/screens/`: UI screens for the application.
    - `staff_list/`: Screen for managing the list of staff members.
    - `work_entries/`: Screen for recording and viewing work entries for a specific staff member.

## Getting Started

### Prerequisites

- Flutter SDK (v3.0.0 or higher)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd TickTockWorkLogger
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

To run the app in debug mode on your connected device or emulator:

```bash
flutter run
```

## Testing

The project includes unit and widget tests to ensure reliability. (Phase 3 in progress)

To run the tests:

```bash
flutter test
```
