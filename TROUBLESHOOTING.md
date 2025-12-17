# Troubleshooting macOS Network Issues

## Current Issue
"Operation not permitted" error when making API calls on macOS.

## Immediate Workaround
I've temporarily enabled mock data so you can test the app UI while we resolve the network issue.

The app will now use simulated data instead of real API calls.

## To Fix Network Access

### Step 1: Check macOS Firewall
1. Open **System Settings** (or System Preferences)
2. Go to **Network** → **Firewall**
3. Make sure firewall allows your app, or temporarily disable it for testing
4. Check **Firewall Options** and ensure your app is listed and allowed

### Step 2: Check for VPN/Security Software
- Temporarily disable any VPN
- Check if antivirus/security software is blocking network access
- Some corporate security software blocks network connections

### Step 3: Grant Network Permission
When you first run the app, macOS may show a permission dialog. Make sure to click "Allow".

### Step 4: Test on Chrome/Web
Chrome doesn't have macOS sandbox restrictions:

```bash
flutter run -d chrome
```

This will let you test the real API integration immediately.

### Step 5: Rebuild Completely
After making entitlement changes:

```bash
flutter clean
flutter pub get
flutter run
```

## Current Status
- ✅ Sandbox disabled for debug builds
- ✅ Network client permission added
- ✅ NSAppTransportSecurity configured
- ⚠️ Still getting "Operation not permitted" - likely system firewall/security software

## Next Steps
1. **Test on Chrome** to verify API integration works
2. **Check macOS Firewall** settings
3. **Temporarily disable security software** to test
4. Once network works, set `useMockData = false` in `lib/utils/constants.dart`

## Alternative: Use Mock Data
The app is currently set to use mock data, so you can:
- Test all UI features
- See how the app works
- Verify the flow

When network permissions are fixed, change `useMockData` to `false` in `constants.dart`.

