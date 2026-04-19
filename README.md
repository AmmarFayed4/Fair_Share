# 📱 FairShare – Smart Device Time Management

FairShare is a mobile application built with Flutter that helps parents fairly distribute screen time among multiple users sharing a single device.

The app uses a **share-based system** instead of fixed time limits, allowing flexible and fair usage while respecting daily routines like prayer, sleep, and study.

---

## 📥 Download

👉 Download APK: https://github.com/AmmarFayed4/Fair_Share/releases

---

## ✨ Features

### 🌍 Multi-language Support
- Supports **Arabic** and **English**

---

### 🔐 Parental Control
- Password required on first launch
- Prevents unauthorized access to:
  - Group settings
  - Time distribution

---

### 👥 Advanced Group Management
- Create and manage multiple groups
- Add, edit, and remove users داخل كل مجموعة

#### ⚖️ Share-Based Time Allocation
- Each user is assigned a **share value**
- Time is distributed proportionally based on shares  
  - Example:
    - User A → 1 share  
    - User B → 1 share  
    - User C → 1.5 shares  

---

### ⛔ Smart Blocked Time System
- Define periods where usage is paused:
  - Prayer times (added by default)
  - Sleep
  - Study
  - Custom periods

#### Behavior:
- Timer **automatically pauses**
- Resumes after blocked time ends

---

### 🕌 Prayer Time Integration
- Displays daily prayer times
- Data fetched from an external API
- Manual refresh available

---

### ⏱ Live Timer System
- Shows:
  - Current active user
  - Remaining time
  - Timer status (running / paused)

---

### 🔔 Smart Notifications
- Persistent notification with:
  - Live countdown timer
- Notifications for:
  - Time paused (e.g., prayer time)
  - Time resumed

---

### 📊 Schedule View
- Visual timeline of the day:
  - Users’ time slots
  - Blocked periods (prayers, sleep, etc.)

---

### 📅 Group Scheduling
- Assign specific days for each group
- Prevents overlap between groups

---

### ⚙️ Settings
- Change password
- Switch language

---

## 🛠 Tech Stack

- Flutter
- Dart
- REST API (Prayer Times)

---

## 🚀 Getting Started

```bash
git clone https://github.com/AmmarFayed4/Fair_Share.git
cd your-repo
flutter pub get
flutter run


---

## 👤 Author
- Ammar Fayed
