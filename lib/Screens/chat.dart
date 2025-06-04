import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;

  const ChatScreen({Key? key, required this.recipientUserId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _status;
  String? myUserId;
  List<Map<String, dynamic>> _messages = [];
  bool _hasSetupListeners = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
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

  // Safe setState wrapper
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
      safeSetState(() => _status = "✅ Connected");

      // 🔄 Fetch old messages
      if (!_isDisposed) {
        socket.emit('fetch-messages', {'userId': widget.recipientUserId});
      }
    });

    socket.onDisconnect((_) {
      safeSetState(() => _status = "🔌 Disconnected. Reconnecting...");

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

    // ✅ Handle old messages
    socket.on('old-messages', (data) {
      if (_isDisposed) return;

      if (data is List) {
        try {
          final List<Map<String, dynamic>> oldMsgs =
              data.map<Map<String, dynamic>>((msg) {
            return {
              'from': msg['senderId'],
              'message': msg['message'],
              'timestamp': msg['timestamp'],
            };
          }).toList();

          oldMsgs.sort((a, b) => DateTime.parse(a['timestamp'])
              .compareTo(DateTime.parse(b['timestamp'])));

          safeSetState(() {
            _messages = oldMsgs;
          });

          if (!_isDisposed) {
            _scrollToBottom();
          }
        } catch (e) {
          safeSetState(() => _status = "❌ Error parsing old messages: $e");
        }
      }
    });

    // ✅ Handle new messages
    socket.on('private-message', (data) {
      if (_isDisposed) return;

      if (data is Map) {
        try {
          final newMsg = {
            'from': data['from'],
            'message': data['message'],
            'timestamp': data['timestamp'],
          };

          bool isDuplicate = _messages.any((msg) =>
              msg['from'] == newMsg['from'] &&
              msg['message'] == newMsg['message'] &&
              msg['timestamp'] == newMsg['timestamp']);

          if (!isDuplicate) {
            safeSetState(() {
              _messages.add(newMsg);
            });

            if (!_isDisposed) {
              _scrollToBottom();
            }
          }
        } catch (e) {
          safeSetState(() => _status = "❌ Error processing message: $e");
        }
      }
    });
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

      if (!_isDisposed) {
        _scrollToBottom();
      }
    } catch (e) {
      safeSetState(() => _status = "❌ Error sending message: $e");
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

  Widget buildMessageBubble(String sender, String message) {
    bool isMe = sender == myUserId;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Clean up socket listeners
    if (_hasSetupListeners) {
      try {
        socket.off('private-message');
        socket.off('old-messages');
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

    // Dispose controllers
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _status?.startsWith("✅") ?? false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("💬 Chat"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _status ?? "Connecting...",
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (isConnected)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return buildMessageBubble(msg['from'], msg['message']);
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                  color: Colors.blueAccent,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
