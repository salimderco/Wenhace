import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/content_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/glass_theme.dart';

class RankingScreen extends StatefulWidget {
  final EnrichedContent enrichedContent;

  const RankingScreen({super.key, required this.enrichedContent});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late List<RankedContent> _rankedItems;
  String _sortCriteria = 'overall';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _performRanking();
  }

  /// Perform intelligent re-ranking using API or mock data
  Future<void> _performRanking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      
      // Call API for ranking (or use mock data if enabled)
      final rankedItems = await apiService.rankContent(
        enrichedContent: widget.enrichedContent.enrichedText,
        criteria: _sortCriteria,
      );

      if (!mounted) return;

      setState(() {
        _rankedItems = rankedItems;
        _sortItems(); // Apply sorting
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      // If API fails, fallback to mock data
      setState(() {
        _rankedItems = _generateMockRankedContent();
        _sortItems();
        _isLoading = false;
      });

      // Show error message (but still display mock data)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Using fallback data: ${e.toString()}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  List<RankedContent> _generateMockRankedContent() {
    // Split the enriched content into segments and rank them
    return [
      RankedContent(
        content: widget.enrichedContent.enrichedText.split('\n\n')[0],
        relevanceScore: 92.5,
        impactScore: 88.0,
        seoScore: 90.0,
        rank: 1,
        tags: ['high-priority', 'trending', 'featured'],
      ),
      RankedContent(
        content:
            'Our innovative approach leverages cutting-edge technology and industry-leading expertise to deliver transformative results.',
        relevanceScore: 89.0,
        impactScore: 91.5,
        seoScore: 87.0,
        rank: 2,
        tags: ['important', 'technical'],
      ),
      RankedContent(
        content:
            'Through strategic digital transformation initiatives and customer-centric methodologies, we enable sustainable growth.',
        relevanceScore: 85.5,
        impactScore: 82.0,
        seoScore: 88.5,
        rank: 3,
        tags: ['strategy', 'growth'],
      ),
      RankedContent(
        content:
            'Advanced analytics and business intelligence capabilities drive data-driven decision making.',
        relevanceScore: 83.0,
        impactScore: 85.5,
        seoScore: 84.0,
        rank: 4,
        tags: ['analytics', 'insights'],
      ),
      RankedContent(
        content:
            'Proven track record of measurable ROI across diverse industry verticals and enterprise clients.',
        relevanceScore: 81.5,
        impactScore: 87.0,
        seoScore: 82.5,
        rank: 5,
        tags: ['results', 'proof'],
      ),
    ];
  }

  void _sortItems() {
    setState(() {
      switch (_sortCriteria) {
        case 'relevance':
          _rankedItems.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
          break;
        case 'impact':
          _rankedItems.sort((a, b) => b.impactScore.compareTo(a.impactScore));
          break;
        case 'seo':
          _rankedItems.sort((a, b) => b.seoScore.compareTo(a.seoScore));
          break;
        case 'overall':
        default:
          _rankedItems.sort((a, b) => b.overallScore.compareTo(a.overallScore));
          break;
      }
      // Update ranks after sorting
      for (int i = 0; i < _rankedItems.length; i++) {
        _rankedItems[i] = RankedContent(
          content: _rankedItems[i].content,
          relevanceScore: _rankedItems[i].relevanceScore,
          impactScore: _rankedItems[i].impactScore,
          seoScore: _rankedItems[i].seoScore,
          rank: i + 1,
          tags: _rankedItems[i].tags,
        );
      }
    });
  }

  void _exportResults() {
    final buffer = StringBuffer();
    buffer.writeln('E-REPUTATION CONTENT RANKING REPORT');
    buffer.writeln('Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');
    buffer.writeln('Sort Criteria: ${_sortCriteria.toUpperCase()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var item in _rankedItems) {
      buffer.writeln('RANK #${item.rank}');
      buffer.writeln('Overall Score: ${item.overallScore.toStringAsFixed(1)}');
      buffer.writeln('Relevance: ${item.relevanceScore.toStringAsFixed(1)} | '
          'Impact: ${item.impactScore.toStringAsFixed(1)} | '
          'SEO: ${item.seoScore.toStringAsFixed(1)}');
      buffer.writeln('Tags: ${item.tags.join(', ')}');
      buffer.writeln('Content: ${item.content}');
      buffer.writeln('-' * 50);
      buffer.writeln();
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: 'Intelligent Re-Ranking',
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _exportResults,
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 24),
                  const Text(
                    'Analyzing and ranking content...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Sort Controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GlassContainer(
                    padding: 16,
                    opacity: 0.14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.sort, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Sort by:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _SortChip(
                                label: 'Overall Score',
                                value: 'overall',
                                isSelected: _sortCriteria == 'overall',
                                onSelected: () {
                                  setState(() {
                                    _sortCriteria = 'overall';
                                    _sortItems();
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              _SortChip(
                                label: 'Relevance',
                                value: 'relevance',
                                isSelected: _sortCriteria == 'relevance',
                                onSelected: () {
                                  setState(() {
                                    _sortCriteria = 'relevance';
                                    _sortItems();
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              _SortChip(
                                label: 'Impact',
                                value: 'impact',
                                isSelected: _sortCriteria == 'impact',
                                onSelected: () {
                                  setState(() {
                                    _sortCriteria = 'impact';
                                    _sortItems();
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              _SortChip(
                                label: 'SEO Score',
                                value: 'seo',
                                isSelected: _sortCriteria == 'seo',
                                onSelected: () {
                                  setState(() {
                                    _sortCriteria = 'seo';
                                    _sortItems();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Stats Summary
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassContainer(
                    padding: 16,
                    opacity: 0.14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.list,
                          label: 'Total Items',
                          value: '${_rankedItems.length}',
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        _StatItem(
                          icon: Icons.star,
                          label: 'Avg Score',
                          value: _calculateAverageScore().toStringAsFixed(1),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        _StatItem(
                          icon: Icons.trending_up,
                          label: 'Top Score',
                          value:
                              _rankedItems.first.overallScore.toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ranked Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _rankedItems.length,
                    itemBuilder: (context, index) {
                      return _RankCard(
                        item: _rankedItems[index],
                        onTap: () => _showDetailDialog(_rankedItems[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: !_isLoading
          ? FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.black.withOpacity(0.75),
                    title: const Text(
                      'Success',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Content has been successfully processed and ranked! '
                      'You can now use these insights to optimize your digital presence.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: const Text('Return Home'),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.white.withOpacity(0.22),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.check_circle),
              label: const Text('Complete'),
            )
          : null,
    );
  }

  double _calculateAverageScore() {
    if (_rankedItems.isEmpty) return 0;
    final sum =
        _rankedItems.fold<double>(0, (sum, item) => sum + item.overallScore);
    return sum / _rankedItems.length;
  }

  void _showDetailDialog(RankedContent item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getRankColor(item.rank),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#${item.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Content Details (#${item.rank})',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ScoreRow(
                label: 'Overall Score',
                score: item.overallScore,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              _ScoreRow(
                label: 'Relevance',
                score: item.relevanceScore,
                color: Colors.purple,
              ),
              const SizedBox(height: 8),
              _ScoreRow(
                label: 'Impact',
                score: item.impactScore,
                color: Colors.orange,
              ),
              const SizedBox(height: 8),
              _ScoreRow(
                label: 'SEO Score',
                score: item.seoScore,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tags:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: item.tags
                    .map((tag) => Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.12),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Content:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.content,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: item.content));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Content copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey[400]!;
    if (rank == 3) return Colors.brown[300]!;
    return const Color(0xFF1E88E5);
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onSelected;

  const _SortChip({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.white.withOpacity(0.08),
      selectedColor: Colors.white.withOpacity(0.24),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: Colors.white,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final RankedContent item;
  final VoidCallback onTap;

  const _RankCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          padding: 16,
          opacity: 0.14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Rank Badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getRankColor(item.rank),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '#${item.rank}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Overall Score
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Overall Score: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              item.overallScore.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: item.overallScore / 100,
                          backgroundColor: Colors.white.withOpacity(0.12),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white70),
                ],
              ),
              const SizedBox(height: 12),

              // Content Preview
              Text(
                item.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: item.tags
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),

              // Individual Scores
              Row(
                children: [
                  _MiniScore(
                    label: 'REL',
                    score: item.relevanceScore,
                    color: Colors.purpleAccent,
                  ),
                  const SizedBox(width: 12),
                  _MiniScore(
                    label: 'IMP',
                    score: item.impactScore,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 12),
                  _MiniScore(
                    label: 'SEO',
                    score: item.seoScore,
                    color: Colors.lightGreenAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey[400]!;
    if (rank == 3) return Colors.brown[300]!;
    return const Color(0xFF1E88E5);
  }
}

class _MiniScore extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _MiniScore({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ${score.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _ScoreRow({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.white.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

