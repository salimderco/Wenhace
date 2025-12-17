# E-Reputation Enhancer Mobile App

A cross-platform Flutter mobile application designed to enhance corporate e-reputation through semantic enrichment and intelligent re-ranking of digital content.

## 📱 Overview

This application helps companies improve their online reputation by enriching and optimizing their digital content (articles, posts, product descriptions, etc.) through semantic and intelligent processing powered by AI and NLP techniques.

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

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/
│   └── content_model.dart              # Data models
└── screens/
    ├── home_screen.dart                # Dashboard/landing page
    ├── content_input_screen.dart       # Text/file input interface
    ├── enrichment_results_screen.dart  # Semantic enrichment results
    └── ranking_screen.dart             # Intelligent re-ranking display
```

### Key Components

- **ContentModel**: Represents the original content with metadata
- **EnrichedContent**: Stores semantically enhanced content with keywords and suggestions
- **RankedContent**: Contains ranking scores and metadata for content items

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository**
   ```bash
   cd /path/to/project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  file_picker: ^8.0.0+1          # File selection
  google_fonts: ^6.2.1           # Custom fonts
  flutter_markdown: ^0.7.4+1     # Markdown rendering
  intl: ^0.19.0                  # Date formatting
```

## 💡 How to Use

### Step 1: Launch the App
Open the app to see the home dashboard with feature overview and statistics.

### Step 2: Input Content
1. Tap "Start Enhancing" to navigate to the content input screen
2. Choose between:
   - **Text Input Tab**: Paste or type your content directly
   - **File Upload Tab**: Upload a document file
3. Select the appropriate content type from the dropdown
4. Tap "Enrich Content" to proceed

### Step 3: View Enrichment Results
- Review the SEO score and performance metrics
- Check added keywords and tags
- Read optimization suggestions
- Toggle comparison mode to see original vs. enriched content
- Copy content to clipboard if needed

### Step 4: Analyze Rankings
1. Tap "Proceed to Ranking"
2. View intelligently ranked content items
3. Sort by different criteria (Overall, Relevance, Impact, SEO)
4. Tap any item for detailed analytics
5. Export the complete report

## 🎨 UI/UX Highlights

- **Color Scheme**: Professional blue theme (#1E88E5) with accent colors
- **Typography**: Inter font family via Google Fonts
- **Components**:
  - Custom cards with elevation and rounded corners
  - Progress indicators for scores
  - Chips and badges for tags
  - Floating action buttons for primary actions
  - Material 3 design patterns

## 🔮 Future Enhancements

### Backend Integration
Currently, the app uses mock data for demonstration. To integrate with a real backend:

1. **API Service Layer**: Create an API service to communicate with your NLP backend
2. **Authentication**: Add user authentication for enterprise users
3. **Real-time Processing**: Implement streaming for long-running enrichment tasks
4. **Cloud Storage**: Store and retrieve historical content analysis

### AI/NLP Integration
Recommended approaches for semantic enrichment:

- **Transformer Models**: BERT, GPT, T5 for text generation and enhancement
- **Query Expansion**: Word embeddings (Word2Vec, GloVe) or contextual embeddings
- **Named Entity Recognition**: Extract and enhance key entities
- **Sentiment Analysis**: Analyze and optimize emotional tone
- **Keyword Extraction**: TF-IDF, RAKE, or transformer-based methods

### Additional Features
- Multi-language support
- Batch processing for multiple documents
- A/B testing for different enriched versions
- Analytics dashboard with charts
- Collaboration features for teams
- Export to different formats (PDF, Word, HTML)

## 📊 Mock Data & Algorithms

The current implementation uses simulated data to demonstrate functionality:

- **Semantic Enrichment**: Adds contextual keywords and industry-relevant terminology
- **Scoring Algorithm**: Composite scores based on multiple factors
- **Ranking**: Sorts content by relevance, impact, and SEO effectiveness

## 🛠️ Technical Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart
- **Architecture**: Feature-based structure
- **State Management**: StatefulWidget (can be extended to Provider, Riverpod, or Bloc)
- **UI Framework**: Material 3

## 📝 Notes for Developers

### Extending the App

1. **Add New Content Types**: Update `ContentType` enum in `content_model.dart`
2. **Custom Scoring**: Modify scoring logic in `ranking_screen.dart`
3. **API Integration**: Create a `services` folder and implement API calls
4. **State Management**: Consider adding Provider or Bloc for complex state
5. **Testing**: Add unit tests for models and widget tests for screens

### Code Quality

- Follows Flutter best practices
- Uses const constructors where possible
- Implements proper disposal of controllers
- Responsive design for different screen sizes

## 📄 License

This project is part of an academic/research initiative for enhancing corporate e-reputation through AI-powered content optimization.

## 👥 Target Users

- Corporate marketing teams
- Content creators and writers
- SEO specialists
- Digital marketing agencies
- Business development professionals

## 🎯 Key Objectives Achieved

✅ Cross-platform mobile application using Flutter/Dart  
✅ Semantic enrichment process for content improvement  
✅ Intelligent re-ranking based on multiple criteria  
✅ Professional UI contributing to digital visibility enhancement  
✅ Flexible architecture for AI/NLP technique integration  

---

**Built with Flutter** 💙
