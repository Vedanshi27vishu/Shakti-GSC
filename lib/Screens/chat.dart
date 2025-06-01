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

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recipientUserId != oldWidget.recipientUserId) {
      setState(() {
        _messages = [];
      });
    }
  }

  Future<void> connectSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() => _status = "⚠️ Token missing");
      return;
    }

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

    if (!_hasSetupListeners) {
      _setupSocketListeners();
      _hasSetupListeners = true;
    }

    socket.connect();
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      setState(() => _status = "✅ Connected");
    });

    socket.onDisconnect((_) {
      setState(() => _status = "🔌 Disconnected. Reconnecting...");
      Future.delayed(Duration(seconds: 3), () {
        if (!socket.connected) {
          socket.connect();
        }
      });
    });

    socket.onConnectError((data) {
      setState(() => _status = "❌ Connect error: $data");
    });

    socket.on('private-message', (data) {
      if (data is Map) {
        final newMsg = {
          'from': data['from'],
          'message': data['message'],
          'timestamp': data['timestamp'],
        };

        // Avoid duplicates
        bool isDuplicate = _messages.any((msg) =>
            msg['from'] == newMsg['from'] &&
            msg['message'] == newMsg['message'] &&
            msg['timestamp'] == newMsg['timestamp']);

        if (!isDuplicate) {
          setState(() {
            _messages.add(newMsg);
          });
          _scrollToBottom();
        }
      }
    });
  }

  void sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    socket.emit('private-message', {
      'toUserId': widget.recipientUserId,
      'message': message,
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
    if (_hasSetupListeners) {
      socket.off('private-message');
    }
    socket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _status?.startsWith("✅") ?? false;

    return Scaffold(
      appBar: AppBar(title: Text("💬 Chat")),
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
