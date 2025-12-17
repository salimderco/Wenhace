# App Screenshots & Visual Guide

## Screen Flow Diagram

```
┌─────────────────────┐
│   Home Dashboard    │
│   (Landing Page)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Content Input      │
│  - Text Input Tab   │
│  - File Upload Tab  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Enrichment Results  │
│  - SEO Score        │
│  - Keywords         │
│  - Suggestions      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Ranking Display    │
│  - Sorted Items     │
│  - Detailed Scores  │
│  - Export Option    │
└─────────────────────┘
```

---

## Detailed Screen Descriptions

### 1. Home Dashboard 🏠

**Visual Layout:**
```
┌───────────────────────────────┐
│ ← [Back]    E-Reputation      │  ← App Bar
├───────────────────────────────┤
│                               │
│  E-Reputation Enhancer        │  ← Title (Bold, Large)
│  Enhance your corporate...    │  ← Subtitle (Gray)
│                               │
│  ┌─────────────────────────┐ │
│  │  ✨                     │ │
│  │  Transform Your Content  │ │  ← Hero Card (Blue)
│  │  Use advanced NLP...     │ │
│  │  [Start Enhancing] →    │ │  ← CTA Button
│  └─────────────────────────┘ │
│                               │
│  Key Features                 │  ← Section Header
│                               │
│  ┌─────────────────────────┐ │
│  │ 📝 Semantic Enrichment  │ │  ← Feature Cards
│  │ Enhance content...       │ │
│  └─────────────────────────┘ │
│  ┌─────────────────────────┐ │
│  │ 🔍 Query Expansion      │ │
│  └─────────────────────────┘ │
│  ┌─────────────────────────┐ │
│  │ 📊 Intelligent Ranking  │ │
│  └─────────────────────────┘ │
│                               │
│  ┌───┐ ┌───┐ ┌───┐          │
│  │98%│ │10x│ │24/7│          │  ← Stats
│  └───┘ └───┘ └───┘          │
└───────────────────────────────┘
```

**Color Scheme:**
- Background: White
- Primary Card: Blue gradient (#1E88E5 → #1565C0)
- Feature Cards: White with colored icons
- Text: Black primary, Gray secondary

---

### 2. Content Input Screen 📝

**Tab Bar Layout:**
```
┌───────────────────────────────┐
│ ← Content Input               │
├───────────────────────────────┤
│  [Text Input]  [File Upload]  │  ← Tabs
├───────────────────────────────┤
│                               │
│  Enter Your Content           │
│  Paste or type your...        │
│                               │
│  ┌─────────────────────────┐ │
│  │ [📋] [✕]    0/5000      │ │  ← Toolbar
│  ├─────────────────────────┤ │
│  │                         │ │
│  │  [Text input area...]   │ │  ← Large text field
│  │                         │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ 📁 Content Type:        │ │
│  │    [Article ▼]          │ │  ← Type selector
│  └─────────────────────────┘ │
│  ┌─────────────────────────┐ │
│  │  ✨ Enrich Content  →   │ │  ← Action button
│  └─────────────────────────┘ │
└───────────────────────────────┘
```

**File Upload Tab:**
```
┌───────────────────────────────┐
│  Upload Document              │
│  Upload a document file...    │
│                               │
│  ┌─────────────────────────┐ │
│  │                         │ │
│  │      ☁️                │ │
│  │  Tap to Upload File     │ │  ← Upload area (dashed border)
│  │  Supported: TXT, DOC... │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ ℹ️  File Upload Tips    │ │
│  │  • Use clean documents  │ │  ← Tips card
│  │  • Readable text        │ │
│  │  • Under 10MB          │ │
│  └─────────────────────────┘ │
└───────────────────────────────┘
```

**Interactive Elements:**
- Paste button: Copies from system clipboard
- Clear button: Erases all text
- Tab switching: Smooth animation
- Character counter: Updates in real-time
- Button state: Disabled when empty, blue when ready

---

### 3. Enrichment Results Screen ✨

**Layout:**
```
┌───────────────────────────────┐
│ ← Enrichment Results    [⇄]  │  ← Compare toggle
├───────────────────────────────┤
│  ┌─────────────────────────┐ │
│  │  ✨ SEO Score: 87.5     │ │
│  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░    │ │  ← Score card (gradient)
│  │  Very Good - Minor...    │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ 🏷️  Added Keywords      │ │
│  │  [digital][innovation]   │ │  ← Keyword chips
│  │  [enterprise][growth]    │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ 📄 Enriched Content [📋]│ │
│  │ ────────────────────────│ │
│  │  [Enhanced text here     │ │  ← Content display
│  │   with improvements...]  │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ 💡 Optimization Tips     │ │
│  │  ✓ Add more metrics     │ │  ← Suggestions
│  │  ✓ Include testimonials │ │
│  └─────────────────────────┘ │
│                               │
│                         [➜]   │  ← Floating button
└───────────────────────────────┘
```

**Comparison Mode:**
When toggle is active, shows split view:
```
┌─────────────────────────┐
│ 📄 Original Content     │
│ (grayed background)     │
└─────────────────────────┘
┌─────────────────────────┐
│ ✨ Enriched Content     │
│ (blue tinted background)│
└─────────────────────────┘
```

---

### 4. Ranking Screen 📊

**Full Layout:**
```
┌───────────────────────────────┐
│ ← Intelligent Re-Ranking  [⬇] │  ← Export button
├───────────────────────────────┤
│  🔽 Sort by:                  │
│  [[Overall]] [Relevance]...   │  ← Filter chips
├───────────────────────────────┤
│  ┌─────────────────────────┐ │
│  │ 📊 5  ⭐ 87.5  📈 92.5  │ │  ← Stats bar
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ [#1] Overall: 90.2      │ │
│  │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░    │ │  ← Rank card #1 (gold)
│  │ Our company provides... │ │
│  │ [featured][trending]    │ │
│  │ REL:92 IMP:88 SEO:90   │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ [#2] Overall: 89.2      │ │  ← Rank card #2 (silver)
│  │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░    │ │
│  │ Through strategic...    │ │
│  └─────────────────────────┘ │
│                               │
│  ┌─────────────────────────┐ │
│  │ [#3] Overall: 85.3      │ │  ← Rank card #3 (bronze)
│  └─────────────────────────┘ │
│                               │
│                         [✓]   │  ← Complete button
└───────────────────────────────┘
```

**Detail Modal (on tap):**
```
┌───────────────────────────────┐
│  [#1] Content Details         │
├───────────────────────────────┤
│  Overall Score   ▓▓▓▓ 90.2   │
│  Relevance       ▓▓▓▓ 92.5   │
│  Impact          ▓▓▓▓ 88.0   │
│  SEO Score       ▓▓▓▓ 90.0   │
│                               │
│  Tags:                        │
│  [featured] [trending]        │
│                               │
│  Content:                     │
│  ┌─────────────────────────┐ │
│  │ [Full text displayed]   │ │
│  └─────────────────────────┘ │
│                               │
│         [Copy]  [Close]       │
└───────────────────────────────┘
```

---

## Color Legend

### Primary Colors
- **Blue (#1E88E5)**: Primary actions, overall scores
- **Dark Blue (#1565C0)**: Secondary elements
- **Light Blue (#64B5F6)**: Accents

### Semantic Colors
- **Purple**: Keywords, relevance metrics
- **Orange**: Suggestions, impact scores
- **Green**: SEO metrics, success states
- **Red**: Errors, warnings
- **Gray**: Secondary text, disabled states

### Special Elements
- **Gold (#FFB300)**: Rank #1
- **Silver (#BDBDBD)**: Rank #2
- **Bronze (#A1887F)**: Rank #3

---

## Iconography

### Main Icons Used
- 🏠 Home: `Icons.home`
- ✨ Enhancement: `Icons.auto_awesome`
- 📝 Edit: `Icons.edit_note`
- 📁 Category: `Icons.category`
- 📋 Paste: `Icons.content_paste`
- ☁️ Upload: `Icons.cloud_upload`
- 🔍 Query: `Icons.query_stats`
- 📊 Ranking: `Icons.sort`
- 🏷️ Keywords: `Icons.label`
- 💡 Suggestions: `Icons.lightbulb_outline`
- ✓ Success: `Icons.check_circle`
- ⭐ Featured: `Icons.star`
- 📈 Trending: `Icons.trending_up`

---

## Typography

### Font Family
- **Primary**: Inter (via Google Fonts)
- **Fallback**: System default

### Text Styles
```
Headline Large:  28-32px, Bold
Headline Medium: 24-28px, Bold
Headline Small:  20-24px, SemiBold

Title Large:     18-20px, SemiBold
Title Medium:    16-18px, SemiBold
Title Small:     14-16px, Medium

Body Large:      16px, Regular
Body Medium:     14-15px, Regular
Body Small:      12-14px, Regular

Caption:         11-12px, Regular
Label:           11-12px, Medium
```

---

## Animations & Transitions

### Page Transitions
- Standard Material slide transition
- Duration: 300ms
- Curve: easeInOut

### Loading States
- Circular progress indicator (blue)
- Button loading: spinner replaces icon
- Shimmer effect: Not implemented (future)

### Interactive Elements
- Button press: Slight scale down
- Card tap: Ripple effect
- FAB: Elevation change on press

---

## Responsive Breakpoints

### Phone (Portrait)
- Width: 360-428px
- Single column layout
- Larger touch targets

### Phone (Landscape)
- Compact headers
- Horizontal scrolling for chips

### Tablet
- Width: 600px+
- Wider cards with more padding
- Side-by-side layouts for comparison

### Desktop (Web)
- Max width: 1200px
- Centered content
- Multi-column grids

---

## Accessibility Features

### Color Contrast
- All text meets WCAG AA standards
- Important buttons have 4.5:1 contrast ratio

### Touch Targets
- Minimum 44x44pt for all interactive elements
- Adequate spacing between buttons

### Screen Reader Support
- Semantic labels on all icons
- Descriptive tooltips
- Proper heading hierarchy

### Font Scaling
- Respects system font size settings
- Readable at 200% zoom

---

## Dark Mode (Future Enhancement)

Not currently implemented, but ready for:
```dart
ThemeData.dark(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF64B5F6),
    // ... other colors
  ),
)
```

---

## Export Examples

### Text Report Format
```
E-REPUTATION CONTENT RANKING REPORT
Generated: 2024-01-15 14:30
Sort Criteria: OVERALL
==================================================

RANK #1
Overall Score: 90.2
Relevance: 92.5 | Impact: 88.0 | SEO: 90.0
Tags: featured, trending, high-priority
Content: Our company provides innovative...
--------------------------------------------------
```

---

## Performance Metrics

- **App Size**: ~15-20 MB (with assets)
- **Launch Time**: < 2 seconds
- **Screen Transitions**: 300ms
- **Mock Processing**: 1.5 seconds
- **Smooth Scrolling**: 60 FPS

---

**📸 To capture actual screenshots, run the app and use:**
- iOS: Cmd + S in simulator
- Android: Power + Volume Down
- Flutter: `flutter screenshot` command

