import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/content_model.dart';
import 'ranking_screen.dart';
import '../widgets/glass_theme.dart';

class EnrichmentResultsScreen extends StatefulWidget {
  final ContentModel content;
  final EnrichedContent? enrichedContent; // Optional: if provided, use it directly

  const EnrichmentResultsScreen({
    super.key,
    required this.content,
    this.enrichedContent,
  });

  @override
  State<EnrichmentResultsScreen> createState() =>
      _EnrichmentResultsScreenState();
}

class _EnrichmentResultsScreenState extends State<EnrichmentResultsScreen> {
  late EnrichedContent _enrichedContent;
  bool _showComparison = false;

  @override
  void initState() {
    super.initState();
    // Use provided enriched content or generate mock data
    if (widget.enrichedContent != null) {
      _enrichedContent = widget.enrichedContent!;
    } else {
      _generateMockEnrichedContent();
    }
  }

  /// Generate mock enriched content (fallback if not provided from API)
  void _generateMockEnrichedContent() {
    final originalText = widget.content.originalText;
    final enrichedText = _generateMockEnrichedText(originalText);
    
    _enrichedContent = EnrichedContent(
      originalText: originalText,
      enrichedText: enrichedText,
      addedKeywords: [
        'digital transformation',
        'innovation',
        'enterprise solutions',
        'business intelligence',
        'market leadership',
        'customer-centric',
        'sustainable growth',
        'competitive advantage',
      ],
      suggestions: [
        'Add more specific metrics and data points',
        'Include customer testimonials or case studies',
        'Emphasize unique value propositions',
        'Incorporate trending industry keywords',
        'Optimize for voice search queries',
      ],
      seoScore: 87.5,
      processedAt: DateTime.now(),
    );
  }

  /// Generate mock enriched text (fallback)
  String _generateMockEnrichedText(String original) {
    return '''$original

[SEMANTIC ENHANCEMENT]

Our innovative approach leverages cutting-edge technology and industry-leading expertise to deliver transformative results. Through strategic digital transformation initiatives and customer-centric methodologies, we enable sustainable growth and competitive advantage in today's dynamic market landscape.

Key differentiators include:
• Advanced analytics and business intelligence capabilities
• Scalable, enterprise-grade solutions
• Proven track record of measurable ROI
• Industry-specific expertise and domain knowledge
• Commitment to continuous innovation and excellence

This positions us as a trusted partner for organizations seeking to optimize their digital presence and enhance their market position through data-driven strategies and forward-thinking solutions.''';
  }

  void _proceedToRanking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RankingScreen(
          enrichedContent: _enrichedContent,
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: 'Enrichment Results',
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows, color: Colors.white),
            onPressed: () {
              setState(() {
                _showComparison = !_showComparison;
              });
            },
            tooltip: 'Toggle comparison',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Card
            GlassContainer(
              padding: 20,
              borderRadius: 20,
              opacity: 0.2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SEO Score: ${_enrichedContent.seoScore.toStringAsFixed(1)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _enrichedContent.seoScore / 100,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getSeoScoreLabel(_enrichedContent.seoScore),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Added Keywords Section
            GlassContainer(
              padding: 16,
              opacity: 0.14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.label,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Added Keywords',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _enrichedContent.addedKeywords
                        .map((keyword) => Chip(
                              label: Text(keyword),
                              backgroundColor: Colors.white.withOpacity(0.08),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content Display
            _showComparison ? _buildComparisonView() : _buildEnrichedView(),
            const SizedBox(height: 16),

            // Suggestions Section
            GlassContainer(
              padding: 16,
              opacity: 0.14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Optimization Suggestions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._enrichedContent.suggestions.map((suggestion) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _proceedToRanking,
        backgroundColor: Colors.white.withOpacity(0.22),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.arrow_forward),
        label: const Text(
          'Proceed to Ranking',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEnrichedView() {
    return GlassContainer(
      padding: 16,
      opacity: 0.14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.article,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Enriched Content',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white70),
                onPressed: () => _copyToClipboard(_enrichedContent.enrichedText),
                tooltip: 'Copy',
              ),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 8),
          Text(
            _enrichedContent.enrichedText,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonView() {
    return Column(
      children: [
        // Original
        GlassContainer(
          padding: 16,
          opacity: 0.12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.description,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Original Content',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white70),
                    onPressed: () =>
                        _copyToClipboard(_enrichedContent.originalText),
                    tooltip: 'Copy',
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 8),
              Text(
                _enrichedContent.originalText,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Enriched
        GlassContainer(
          padding: 16,
          opacity: 0.16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Enriched Content',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white70),
                    onPressed: () =>
                        _copyToClipboard(_enrichedContent.enrichedText),
                    tooltip: 'Copy',
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 8),
              Text(
                _enrichedContent.enrichedText,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getSeoScoreLabel(double score) {
    if (score >= 90) return 'Excellent - Ready for publication';
    if (score >= 80) return 'Very Good - Minor improvements possible';
    if (score >= 70) return 'Good - Some optimizations recommended';
    if (score >= 60) return 'Fair - Needs improvement';
    return 'Needs significant optimization';
  }
}

