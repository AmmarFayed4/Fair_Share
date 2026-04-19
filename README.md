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
## 📸 Screenshots
<img width="1080" height="2408" alt="Screenshot_20260419_152750" src="https://github.com/user-attachments/assets/0d16b8d1-ab1f-43e4-88fe-b7182a533a59" />
<img width="1080" height="2408" alt="Screenshot_20260419_152807" src="https://github.com/user-attachments/assets/c68a3ae9-b41a-43a8-82de-765998b43821" />
<img width="1080" height="2408" alt="Screenshot_20260419_152812" src="https://github.com/user-attachments/assets/d4d9fe79-ff7b-4e24-a20f-6bdcc73960cb" />
<img width="1080" height="2408" alt="Screenshot_20260419_152820" src="https://github.com/user-attachments/assets/b36a4ead-a55a-4da3-879d-251542220205" />
<img width="1080" height="2408" alt="Screenshot_20260419_152730" src="https://github.com/user-attachments/assets/d13d99e2-9a4d-43c8-a739-8dac0a027134" />
<img width="1080" height="2408" alt="Screenshot_20260419_152744" src="https://github.com/user-attachments/assets/a20015bd-1ebe-4d60-865d-b832ccbbbec0" />

---
## 👤 Author
- Ammar Fayed

## 🚀 Getting Started

```bash
git clone https://github.com/AmmarFayed4/Fair_Share.git
cd your-repo
flutter pub get
flutter run



