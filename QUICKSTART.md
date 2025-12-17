# Quick Start Guide

## Getting Your App Running in 5 Minutes ⚡

### Step 1: Install Dependencies

Open your terminal in the project directory and run:

```bash
flutter pub get
```

This will download all required packages including:
- `file_picker` for file uploads
- `google_fonts` for beautiful typography
- `intl` for date formatting
- `flutter_markdown` for potential markdown support

### Step 2: Check Your Flutter Setup

Verify your Flutter installation:

```bash
flutter doctor
```

Make sure you have:
- ✅ Flutter SDK installed
- ✅ At least one platform configured (iOS/Android)
- ✅ Connected device or emulator

### Step 3: Run the App

#### For iOS (Mac only):
```bash
flutter run -d ios
```

#### For Android:
```bash
flutter run -d android
```

#### For Chrome (Web):
```bash
flutter run -d chrome
```

### Step 4: Test the App Flow

Once the app launches, follow this flow:

1. **Home Screen**: You'll see the dashboard with feature overview
2. **Tap "Start Enhancing"**: Navigate to content input
3. **Enter Sample Text**: Try this example:
   ```
   Our company provides innovative digital solutions for modern businesses. 
   We help organizations transform their online presence and achieve growth.
   ```
4. **Select Content Type**: Choose "Article" from dropdown
5. **Tap "Enrich Content"**: Processing animation will show
6. **View Results**: Check the SEO score and enriched content
7. **Compare**: Toggle the comparison button to see before/after
8. **Proceed to Ranking**: View intelligent content ranking
9. **Sort & Filter**: Try different sorting criteria
10. **View Details**: Tap any ranked item for full analytics

---

## 🎨 Visual Preview

### Home Screen
- Clean dashboard with blue theme
- Feature cards with icons
- Statistics display
- Large "Start Enhancing" button

### Content Input Screen
- Two tabs: Text Input and File Upload
- Character counter
- Content type selector
- Paste and clear buttons

### Enrichment Results
- Prominent SEO score with progress bar
- Keyword chips
- Comparison toggle
- Optimization suggestions

### Ranking Screen
- Sort chips for different criteria
- Statistics summary box
- Ranked content cards with badges
- Detail modal on tap

---

## 🧪 Sample Content to Test

### Short Article
```
Digital transformation is reshaping how businesses operate. Companies must 
adapt to new technologies and changing consumer expectations to remain 
competitive in today's market.
```

### Product Description
```
Premium wireless headphones with active noise cancellation, 30-hour battery 
life, and superior sound quality. Perfect for professionals and music lovers 
who demand the best audio experience.
```

### Blog Post
```
Five strategies for improving your company's online reputation: consistent 
branding, responsive customer service, quality content creation, social 
media engagement, and proactive review management.
```

---

## 📱 Platform-Specific Notes

### iOS
- Minimum deployment target: iOS 12.0
- Runs on iPhone and iPad
- Supports both portrait and landscape orientations

### Android
- Minimum SDK: 21 (Android 5.0)
- Material Design 3 components
- Adaptive layouts for tablets

### Web
- Responsive design
- Desktop and mobile layouts
- Modern browser support required

---

## 🐛 Troubleshooting

### "Failed to resolve dependencies"
```bash
flutter pub cache repair
flutter pub get
```

### "No devices available"
- Start an emulator/simulator
- Or connect a physical device with USB debugging enabled

### "Gradle build failed" (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Font loading issues
- Ensure you have internet connection on first run
- Google Fonts will cache automatically

---

## 🔧 Development Tips

### Hot Reload
Press `r` in terminal while app is running to see changes instantly

### Hot Restart
Press `R` for a full restart with state reset

### Open DevTools
Press `v` to open Flutter DevTools in browser

### View Logs
Use `flutter logs` in a separate terminal for detailed logging

---

## 📂 Key Files to Know

```
lib/
├── main.dart                    # App entry point - start here
├── models/
│   └── content_model.dart       # Data structures
├── screens/
│   ├── home_screen.dart         # Landing page
│   ├── content_input_screen.dart # Input interface
│   ├── enrichment_results_screen.dart # Results display
│   └── ranking_screen.dart      # Ranking interface
└── utils/
    └── constants.dart           # App constants
```

---

## 🚀 Next Steps

### For Learning:
1. Explore each screen's code
2. Modify colors in `constants.dart`
3. Add new content types in `content_model.dart`
4. Customize scoring algorithms in `ranking_screen.dart`

### For Development:
1. Set up your backend API
2. Replace mock data with real API calls
3. Implement authentication
4. Add analytics tracking
5. Integrate actual NLP/AI models

### For Production:
1. Update `pubspec.yaml` with your app name
2. Add app icons and splash screens
3. Configure API endpoints
4. Set up CI/CD pipeline
5. Prepare app store listings

---

## 💡 Pro Tips

1. **Keep Mock Mode**: The app works fully without a backend, making it great for demos
2. **Use Constants**: All colors and spacing are in `constants.dart` for easy theming
3. **Check TODO Comments**: Look for `// TODO:` markers for integration points
4. **Test All Paths**: Try both text input and file upload tabs
5. **Explore Sorting**: Each sorting criteria shows different rankings

---

## 🎯 Expected Behavior

### Loading States
- Content input → 1.5s processing animation
- Ranking analysis → 1.5s loading screen

### Mock Scores
- SEO Score: ~87.5 (randomized slightly)
- Relevance: 80-95 range
- Impact: 80-92 range
- SEO Individual: 82-90 range

### Navigation Flow
```
Home → Input → Enrichment → Ranking → Complete
         ↑                              ↓
         └──────────────────────────────┘
         (Back navigation works at each step)
```

---

## 📞 Need Help?

- Check `README.md` for detailed documentation
- Review `FEATURES.md` for feature specifications
- Look at inline code comments
- Flutter docs: https://flutter.dev/docs

---

**🎉 You're all set! Enjoy building your e-reputation enhancement app!**

