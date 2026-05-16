# MVVM Pattern Implementation - CatatLari App (Tahap 3)

## 📋 Ringkasan Refactoring

Aplikasi CatatLari telah berhasil direfactor menggunakan **MVVM (Model-View-ViewModel)** pattern dengan Provider untuk state management.

## 🏗️ Struktur Arsitektur MVVM

```
lib/
├── models/                    # Data Models
│   ├── running_model.dart
│   └── user_model.dart
├── viewmodels/               # Business Logic & State Management
│   ├── base_view_model.dart
│   ├── login_view_model.dart
│   ├── register_view_model.dart
│   ├── home_view_model.dart
│   ├── add_running_view_model.dart
│   └── profile_view_model.dart
├── pages/                     # UI Layer (Views)
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   ├── add_running_page.dart
│   └── profile_page.dart
├── services/                  # Data Access Layer
│   └── local_storage_service.dart
└── main.dart                  # App Entry Point with Provider Setup
```

## 🔄 Komponen MVVM

### 1. **Model (M)**
- `RunningModel` - Data model untuk log lari
- `UserModel` - Data model untuk pengguna

### 2. **ViewModel (VM)**
Mengelola business logic, state, dan interaksi dengan service:

#### **BaseViewModel**
```dart
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  void setLoading(bool value) => _isLoading = value;
}
```

#### **LoginViewModel**
- `login()` - Autentikasi user
- `togglePasswordVisibility()` - Toggle password visibility

#### **RegisterViewModel**
- `register()` - Registrasi user baru
- `togglePasswordVisibility()` & `toggleConfirmVisibility()`

#### **HomeViewModel**
- `loadRunningLogs()` - Fetch semua log lari
- `deleteLog()` - Hapus log lari
- `getUser()` - Ambil data user

#### **AddRunningViewModel**
- `saveRunning()` - Simpan log lari baru
- TextController management untuk form inputs

#### **ProfileViewModel**
- `initializeControllers()` - Inisialisasi dengan data user
- `saveProfile()` - Update profil user

### 3. **View (V)**
Widgets yang hanya menangani UI rendering dan user interactions:
- LoginPage, RegisterPage, HomePage, AddRunningPage, ProfilePage
- Menggunakan `Consumer<ViewModel>` untuk reactive UI updates

### 4. **Service (S)**
- `LocalStorageService` - Abstraksi data access dengan SharedPreferences

## 📦 Dependencies

```yaml
dependencies:
  provider: ^6.0.0
  shared_preferences: ^2.0.20
```

## 🎯 Keuntungan MVVM Pattern

✅ **Separation of Concerns** - UI terpisah dari business logic
✅ **Testability** - ViewModel dapat ditest tanpa UI
✅ **Reusability** - Logic dapat digunakan di berbagai widget
✅ **Maintainability** - Kode lebih terstruktur dan mudah dipahami
✅ **State Management** - Menggunakan Provider untuk reactive updates
✅ **Error Handling** - Centralized error handling di ViewModel

## 🔌 Provider Setup (main.dart)

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ],
  child: MaterialApp(...)
)
```

Setiap halaman membuat ViewModel-nya sendiri dengan `ChangeNotifierProvider`.

## 🚀 Alur Eksekusi

### Login Flow
1. User input email & password
2. LoginPage → Call `LoginViewModel.login()`
3. ViewModel → Call `LocalStorageService.getUser()`
4. Verify credentials → Return UserModel
5. Navigate ke HomePage dengan user data

### Add Running Flow
1. User input tanggal, jarak, durasi
2. AddRunningPage → Call `AddRunningViewModel.saveRunning()`
3. ViewModel → Validate input → Call `LocalStorageService.saveRunning()`
4. ViewModel → Set loading state → Navigate back

### Home Flow
1. HomePage init → Load `HomeViewModel`
2. ViewModel → Call `loadRunningLogs()` on init
3. UI rebuild with data dari ViewModel
4. User delete log → Call `deleteLog()` → Reload data

## 📝 Catatan Implementasi

- **Consumer Pattern**: Digunakan untuk react terhadap perubahan state
- **ChangeNotifier**: Digunakan sebagai base class untuk semua ViewModel
- **Error Handling**: Exceptions di ViewModel di-catch dan di-display via SnackBar
- **Loading State**: Setiap operasi async menggunakan `setLoading()` untuk disable UI
- **TextField Disposal**: ViewModel handle dispose() untuk cleanup resources

## ✨ Hasil Refactoring

| Aspek | Sebelum | Sesudah |
|-------|---------|---------|
| State Management | setState | Provider + ChangeNotifier |
| Business Logic | Di StatefulWidget | Di ViewModel |
| Code Reusability | Rendah | Tinggi |
| Testing | Sulit | Mudah |
| Maintainability | Kompleks | Terstruktur |

---

**Status**: ✅ Tahap 3 - Source Code Refactoring (Selesai)
**Pattern**: MVVM dengan Provider
**Last Updated**: 2026-05-15
