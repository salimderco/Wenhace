# 🎨 Background Image Setup

## Adding Your Custom Background

To use the flowing wave gradient image (the second image you provided) as your app background:

### Step 1: Save the Image
Save your background image as:
```
assets/images/background.png
```

### Step 2: Use in Your Screens
To use the custom background image in any screen, update the `GlassScaffold` widget:

```dart
GlassScaffold(
  backgroundImage: 'assets/images/background.png',
  useOrbsBackground: false, // Set to false to use only the image without orbs
  body: YourContent(),
)
```

### Options:

#### Option A: Image with Orbs (Recommended)
Combines your image with floating gradient orbs for extra depth:
```dart
GlassScaffold(
  backgroundImage: 'assets/images/background.png',
  useOrbsBackground: true, // Adds floating orbs on top of image
  body: YourContent(),
)
```

#### Option B: Image Only
Uses only your background image with blur effects:
```dart
GlassScaffold(
  backgroundImage: 'assets/images/background.png',
  useOrbsBackground: false,
  body: YourContent(),
)
```

#### Option C: Orbs Only (Current Default)
Uses programmatic gradient orbs (no image needed):
```dart
GlassScaffold(
  useOrbsBackground: true, // Default, no need to specify
  body: YourContent(),
)
```

## Current Status
The app is currently using **Option C** (gradient orbs only), which creates a beautiful glassmorphism effect without requiring an external image file.

To switch to your custom image, simply save it to `assets/images/background.png` and the app will automatically use it!

## Note
The blur effects (sigma: 100 + 50) are automatically applied to any background for the perfect glassmorphism look.

