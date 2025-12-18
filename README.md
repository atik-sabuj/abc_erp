# abc_erp

A **Flutter-based ERP Dashboard application of ABC Construction Ltd"** with **Dark UI**, dynamic **JSON data binding**, and structured navigation.

This app demonstrates how an ERP-style mobile application can be built using Flutter without any backend, powered entirely by a local JSON file.

---

## 🚀 Features

- 🌙 Fully Dark UI (modern & clean design)
- 📊 Dashboard with quick summary cards
- 📁 Project List & Project Details
- 👥 Task & Team Management
- 💳 Payments & Approval Flow
- 🔄 Dynamic data loading from `assets/data.json`
- 🧭 Smooth navigation between screens
- 🧱 Reusable widgets architecture

---

## 📂 Project Structure

```text
lib/
│
├── main.dart
│
├── data/
│   └── local_json_service.dart
│
├── screens/
│   ├── dashboard_page.dart
│   ├── project_list_page.dart
│   ├── project_details_page.dart
│   ├── task_team_page.dart
│   └── payments_page.dart
│
└── widgets/
    ├── summary_card.dart
    ├── status_badge.dart
    └── progress_bar.dart
