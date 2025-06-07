import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;
  final String recipientName;
  final String? recipientAvatar;

  const ChatScreen({
    Key? key,
    required this.recipientUserId,
    required this.recipientName,
    this.recipientAvatar,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;

  String? _status;
  String? myUserId;
  List<Map<String, dynamic>> _messages = [];
  bool _hasSetupListeners = false;
  bool _isDisposed = false;
  bool _isTyping = false;
  String? _typingUserId;
  bool _isOnline = false;

  // Color palette
  final Color primaryColor = const Color(0xFF1E3A8A); // Dark blue
  final Color secondaryColor = const Color(0xFFFBBF24); // Yellow
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color messageBackgroundColor = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    connectSocket();
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recipientUserId != oldWidget.recipientUserId) {
      if (mounted && !_isDisposed) {
        setState(() {
          _messages = [];
        });
      }
    }
  }

  void safeSetState(VoidCallback fn) {
    if (mounted && !_isDisposed) {
      setState(fn);
    }
  }

  Future<void> connectSocket() async {
    if (_isDisposed) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        safeSetState(() => _status = "⚠️ Token missing");
        return;
      }

      if (_isDisposed) return;

      final payload = token.split('.')[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      myUserId = json.decode(decoded)['userId'];

      socket = IO.io(
        'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({'token': token})
            .build(),
      );

      if (!_hasSetupListeners && !_isDisposed) {
        _setupSocketListeners();
        _hasSetupListeners = true;
      }

      if (!_isDisposed) {
        socket.connect();
      }
    } catch (e) {
      safeSetState(() => _status = "❌ Connection error: $e");
    }
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      safeSetState(() {
        _status = "✅ Connected";
        _isOnline = true;
      });

      if (!_isDisposed) {
        socket.emit('fetch-messages', {'userId': widget.recipientUserId});
      }
    });

    socket.onDisconnect((_) {
      safeSetState(() {
        _status = "🔌 Disconnected. Reconnecting...";
        _isOnline = false;
      });

      if (!_isDisposed) {
        Future.delayed(Duration(seconds: 3), () {
          if (!_isDisposed && !socket.connected) {
            socket.connect();
          }
        });
      }
    });

    socket.onConnectError((data) {
      safeSetState(() => _status = "❌ Connect error: $data");
    });

    // Handle old messages
    socket.on('old-messages', (data) {
      if (_isDisposed) return;

      if (data is List) {
        try {
          final List<Map<String, dynamic>> oldMsgs =
              data.map<Map<String, dynamic>>((msg) {
            return {
              'id': msg['_id'],
              'from': msg['senderId'],
              'message': msg['message'],
              'timestamp': msg['timestamp'],
              'seen': msg['seen'] ?? false,
            };
          }).toList();

          oldMsgs.sort((a, b) => DateTime.parse(a['timestamp'])
              .compareTo(DateTime.parse(b['timestamp'])));

          safeSetState(() {
            _messages = oldMsgs;
          });

          if (!_isDisposed) {
            _scrollToBottom();
            _markMessagesAsSeen();
          }
        } catch (e) {
          safeSetState(() => _status = "❌ Error parsing old messages: $e");
        }
      }
    });

    // Handle new messages
    socket.on('private-message', (data) {
      if (_isDisposed) return;

      if (data is Map) {
        try {
          final newMsg = {
            'id': data['_id'],
            'from': data['from'],
            'message': data['message'],
            'timestamp': data['timestamp'],
            'seen': data['seen'] ?? false,
          };

          bool isDuplicate = _messages.any((msg) => msg['id'] == newMsg['id']);

          if (!isDuplicate) {
            safeSetState(() {
              _messages.add(newMsg);
            });

            if (!_isDisposed) {
              _scrollToBottom();
              if (data['from'] != myUserId) {
                _markMessagesAsSeen();
              }
            }
          }
        } catch (e) {
          safeSetState(() => _status = "❌ Error processing message: $e");
        }
      }
    });

    // Handle message seen status
    socket.on('messages-seen', (data) {
      if (_isDisposed) return;

      if (data is Map && data['byUserId'] == widget.recipientUserId) {
        safeSetState(() {
          for (var msg in _messages) {
            if (msg['from'] == myUserId) {
              msg['seen'] = true;
            }
          }
        });
      }
    });

    // Handle typing indicators
    socket.on('typing', (data) {
      if (_isDisposed) return;

      if (data is Map && data['fromUserId'] == widget.recipientUserId) {
        safeSetState(() {
          _isTyping = true;
          _typingUserId = data['fromUserId'];
        });
      }
    });

    socket.on('stop-typing', (data) {
      if (_isDisposed) return;

      if (data is Map && data['fromUserId'] == widget.recipientUserId) {
        safeSetState(() {
          _isTyping = false;
          _typingUserId = null;
        });
      }
    });
  }

  void _markMessagesAsSeen() {
    if (!_isDisposed) {
      socket.emit('message-seen', {'fromUserId': widget.recipientUserId});
    }
  }

  void sendMessage() {
    if (_isDisposed) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      socket.emit('private-message', {
        'toUserId': widget.recipientUserId,
        'message': message,
      });

      _messageController.clear();
      _stopTyping();

      if (!_isDisposed) {
        _scrollToBottom();
      }
    } catch (e) {
      safeSetState(() => _status = "❌ Error sending message: $e");
    }
  }

  void _onTyping() {
    if (!_isDisposed) {
      socket.emit('typing', {'toUserId': widget.recipientUserId});
    }
  }

  void _stopTyping() {
    if (!_isDisposed) {
      socket.emit('stop-typing', {'toUserId': widget.recipientUserId});
    }
  }

  void _scrollToBottom() {
    if (_isDisposed) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && _scrollController.hasClients) {
        try {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } catch (e) {
          // Ignore scroll errors if widget is disposed
        }
      }
    });
  }

  Widget _buildTypingIndicator() {
    return AnimatedBuilder(
      animation: _typingAnimationController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${widget.recipientName} is typing",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  Widget buildMessageBubble(Map<String, dynamic> messageData) {
    String sender = messageData['from'];
    String message = messageData['message'];
    bool seen = messageData['seen'] ?? false;
    String timestamp = messageData['timestamp'];

    bool isMe = sender == myUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? primaryColor : messageBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4),
                  Icon(
                    seen ? Icons.done_all : Icons.done,
                    size: 16,
                    color: seen ? secondaryColor : Colors.grey[600],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "Now";
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Clean up socket listeners
    if (_hasSetupListeners) {
      try {
        socket.off('private-message');
        socket.off('old-messages');
        socket.off('messages-seen');
        socket.off('typing');
        socket.off('stop-typing');
        socket.off('connect');
        socket.off('disconnect');
        socket.off('connect_error');
      } catch (e) {
        // Ignore cleanup errors
      }
    }

    // Dispose socket
    try {
      if (socket.connected) {
        socket.disconnect();
      }
      socket.dispose();
    } catch (e) {
      // Ignore disposal errors
    }

    // Dispose controllers and animations
    _typingAnimationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _status?.startsWith("✅") ?? false;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: secondaryColor,
              backgroundImage: widget.recipientAvatar != null
                  ? NetworkImage(widget.recipientAvatar!)
                  : null,
              child: widget.recipientAvatar == null
                  ? Text(
                      widget.recipientName.isNotEmpty
                          ? widget.recipientName[0].toUpperCase()
                          : "U",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipientName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      color: _isOnline ? secondaryColor : Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!isConnected)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Colors.orange[100],
              child: Text(
                _status ?? "Connecting...",
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (isConnected)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  final msg = _messages[index];
                  return buildMessageBubble(msg);
                },
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            _onTyping();
                          } else {
                            _stopTyping();
                          }
                        },
                        onSubmitted: (_) => sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
