# E-Reputation Enhancer Mobile App

A cross-platform Flutter mobile application designed to enhance corporate e-reputation through semantic enrichment and intelligent re-ranking of digital content.

## 📱 Overview

This application helps companies improve their online reputation by enriching and optimizing their digital content (articles, posts, product descriptions, etc.) through semantic and intelligent processing powered by AI and NLP techniques.

📸 Below are real screenshots from the application showcasing the main user interfaces and features.

---

## 📸 App Screenshots

### 🟦 Welcome & Entry Screens
<p align="center">
  <img src="assets/screenshots/welcompage1.png" width="45%" />
  <img src="assets/screenshots/welcompage2.png" width="45%" />
</p>

### 🧭 Dashboard & Features Overview
<p align="center">
  <img src="assets/screenshots/dashboard.png" width="45%" />
  <img src="assets/screenshots/features1.png" width="45%" />
</p>

<p align="center">
  <img src="assets/screenshots/features2.png" width="45%" />
  <img src="assets/screenshots/apiinfo.png" width="45%" />
</p>

### ✍️ Content Enhancement Flow
<p align="center">
  <img src="assets/screenshots/enhacecontent1.png" width="45%" />
  <img src="assets/screenshots/enhencecontent2.png" width="45%" />
</p>

---

## ✨ Features

### 1. **Content Input**
- **Text Input**: Directly type or paste content into the app
- **File Upload**: Upload documents (TXT, DOC, DOCX, PDF)
- **Content Type Selection**: Categorize content as articles, blog posts, product descriptions, press releases, etc.

### 2. **Semantic Enrichment**
- Advanced NLP processing to enhance content meaning and relevance
- Automatic keyword extraction and expansion
- SEO score calculation and analysis
- Comparison view (original vs. enriched content)
- Optimization suggestions

### 3. **Intelligent Re-Ranking**
- Multi-criteria ranking system:
  - **Relevance Score**: Content relevance to target audience
  - **Impact Score**: Potential marketing and business impact
  - **SEO Score**: Search engine optimization effectiveness
  - **Overall Score**: Composite ranking metric
- Dynamic sorting and filtering
- Tag-based categorization
- Detailed analytics and insights

### 4. **User Experience**
- Modern, professional UI with Material 3 design
- Smooth animations and transitions
- Responsive layouts for all screen sizes
- Export functionality for reports
- Copy-to-clipboard features

---

## 🏗️ Architecture
lib/
├── main.dart # App entry point
├── models/
│ └── content_model.dart # Data models
└── screens/
├── home_screen.dart # Dashboard/landing page
├── content_input_screen.dart # Text/file input interface
├── enrichment_results_screen.dart # Semantic enrichment results
└── ranking_screen.dart # Intelligent re-ranking display

### Key Components

- **ContentModel**: Represents the original content with metadata
- **EnrichedContent**: Stores semantically enhanced content with keywords and suggestions
- **RankedContent**: Contains ranking scores and metadata for content items

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.0 or higher)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

bash
git clone <your-repository-url>
cd your_project
flutter pub get
flutter run

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  file_picker: ^8.0.0+1
  google_fonts: ^6.2.1
  flutter_markdown: ^0.7.4+1
  intl: ^0.19.0

### Project Structure

