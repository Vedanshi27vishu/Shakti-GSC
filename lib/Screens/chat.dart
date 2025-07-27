import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String recipientId;
  const ChatScreen({super.key, required this.recipientId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  final String baseUrl =
      'http://13.233.25.114:5000';
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showSnackBar("Token not found.");
      return;
    }

    socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({'token': token})
            .build());

    socket.connect();

    socket.onConnect((_) {
      _showSnackBar('Connected');
    });

    socket.on('private-message', (data) {
      setState(() {
        _messages.add(data);
      });
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final msgData = {
      'toUserId': widget.recipientId,
      'message': message,
      'messageType': 'text',
    };

    socket.emit('private-message', msgData);

    setState(() {
      _messages.add({
        'message': message,
        'from': 'me',
        'messageType': 'text',
      });
    });

    _messageController.clear();
  }

  Future<void> _uploadFile(String type) async {
    setState(() => isUploading = true);
    File? file;
    String endpoint;
    String fieldName;

    try {
      if (type == 'image') {
        final XFile? picked =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (picked == null) return;

        final ext = picked.name.split('.').last.toLowerCase();
        if (!(ext == 'jpg' || ext == 'jpeg' || ext == 'png')) {
          _showSnackBar('Only JPG/PNG allowed');
          return;
        }

        file = File(picked.path);
        endpoint = '/api/upload/image';
        fieldName = 'image';
      } else {
        final result = await FilePicker.platform.pickFiles();
        if (result == null || result.files.single.path == null) return;

        file = File(result.files.single.path!);
        endpoint = '/api/upload/file';
        fieldName = 'file';
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _showSnackBar('Token missing');
        return;
      }

      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json';

      final mimeType = lookupMimeType(file.path);
      request.files.add(await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'),
      ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          final message = {
            'toUserId': widget.recipientId,
            'messageType': type,
            type: data[type], // file or image
          };

          socket.emit('private-message', message);

          _showSnackBar('${type == 'image' ? 'Image' : 'File'} uploaded');
        } else {
          _showSnackBar('Upload failed');
        }
      } else {
        _showSnackBar('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Upload error: $e');
    } finally {
      setState(() => isUploading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildMessageItem(Map msg) {
    final isMe = msg['from'] == 'me';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: msg['messageType'] == 'text'
            ? Text(msg['message'],
                style: TextStyle(color: isMe ? Colors.white : Colors.black))
            : Text('${msg['messageType'].toUpperCase()} uploaded'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientId}'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildMessageItem(_messages[i]),
            ),
          ),
          if (isUploading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => _uploadFile('image'),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _uploadFile('file'),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
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
    _messageController.dispose();
    socket.dispose();
    super.dispose();
  }
}
