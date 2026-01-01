# Product Requirements Document: TickTockWorkLogger - V2 Refactor

## 1. Overview

This document outlines the plan to refactor the TickTockWorkLogger application to improve its maintainability, scalability, and reliability. The current implementation, while functional, suffers from a monolithic file structure, poor documentation, and a complete lack of automated tests. This refactor will address these critical issues, establishing a solid foundation for future development.

## 2. Goals (The "Why")

*   **Improve Code Quality:** Make the codebase easier to read, understand, and modify.
*   **Increase Reliability:** Ensure the application is stable and prevent regressions through automated testing.
*   **Enhance Maintainability:** Structure the project so that new features can be added and bugs can be fixed efficiently.

---

## 3. Codebase Analysis: Good, Bad, and Ugly

### The Good
*   **Standard Structure:** The project follows a standard and recognizable Flutter project layout.
*   **State Management:** It correctly uses the `provider` package for centralized state management, which is a good practice for Flutter apps.
*   **Performance:** The UI likely performs well by using `Consumer` widgets to rebuild only the necessary parts of the UI when data changes.
*   **Encapsulation:** The `StaffProvider` exposes its list of staff members as an unmodifiable list, which is a good defensive programming practice.

### The Bad
*   **Mutable Data Models:** The `StaffMember` and `WorkEntry` classes have properties that can be changed from anywhere in the app, which can lead to unpredictable state and bugs.
*   **In-memory Storage Only:** The app stores all data in memory. This is the most significant issue; if the user closes the app, all staff members and work entries are lost. There is no database or file storage.
*   **String-based Dates:** Storing dates as `String` objects in `work_entry.dart` is inefficient and makes sorting, filtering, or performing any date-based calculations difficult and error-prone. They should be stored as `DateTime` objects.

### The Ugly
*   **"Fat Widget":** The `StaffListScreen` is a classic "fat widget" or "God object." It contains UI, business logic, and state management all in one massive file. This makes it extremely difficult to test, maintain, and understand. For example, it directly manages dialogs for both recording work and editing staff members.
*   **Potential for Stale Data:** The `WorkEntriesScreen` does not actively listen to the `StaffProvider`. This means that if a new work entry is added from another screen, this screen will not update and will display out-of-date information.

---

## 4. Phase 1: Code Refactoring & Modularization (Fixing "The Bad")

### 3.1. Problem: Single-File Architecture

The entire application currently resides in `lib/main.dart`. This is not scalable and makes the code difficult to navigate.

### 3.2. Solution: Implement a Feature-Based Directory Structure

We will break the single file into a logical directory structure within the `lib/` folder.

*   **`lib/`**
    *   **`main.dart`**: App entry point and root widget.
    *   **`models/`**: Contains the data model classes.
        *   `staff_member.dart`
        *   `work_entry.dart`
    *   **`providers/`**: Contains the state management logic.
        *   `staff_provider.dart`
    *   **`screens/`**: Contains the application's screens or pages.
        *   `staff_list/`
            *   `staff_list_screen.dart`
            *   `widgets/` (Screen-specific widgets, e.g., dialogs)
        *   `work_entries/`
            *   `work_entries_screen.dart`

### 3.3. Acceptance Criteria

*   The `lib/` directory is organized according to the structure defined above.
*   The application compiles and runs with no change in functionality.
*   The `main.dart` file is significantly smaller, serving only as the application's entry point.

---

## 4. Phase 2: Documentation (Fixing "The Bad")

### 4.1. Problem: Lack of Documentation

The `README.md` is a template, and the code lacks comments, making it difficult for new developers to onboard.

### 4.2. Solution: Create Comprehensive Documentation

*   **Update `README.md`**: Add a project description, list of features, instructions on how to run the app, and an overview of the project structure.
*   **Add Code Comments**: Add comments to complex or non-obvious parts of the code, particularly within the `StaffProvider`, explaining the business logic.

### 4.3. Acceptance Criteria

*   `README.md` is updated and provides a useful overview of the project.
*   Code comments are added where necessary to improve clarity.

---

## 5. Phase 3: Unit & Widget Testing (Fixing "The Ugly")

### 5.1. Problem: No Automated Tests

The absence of tests means that every change requires full manual regression testing, and bugs can easily be introduced.

### 5.2. Solution: Implement a Testing Suite

We will create a `test/` directory and implement the following:

*   **Unit Tests**:
    *   Test the business logic in `StaffProvider`.
    *   Verify calculations for `totalHours` and `totalTips` in the `StaffMember` model.
    *   Ensure `generateSummary` produces correct results.
*   **Widget Tests**:
    *   Test the `StaffListScreen` to ensure staff members are displayed correctly.
    *   Test adding, editing, and deleting staff members through the UI.
    *   Test the presentation of the `WorkEntriesScreen`.
    *   Verify that dialogs appear when their corresponding buttons are pressed.

### 5.3. Acceptance Criteria

*   A `test/` directory is created with a logical structure mirroring the `lib/` directory.
*   Unit tests for providers and models are implemented and passing.
*   Widget tests for the main screens and interactions are implemented and passing.
*   A reasonable test coverage is achieved (e.g., >70%).
