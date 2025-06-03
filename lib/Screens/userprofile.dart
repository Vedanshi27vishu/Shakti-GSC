import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  String userName = "Loading...";
  String userEmail = "";
  int followersCount = 0;
  int followingCount = 0;
  int postsCount = 0;
  List<dynamic> userPosts = [];
  late TabController _tabController;

  // Color palette
  static const Color darkBlue = Color(0xFF1A1B3A);
  static const Color lightBlue = Color(0xFF2A2D5A);
  static const Color yellow = Color(0xFFFFD700);
  static const Color lightYellow = Color(0xFFFFF3A0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUserProfile();
    fetchUserPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchUserProfile() async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception('No auth token found');
      }

      // Fetch user basic info (you might need to adjust this API endpoint)
      final userResponse = await http.get(
        Uri.parse('http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/user/profile'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      // Fetch followers/following data
      final followResponse = await http.get(
        Uri.parse('http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/follow/followers_following'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (followResponse.statusCode == 200) {
        final followData = json.decode(followResponse.body);
        setState(() {
          followersCount = (followData['followers'] as List).length;
          followingCount = (followData['following'] as List).length;
        });
      }

      // If you have user profile endpoint, uncomment this:
      // if (userResponse.statusCode == 200) {
      //   final userData = json.decode(userResponse.body);
      //   setState(() {
      //     userName = userData['fullName'] ?? 'User Name';
      //     userEmail = userData['email'] ?? '';
      //   });
      // }

      // Temporary user data (replace with actual API response)
      setState(() {
        userName = "John Doe";
        userEmail = "john.doe@example.com";
        isLoading = false;
      });

    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        isLoading = false;
        userName = "Error loading profile";
      });
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception('No auth token found');
      }

      // TODO: Replace with actual posts API endpoint
      // final response = await http.get(
      //   Uri.parse('http://shaktinxt-env.eba-x3dnqpku.ap-south-1.elasticbeanstalk.com/api/posts/user-posts'),
      //   headers: {
      //     'Authorization': 'Bearer $authToken',
      //     'Content-Type': 'application/json',
      //   },
      // );

      // Temporary mock data for posts
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        userPosts = [
          {'id': 1, 'image': 'https://picsum.photos/300/300?random=1', 'caption': 'Beautiful sunset'},
          {'id': 2, 'image': 'https://picsum.photos/300/300?random=2', 'caption': 'Morning coffee'},
          {'id': 3, 'image': 'https://picsum.photos/300/300?random=3', 'caption': 'Nature walk'},
          {'id': 4, 'image': 'https://picsum.photos/300/300?random=4', 'caption': 'City lights'},
          {'id': 5, 'image': 'https://picsum.photos/300/300?random=5', 'caption': 'Weekend vibes'},
          {'id': 6, 'image': 'https://picsum.photos/300/300?random=6', 'caption': 'Food love'},
        ];
        postsCount = userPosts.length;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        title: Text(
          userName,
          style: TextStyle(
            color: yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: yellow),
            onPressed: () {
              // Add menu functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(yellow),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await fetchUserProfile();
                await fetchUserPosts();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildProfileHeader(screenWidth, screenHeight),
                  ),
                  SliverToBoxAdapter(
                    child: _buildTabBar(),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPostsGrid(),
                        _buildTaggedPosts(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Picture and Stats Row
          Row(
            children: [
              // Profile Picture
              Container(
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: yellow, width: 3),
                  gradient: LinearGradient(
                    colors: [yellow.withOpacity(0.3), lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: screenWidth * 0.12,
                  backgroundColor: lightBlue,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: yellow,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 20),
              
              // Stats
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('Posts', postsCount),
                    _buildStatColumn('Followers', followersCount),
                    _buildStatColumn('Following', followingCount),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Name and Bio
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "✨ Living life to the fullest\n🌟 Dream big, work hard\n📍 New York, NY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Edit Profile',
                  Icons.edit,
                  () {
                    // Add edit profile functionality
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  'Share Profile',
                  Icons.share,
                  () {
                    // Add share functionality
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 35,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: yellow.withOpacity(0.3)),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 16),
        label: Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: yellow,
        indicatorWeight: 2,
        labelColor: yellow,
        unselectedLabelColor: Colors.grey[500],
        tabs: [
          Tab(
            icon: Icon(Icons.grid_on),
            text: 'Posts',
          ),
          Tab(
            icon: Icon(Icons.person_pin),
            text: 'Tagged',
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid() {
    if (userPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Colors.grey[600],
            ),
            SizedBox(height: 20),
            Text(
              'No posts yet',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Share photos and videos to get started',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        return GestureDetector(
          onTap: () {
            _showPostDetails(post);
          },
          child: Container(
            decoration: BoxDecoration(
              color: lightBlue,
              border: Border.all(color: Colors.grey[800]!, width: 0.5),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Mock image placeholder
                Container(
                  color: lightBlue,
                  child: Icon(
                    Icons.image,
                    color: yellow.withOpacity(0.7),
                    size: 40,
                  ),
                ),
                // Overlay for interaction
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaggedPosts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_pin_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          SizedBox(height: 20),
          Text(
            'No tagged posts',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Posts where you\'re tagged will appear here',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showPostDetails(dynamic post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.image,
                    color: yellow,
                    size: 60,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  post['caption'] ?? 'No caption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border, color: yellow),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.comment_outlined, color: yellow),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.share_outlined, color: yellow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}