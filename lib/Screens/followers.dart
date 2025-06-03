import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shakti/Screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<User> users = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        setState(() {
          errorMessage = 'Authentication token not found. Please login again.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/follow/followers_following'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<User> allUsers = [];

        if (data['followers'] != null) {
          for (var follower in data['followers']) {
            if (follower['userId'] != null && follower['fullName'] != null) {
              allUsers.add(User.fromJson(follower));
            }
          }
        }

        if (data['following'] != null) {
          for (var following in data['following']) {
            if (following['userId'] != null && following['fullName'] != null) {
              allUsers.add(User.fromJson(following));
            }
          }
        }

        setState(() {
          users = allUsers;
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Authentication failed. Please login again.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load users (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void navigateToChat(String userId, String fullName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          recipientUserId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                    ),
                    SizedBox(height: 16),
                    Text('Loading users...',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ],
                ),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red[400]),
                        SizedBox(height: 16),
                        Text(
                          errorMessage,
                          style:
                              TextStyle(color: Colors.red[600], fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              errorMessage = '';
                            });
                            fetchUsers();
                          },
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : users.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              'No users found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchUsers,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: Card(
                                elevation: 3,
                                shadowColor: Colors.grey.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.blue[100],
                                    child: Text(
                                      user.fullName.isNotEmpty
                                          ? user.fullName[0].toUpperCase()
                                          : 'U',
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  subtitle: Text(
                                    'ID: ${user.userId}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.blue[600],
                                    size: 20,
                                  ),
                                  onTap: () => navigateToChat(
                                      user.userId, user.fullName),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}

class User {
  final String userId;
  final String fullName;

  User({required this.userId, required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}
