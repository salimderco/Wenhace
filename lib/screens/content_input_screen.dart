import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import '../models/content_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import 'api_key_setup_screen.dart';
import 'enrichment_results_screen.dart';
import '../widgets/processing_indicator.dart';
import '../widgets/glass_theme.dart';

/// Screen for inputting content (text or file)
/// Allows users to enter text or upload files for semantic enrichment
class ContentInputScreen extends StatefulWidget {
  const ContentInputScreen({super.key});

  @override
  State<ContentInputScreen> createState() => _ContentInputScreenState();
}

class _ContentInputScreenState extends State<ContentInputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController(); // Text input controller
  final int _maxChars = 5000; // Maximum character limit
  ContentType _selectedType = ContentType.article; // Selected content type
  String? _fileName; // Uploaded file name (if any)
  bool _isProcessing = false; // Whether content is being processed
  late TabController _tabController; // Controller for text/file tabs

  @override
  void initState() {
    super.initState();
    // Initialize tab controller for text/file tabs
    _tabController = TabController(length: 2, vsync: this);
    // Listen to text changes to update character count
    _textController.addListener(() {
      setState(() {}); // Rebuild to update character counter
    });
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _textController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Pastes text from clipboard into text field
  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;
    if (text != null) {
      setState(() {
        _textController.text = text; // Set pasted text
      });
    }
  }

  /// Opens file picker to select document
  /// Supports TXT, DOC, DOCX, and PDF files
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, // Custom file types
        allowedExtensions: ['txt', 'doc', 'docx', 'pdf'], // Allowed formats
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          _fileName = file.name; // Store filename
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File "${file.name}" selected'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Show error if file picker fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Processes the input content and navigates to results screen
  /// Validates input, calls API for enrichment, then navigates
  Future<void> _processContent() async {
    // Validate that user has entered content or selected file
    if (_textController.text.trim().isEmpty && _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter content or upload a file'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true; // Show processing overlay
    });

    try {
      // Create content model with user input
      final content = ContentModel(
        originalText: _textController.text,
        timestamp: DateTime.now(),
        type: _selectedType,
        fileName: _fileName,
      );

      // Call API service for semantic enrichment
      final apiService = ApiService();
      
      // Check if API key is set (if not using mock data)
      if (!AppConstants.useMockData) {
        final apiKey = await apiService.getApiKey();
        if (apiKey == null || apiKey.isEmpty) {
          setState(() {
            _isProcessing = false;
          });
          
          // Prompt user to set API key
          final shouldSetup = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900]?.withOpacity(0.9),
              title: const Text('API Key Required', style: TextStyle(color: Colors.white)),
              content: const Text(
                'Please set up your AI API key to use semantic enrichment features.',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Setup API Key'),
                ),
              ],
            ),
          );
          
          if (shouldSetup == true && mounted) {
            // Navigate to API key setup screen
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApiKeySetupScreen(),
              ),
            );
          }
          return;
        }
      }

      // Call enrichment API (or use mock data if enabled)
      final enrichedContent = await apiService.enrichContent(
        content: _textController.text,
        contentType: _selectedType,
      );

      if (!mounted) return;

      setState(() {
        _isProcessing = false; // Hide processing overlay
      });

      // Navigate to enrichment results screen with enriched content
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnrichmentResultsScreen(
            content: content,
            enrichedContent: enrichedContent, // Pass enriched content directly
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isProcessing = false;
      });

      // Show detailed error message
      String errorMessage = 'Error processing content';
      if (e is ApiException) {
        errorMessage = e.message;
        if (e.statusCode != null) {
          errorMessage += ' (Status: ${e.statusCode})';
        }
      } else {
        errorMessage = e.toString();
      }
      
      // Show error dialog with more details
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[900]?.withOpacity(0.9),
            title: const Text('API Error', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              if (errorMessage.contains('API key') || errorMessage.contains('Network'))
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApiKeySetupScreen(),
                      ),
                    );
                  },
                  child: const Text('Check API Key'),
                ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTextEmpty = _textController.text.trim().isEmpty;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: 'Content Input',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GlassContainer(
                  padding: 4,
                  opacity: 0.12,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.edit),
                        text: 'Text Input',
                      ),
                      Tab(
                        icon: Icon(Icons.upload_file),
                        text: 'File Upload',
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Text Input Tab
                    _buildTextInputTab(),
                    // File Upload Tab
                    _buildFileUploadTab(),
                  ],
                ),
              ),

              // Bottom Action Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: GlassContainer(
                    padding: 16,
                    opacity: 0.16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Content Type Selector
                        Row(
                          children: [
                            const Icon(
                              Icons.category,
                              size: 20,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Content Type:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<ContentType>(
                                value: _selectedType,
                                isExpanded: true,
                                underline: const SizedBox(),
                                dropdownColor: Colors.black.withOpacity(0.6),
                                iconEnabledColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                items: ContentType.values.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(_getContentTypeLabel(type)),
                                  );
                                }).toList(),
                                onChanged: (ContentType? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedType = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Process Button
                        SizedBox(
                          width: double.infinity,
                          child: GlassButton(
                            onPressed: (isTextEmpty && _fileName == null) || _isProcessing
                                ? null
                                : _processContent,
                            text: _isProcessing ? 'Enriching...' : 'Enrich Content',
                            icon: _isProcessing ? null : Icons.auto_awesome,
                            isLoading: _isProcessing,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().slideY(begin: 1.0, end: 0.0, curve: Curves.easeOutQuad, duration: 400.ms),
            ],
          ),

          // Processing Overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: ModernProcessingIndicator(
                  message: 'Analyzing semantics...',
                ),
              ),
            ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildTextInputTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Your Content',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ).animate().fadeIn(delay: 200.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 8),
          Text(
            'Paste or type your corporate content below for semantic analysis',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ).animate().fadeIn(delay: 300.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 20),

          // Text Input Field
          GlassContainer(
            padding: 0,
            opacity: 0.14,
            borderRadius: 16,
            child: Column(
              children: [
                // Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_paste, color: Colors.white70),
                        onPressed: _pasteFromClipboard,
                        tooltip: 'Paste from clipboard',
                        iconSize: 20,
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _textController.clear();
                          });
                        },
                        tooltip: 'Clear',
                        iconSize: 20,
                      ),
                      const Spacer(),
                      Text(
                        '${_textController.text.length} / $_maxChars',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Text Field
                TextField(
                  controller: _textController,
                  maxLines: 15,
                  maxLength: _maxChars,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.white,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Enter your article, blog post, product description, or any corporate content here...\n\nExample:\n"Our company provides innovative solutions for digital transformation. We help businesses optimize their online presence..."',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterText: '',
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).scale(duration: 400.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildFileUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Document',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ).animate().fadeIn(delay: 200.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 8),
          Text(
            'Upload a document file for automatic content extraction',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ).animate().fadeIn(delay: 300.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 30),

          // Upload Area
          InkWell(
            onTap: _pickFile,
            borderRadius: BorderRadius.circular(16),
            child: GlassContainer(
              padding: 0,
              borderRadius: 16,
              opacity: 0.14,
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _fileName != null ? Icons.check_circle : Icons.cloud_upload,
                        size: 64,
                        color: _fileName != null
                            ? Colors.greenAccent
                            : Colors.white,
                      )
                      .animate(onPlay: (c) => _fileName == null ? c.repeat(reverse: true) : null)
                      .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
                      
                      const SizedBox(height: 16),
                      Text(
                        _fileName ?? 'Tap to Upload File',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _fileName != null
                              ? Colors.greenAccent
                              : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Supported: TXT, DOC, DOCX, PDF',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).scale(duration: 400.ms),
          const SizedBox(height: 30),

          // Instructions
          GlassContainer(
            padding: 16,
            opacity: 0.14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'File Upload Tips',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTipItem('Use clean, well-formatted documents'),
                _buildTipItem('Ensure text is readable (not scanned images)'),
                _buildTipItem('File size should be under 10MB'),
                _buildTipItem('Content should be in English'),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, color: Colors.white70)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getContentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.article:
        return 'Article';
      case ContentType.post:
        return 'Social Media Post';
      case ContentType.productDescription:
        return 'Product Description';
      case ContentType.pressRelease:
        return 'Press Release';
      case ContentType.blogPost:
        return 'Blog Post';
      case ContentType.other:
        return 'Other';
    }
  }
}
