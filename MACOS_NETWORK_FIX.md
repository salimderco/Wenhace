# macOS Network Permission Fix

## The Problem
"Operation not permitted" error when making API calls on macOS.

## Solutions

### Option 1: Test on Chrome/Web (Recommended for Now)
Chrome/web doesn't have macOS sandbox restrictions:

```bash
flutter run -d chrome
```

This will let you test the API integration immediately without macOS permission issues.

### Option 2: Check macOS Firewall
1. Open **System Settings** → **Network** → **Firewall**
2. Make sure your app is allowed, or temporarily disable firewall for testing
3. Check if any network extensions are blocking connections

### Option 3: Grant Network Permission Manually
1. When you run the app, macOS may prompt for network permission
2. Click "Allow" if prompted
3. Check **System Settings** → **Privacy & Security** → **Firewall** → **Options**

### Option 4: Run Without Sandbox (Already Done)
The sandbox has been disabled in `DebugProfile.entitlements` for debug builds.

### Option 5: Check System Network Extensions
Some macOS security software or VPNs can block network access:
- Check if you have any VPN or security software running
- Temporarily disable them to test

## Quick Test
Run on Chrome to verify API works:
```bash
flutter run -d chrome
```

If it works on Chrome but not macOS, it's a macOS-specific permission issue.

## For Production
For release builds, you'll need to:
1. Re-enable sandbox in `Release.entitlements`
2. Add proper network permissions
3. Sign the app with a developer certificate

