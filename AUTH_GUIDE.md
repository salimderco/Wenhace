# Authentication Guide

## 🔐 Overview

The app now includes a complete authentication system with login and signup functionality. The design follows modern mobile app patterns with a clean, professional interface.

---

## 🎨 Features

### ✅ Login Screen
- Email and password authentication
- Password visibility toggle
- Form validation
- Test credentials display
- Forgot password option (shows test credentials)
- Loading states
- Error handling
- Link to signup screen

### ✅ Signup Screen
- Full name, email, and password fields
- Password confirmation
- Real-time validation
- Auto-login after successful signup
- Loading states
- Link back to login
- Mobile-first design

### ✅ Authentication Service
- Simple in-memory user storage
- Persistent authentication state (using SharedPreferences)
- Email validation
- Password requirements (minimum 6 characters)
- Duplicate email detection
- Logout functionality

### ✅ User Session
- Persists across app restarts
- Shows welcome message with user name
- Logout button in app bar
- Confirmation dialog on logout

---

## 🧪 Test Credentials

### Default Account
```
Email: test@example.com
Password: password123
```

This account is pre-configured and ready to use immediately.

### Create New Account
You can also create new accounts through the signup screen. Any email/password combination works (stored in memory only).

---

## 📱 User Flow

### First Time User
```
1. App Opens → Login Screen
2. Tap "Create New Account" → Signup Screen
3. Enter name, email, password
4. Tap "Create Account" → Auto-logged in → Home Screen
5. App remembers you on next launch
```

### Returning User
```
1. App Opens → Automatically logged in → Home Screen
2. Use app features
3. Tap logout icon → Confirmation → Login Screen
```

### Login Flow
```
1. Enter email and password
2. Tap "Sign In"
3. Success → Home Screen
4. Error → Red message shown
```

---

## 🎨 Design Features

### Mobile-First Design
- Large touch targets (56px buttons)
- Rounded corners (16px radius)
- Proper spacing and padding
- Clean, uncluttered interface
- Professional color scheme

### Visual Elements
- **Logo Circle**: Blue icon in circular background
- **Input Fields**: Rounded with icons
- **Password Toggle**: Eye icon for show/hide
- **Loading State**: Spinner in button
- **Error Messages**: Red text below fields
- **Test Credentials Card**: Blue info box

### Colors
- **Primary Blue**: #1E88E5
- **Light Gray**: #F5F5F5 (field backgrounds)
- **Border Gray**: #E0E0E0
- **Error Red**: Built-in Material red
- **Success Green**: Built-in Material green

---

## 🔧 Technical Details

### Files Created

1. **`lib/services/auth_service.dart`**
   - Authentication logic
   - User management
   - Session persistence
   - Validation functions

2. **`lib/screens/login_screen.dart`**
   - Login UI
   - Form validation
   - Navigation to signup
   - Test credentials display

3. **`lib/screens/signup_screen.dart`**
   - Signup UI
   - Password confirmation
   - Navigation back to login
   - Auto-login on success

### Updated Files

1. **`lib/main.dart`**
   - Initialize auth service
   - Check auth state on startup
   - Route to login or home

2. **`lib/screens/home_screen.dart`**
   - Added app bar with user greeting
   - Added logout button
   - Logout confirmation dialog

3. **`pubspec.yaml`**
   - Added `shared_preferences: ^2.2.2`

---

## 💾 Data Storage

### What's Stored
- Authentication status (boolean)
- User email
- User name

### Where It's Stored
- **SharedPreferences**: Device-local key-value storage
- Persists across app launches
- Cleared on logout

### What's NOT Stored
- Passwords (stored in memory only for demo)
- Session tokens (not needed for demo)
- User profiles (basic info only)

---

## 🔒 Security Notes

### Current Implementation (Demo/Test)
⚠️ **This is a demo authentication system:**
- Users stored in memory
- No backend API
- No real encryption
- Data lost on app restart (except logged-in state)
- Test credentials hardcoded

### For Production
When moving to production, you should:
1. ✅ Connect to real backend API
2. ✅ Use proper authentication (OAuth, JWT)
3. ✅ Encrypt sensitive data
4. ✅ Implement secure storage (Keychain/Keystore)
5. ✅ Add password recovery
6. ✅ Implement rate limiting
7. ✅ Add two-factor authentication
8. ✅ Use HTTPS for all API calls
9. ✅ Never store passwords in plaintext
10. ✅ Implement proper session management

---

## 🎯 Validation Rules

### Email
- ✅ Required field
- ✅ Must be valid email format
- ✅ Auto-converted to lowercase
- ✅ Must be unique (for signup)

### Password
- ✅ Required field
- ✅ Minimum 6 characters
- ✅ Must match confirmation (signup)

### Name
- ✅ Required field
- ✅ Trimmed of whitespace
- ✅ Title case formatting

---

## 🎨 UI Components

### Login Screen Elements
```
┌─────────────────────────┐
│      (Blue Circle)      │  ← Icon
│                         │
│    Welcome Back         │  ← Title
│    Sign in to continue  │  ← Subtitle
│                         │
│  ┌───────────────────┐  │
│  │ 📧 Email         │  │  ← Email field
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ 🔒 Password   👁  │  │  ← Password field
│  └───────────────────┘  │
│                         │
│  Forgot Password?   →   │  ← Shows test creds
│                         │
│  ┌───────────────────┐  │
│  │    Sign In        │  │  ← Login button
│  └───────────────────┘  │
│                         │
│         OR              │  ← Divider
│                         │
│  Create New Account     │  ← Signup link
│                         │
│  ℹ️ Test Credentials    │  ← Info card
│  test@example.com       │
│  password123            │
└─────────────────────────┘
```

### Signup Screen Elements
```
┌─────────────────────────┐
│  ←  (Back Button)       │  ← Navigation
│                         │
│      (Blue Circle)      │  ← Icon
│                         │
│   Create Account        │  ← Title
│   Sign up to get started│  ← Subtitle
│                         │
│  ┌───────────────────┐  │
│  │ 👤 Full Name     │  │  ← Name field
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ 📧 Email         │  │  ← Email field
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ 🔒 Password   👁  │  │  ← Password
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ 🔒 Confirm     👁  │  │  ← Confirm
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │  Create Account   │  │  ← Signup button
│  └───────────────────┘  │
│                         │
│  Already have account?  │  ← Login link
│        Sign In          │
└─────────────────────────┘
```

---

## 🚀 Quick Start

### Test the Login
1. Run the app: `flutter run`
2. You'll see the login screen
3. Enter test credentials:
   - Email: `test@example.com`
   - Password: `password123`
4. Tap "Sign In"
5. You're now on the home screen!

### Test the Signup
1. From login screen, tap "Create New Account"
2. Enter any name, email, and password (6+ chars)
3. Confirm password
4. Tap "Create Account"
5. Automatically logged in!

### Test Logout
1. On home screen, see your name in app bar
2. Tap logout icon (top right)
3. Confirm logout
4. Redirected to login screen

### Test Persistence
1. Login to the app
2. Close the app completely
3. Reopen the app
4. You're automatically logged in!

---

## 🎯 Error Messages

### Login Errors
- "Please enter email and password" - Empty fields
- "No account found with this email" - Email not registered
- "Incorrect password" - Wrong password

### Signup Errors
- "Please fill in all fields" - Missing required field
- "Please enter a valid email address" - Invalid email format
- "Password must be at least 6 characters" - Short password
- "An account with this email already exists" - Duplicate email
- "Passwords do not match" - Confirmation mismatch

### Field Validation
- Email: Real-time format validation
- Password: Length check on submit
- Name: Required field check

---

## 💡 Tips & Best Practices

### For Users
1. Use the test account to quickly explore features
2. Create a personal account to test signup flow
3. Test password visibility toggle
4. Try validation errors to see error handling
5. Close and reopen app to test persistence

### For Developers
1. Customize test credentials in `auth_service.dart`
2. Add more validation rules as needed
3. Integrate with real backend API
4. Add password strength meter
5. Implement forgot password flow
6. Add social login options
7. Customize colors in screens

---

## 🔗 Related Files

- **Main Entry**: `lib/main.dart`
- **Auth Service**: `lib/services/auth_service.dart`
- **Login Screen**: `lib/screens/login_screen.dart`
- **Signup Screen**: `lib/screens/signup_screen.dart`
- **Home Screen**: `lib/screens/home_screen.dart`

---

## 📊 Feature Checklist

- ✅ Login screen with mobile-first design
- ✅ Signup screen with validation
- ✅ Password visibility toggle
- ✅ Form validation
- ✅ Loading states
- ✅ Error messages
- ✅ Session persistence
- ✅ Logout functionality
- ✅ User greeting
- ✅ Test credentials
- ✅ Navigation flow
- ✅ Confirmation dialogs

---

**🎉 Your app now has a complete authentication system with beautiful mobile-first design!**

