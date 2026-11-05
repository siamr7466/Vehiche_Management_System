# VehiclePro • Vehicle Management System (VMS)

Enterprise-grade Vehicle Management System built with **Flutter Web**, adhering strictly to clean architecture and a cohesive corporate design system.

---

## 🎨 Unified Design System & Palette

Designed for business clarity and high-contrast readability:

| Color Token | Hex Code | Role in Application |
| :--- | :--- | :--- |
| **Deep Blue** | `#1F4E79` | Left Navigation, Brand Logo, Page & Dialog Headings |
| **Corporate Blue** | `#5B9BD5` | Primary Actions (`+ Register Vehicle`), Highlights |
| **Soft Gray** | `#F5F7FA` | Application Canvas / Page Background |
| **White** | `#FFFFFF` | Cards, Modal Dialogs, Input Fields & Table Surfaces |
| **Charcoal** | `#1F2937` | High-Contrast Main Text & Field Labels |
| **Green** | `#2E7D32` | Active Status Indicators (`● Active`) & Success Feedback |
| **Red** | `#D32F2F` | Delete Actions (`🗑 Delete`) & Form Validation Errors |

---

## 🖥 Application Layout & Structure

* **Left Sidebar Navigation (Desktop)**: Fixed navigation pane with brand logo, section headers, Dashboard & Vehicles tabs, Administrator session card, and Sign Out action. Collapses gracefully to a navigation drawer on mobile viewports (< 850px).
* **Workspace Area (Right)**:
  * **Top Bar**: Breadcrumb hierarchy (`VehiclePro / Vehicles`), Operational Refresh action, Notification alerts, and User Profile badge.
  * **Page Header**: Distinct screen title on the left, primary call-to-action button (`+ Register Vehicle`) on the top right.
  * **Fleet Metrics Summary**: Metric cards tracking total vehicles, active status, and maintenance counts.
  * **Search & Filter Bar**: Instant text search by plate, make, model, or owner; dropdown filters for vehicle type and status; active result counter.
  * **Adaptive Workspace**: 100% full-width responsive data table with formatted license plate badges, status pills, and action buttons on desktop; card view on mobile viewports.

---

## ⚡ Core Features

- **Authentication**: Administrator sign-in screen with 1-click demo auto-fill and validation.
- **Fleet Management (CRUD)**:
  - Register new vehicles with duplicate license plate detection.
  - Search across multiple vehicle attributes simultaneously.
  - Filter by Vehicle Type (`Car`, `SUV`, `Truck`, `Motorcycle`, `Van`, `Bus`) and Status (`Active`, `Under Maintenance`, `Inactive`).
  - View detailed vehicle overview modal with license plate badge.
  - Edit existing records with pre-populated form values.
  - Delete vehicle with safety confirmation modal.
- **Decoupled Architecture**: Clean `VehicleRepository` pattern operating with in-memory mock data, ready for seamless Spring Boot REST API integration.

---

## 🚀 Getting Started Locally

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
* Chrome / Edge or any modern web browser

### Running the Project

```bash
# Clone the repository
git clone https://github.com/siamr7466/Vehiche_Management_System.git
cd Vehiche_Management_System

# Install Flutter dependencies
flutter pub get

# Run on Chrome or Edge (Web)
flutter run -d edge
# or
flutter run -d chrome
```

### Demo Login Credentials
* **Username**: `admin`
* **Password**: `admin`
*(Or click "Auto-fill credentials" on the sign-in screen)*

---

## 📁 Project Architecture

```
lib/
├── constants/
│   ├── app_constants.dart      # Vehicle types, statuses, validation rules
│   ├── app_routes.dart         # Named routing table
│   └── app_theme.dart          # Central design system (Colors, Spacing, Typography)
├── data/
│   └── mock_vehicles.dart      # Starter fleet dataset
├── models/
│   └── vehicle.dart            # Immutable Vehicle domain model
├── screens/
│   ├── login_screen.dart       # Branded administrator sign-in
│   └── vehicle_list_screen.dart# Main workspace layout (Dashboard & Table)
├── services/
│   ├── api_service.dart        # Backend HTTP client contract (Phase 2)
│   ├── auth_service.dart       # In-memory session authentication
│   └── vehicle_repository.dart # Decoupled fleet state repository
└── widgets/
    ├── app_dialog_header.dart  # Standardized modal dialog header
    ├── app_logo.dart           # VehiclePro brand mark
    ├── app_sidebar.dart        # Left desktop navigation / mobile drawer
    ├── app_top_bar.dart        # Breadcrumb top workspace bar
    ├── dashboard_overview_view.dart # Fleet breakdown & quick actions
    ├── delete_action_button.dart    # Red action button (#D32F2F / #FFEBEE)
    ├── delete_confirmation_dialog.dart # Deletion safety prompt
    ├── page_header.dart        # Title left / Action right header
    ├── registration_plate_badge.dart # License plate badge
    ├── stat_card.dart          # Fleet metric card
    ├── status_badge.dart       # Green active pill (#2E7D32 / #E8F5E9)
    ├── vehicle_details_dialog.dart  # Vehicle inspection modal
    └── vehicle_form_dialog.dart     # Add / Edit vehicle modal
```
