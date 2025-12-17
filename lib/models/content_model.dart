/// Model representing user's original content input
/// Stores the text, metadata, and optional enrichment data
class ContentModel {
  final String originalText; // User's input text
  final String? enrichedText; // AI-enhanced version (optional)
  final DateTime timestamp; // When content was created
  final ContentType type; // Content category (article, blog, etc.)
  final String? fileName; // Filename if uploaded from file
  final List<String>? keywords; // Extracted keywords (optional)
  final double? relevanceScore; // Relevance rating (optional)

  ContentModel({
    required this.originalText,
    this.enrichedText,
    required this.timestamp,
    required this.type,
    this.fileName,
    this.keywords,
    this.relevanceScore,
  });

  /// Creates a copy of this model with updated fields
  /// Used for immutable updates (keeps original values if new ones not provided)
  ContentModel copyWith({
    String? originalText,
    String? enrichedText,
    DateTime? timestamp,
    ContentType? type,
    String? fileName,
    List<String>? keywords,
    double? relevanceScore,
  }) {
    return ContentModel(
      originalText: originalText ?? this.originalText, // Use new value or keep existing
      enrichedText: enrichedText ?? this.enrichedText,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      keywords: keywords ?? this.keywords,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }
}

/// Enum defining different types of content that can be processed
enum ContentType {
  article, // News articles, editorial content
  post, // Social media posts
  productDescription, // Product listings, descriptions
  pressRelease, // Company announcements
  blogPost, // Blog articles
  other, // Miscellaneous content
}

/// Model representing semantically enriched content
/// Contains the enhanced text, added keywords, suggestions, and SEO score
class EnrichedContent {
  final String originalText; // Original user input
  final String enrichedText; // AI-enhanced version with added context
  final List<String> addedKeywords; // Keywords added during enrichment
  final List<String> suggestions; // Optimization recommendations
  final double seoScore; // SEO score (0-100)
  final DateTime processedAt; // When enrichment was completed

  EnrichedContent({
    required this.originalText,
    required this.enrichedText,
    required this.addedKeywords,
    required this.suggestions,
    required this.seoScore,
    required this.processedAt,
  });
}

/// Model representing a ranked content item
/// Used in the ranking screen to display sorted content with scores
class RankedContent {
  final String content; // Content snippet being ranked
  final double relevanceScore; // How relevant to target audience (0-100)
  final double impactScore; // Business/marketing impact (0-100)
  final double seoScore; // SEO effectiveness (0-100)
  final int rank; // Position in ranking (1, 2, 3, etc.)
  final List<String> tags; // Categorization tags

  RankedContent({
    required this.content,
    required this.relevanceScore,
    required this.impactScore,
    required this.seoScore,
    required this.rank,
    required this.tags,
  });

  /// Calculates overall score as average of all three scores
  double get overallScore => (relevanceScore + impactScore + seoScore) / 3;
}

