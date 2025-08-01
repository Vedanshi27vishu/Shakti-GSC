import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _detectedLanguage = '';

  // Replace with your API key
  static const String _apiKey =
      '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';

  // API URLs
  static const String _groqUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _openAiUrl = 'https://api.openai.com/v1/chat/completions';

  // Current configuration (Change these to switch providers)
  static const String _currentUrl = _groqUrl; // Changed to Groq
  static const String _currentModel = 'llama3-70b-8192';
  // Groq model

  @override
  void initState() {
    super.initState();
    // _addMessage(
    //   '🚀 Welcome! I can communicate in any language. Just start chatting!\n\n✅ Groq AI is ready to chat with you!',
    //   false,
    //   isSystem: true,
    // );
  }

  void _addMessage(String text, bool isUser, {bool isSystem = false}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        isSystem: isSystem,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    _controller.clear();
    _addMessage(userMessage, true);

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _callAI(userMessage);
      _addMessage(response, false);
    } catch (e) {
      String errorMessage = 'Sorry, I encountered an error. Please try again.';

      // Better error handling with more details
      String errorString = e.toString().toLowerCase();

      if (errorString.contains('429')) {
        errorMessage = '⏰ Rate limit reached. Wait 1 minute and try again.';
      } else if (errorString.contains('401') ||
          errorString.contains('unauthorized')) {
        errorMessage = '🔑 API key issue. Please check your Groq key.';
      } else if (errorString.contains('500') ||
          errorString.contains('server')) {
        errorMessage = '🔧 Server error. Try again in a moment.';
      } else if (errorString.contains('network') ||
          errorString.contains('connection')) {
        errorMessage = '📡 Network error. Check your internet connection.';
      } else {
        // Show detailed error for debugging
        errorMessage = 'Error details: ${e.toString()}';
      }

      _addMessage(errorMessage, false);
      debugPrint('Full error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _callAI(String message) async {
    if (_apiKey == 'YOUR_API_KEY_HERE' || _apiKey.isEmpty) {
      return '''🔧 Setup Required:

1. Get your Groq API key from: console.groq.com
2. Replace 'YOUR_API_KEY_HERE' with your Groq key
3. Run the app again

Your Groq key should start with 'gsk_...'

That's it! 🚀''';
    }

    try {
      _updateDetectedLanguage(message);

      final systemPrompt =
          '''You are a helpful AI assistant. ALWAYS respond in the same language the user is using. If they write in Spanish, respond in Spanish. If they write in Hindi, respond in Hindi. Be natural and conversational.''';

      final requestBody = {
        'model': _currentModel,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      };

      debugPrint('Making request to: $_currentUrl');
      debugPrint('Using model: $_currentModel');
      debugPrint('API key starts with: ${_apiKey.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse(_currentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode(requestBody),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'];
        } else {
          throw Exception('No response content in API response');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            'API Error ${response.statusCode}: ${errorData.toString()}');
      }
    } catch (e) {
      debugPrint('AI call error: $e');
      rethrow;
    }
  }

  void _updateDetectedLanguage(String text) {
    final lower = text.toLowerCase();

    if (RegExp(r'नमस्ते|धन्यवाद|कैसे|हैं').hasMatch(text)) {
      _detectedLanguage = '🇮🇳 Hindi';
    } else if (RegExp(r'你好|谢谢|怎么').hasMatch(text)) {
      _detectedLanguage = '🇨🇳 Chinese';
    } else if (RegExp(r'hola|gracias|cómo').hasMatch(lower)) {
      _detectedLanguage = '🇪🇸 Spanish';
    } else if (RegExp(r'bonjour|merci|comment').hasMatch(lower)) {
      _detectedLanguage = '🇫🇷 French';
    } else if (RegExp(r'hallo|danke|wie').hasMatch(lower)) {
      _detectedLanguage = '🇩🇪 German';
    } else {
      _detectedLanguage = '🇺🇸 English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          if (_detectedLanguage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  _detectedLanguage,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Language banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: Text(
              '🌍 I adapt to your language automatically!',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // Loading
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('AI is thinking...'),
                ],
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type in any language...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  backgroundColor: Colors.blue.shade600,
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isSystem;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isSystem = false,
    required this.timestamp,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.amber.shade700, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.amber.shade800,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade600,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.blue.shade600
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade600,
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
