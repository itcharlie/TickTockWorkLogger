# Product Requirements Document: TickTockWorkLogger - V2 Refactor

## 1. Overview

This document outlines the plan to refactor the TickTockWorkLogger application to improve its maintainability, scalability, and reliability. The current implementation, while functional, suffers from a monolithic file structure, poor documentation, and a complete lack of automated tests. This refactor will address these critical issues, establishing a solid foundation for future development.

## 2. Goals (The "Why")

*   **Improve Code Quality:** Make the codebase easier to read, understand, and modify.
*   **Increase Reliability:** Ensure the application is stable and prevent regressions through automated testing.
*   **Enhance Maintainability:** Structure the project so that new features can be added and bugs can be fixed efficiently.

---

## 3. Phase 1: Code Refactoring & Modularization (Fixing "The Bad")

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
