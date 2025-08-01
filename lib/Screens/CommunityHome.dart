import 'package:flutter/material.dart';
import 'package:shakti/Screens/userprofile.dart';
import 'package:shakti/Widgets/AppWidgets/CommunityHomeAppBar.dart';
import 'package:shakti/Widgets/AppWidgets/ScreenHeadings.dart';
import 'package:shakti/Widgets/AppWidgets/communitywidget/authhelper.dart';
import 'package:shakti/Widgets/AppWidgets/communitywidget/interactivepostcard.dart';
import 'package:shakti/Widgets/AppWidgets/communitywidget/postservice.dart';
import 'package:shakti/helpers/helper_functions.dart';
import 'package:shakti/Utils/constants/colors.dart';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {
  List<PostModel> posts = [];
  bool isLoading = true;
  String errorMessage = '';
  bool showDebugInfo = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    // Debug auth data first
    await AuthHelper.debugAuthData();

    // Check if user is logged in
    final isLoggedIn = await AuthHelper.isLoggedIn();
    print('User logged in: $isLoggedIn');

    if (!isLoggedIn) {
      setState(() {
        errorMessage = 'User not logged in. Please login first.';
        isLoading = false;
      });
      return;
    }

    // Load posts
    await _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      print('Attempting to load posts...');
      final fetchedPosts = await PostService.getPostsByInterest();
      print('Posts loaded successfully: ${fetchedPosts.length} posts');

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Future<void> _onLikePost(String postId, int postIndex) async {
  //   try {
  //     print('Attempting to like post: $postId');
  //     await PostService.likePost(postId);
  //     print('Post liked successfully');
  //     // Refresh the specific post or the entire list
  //     await _loadPosts();
  //   } catch (e) {
  //     print('Error liking post: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to like post: $e')),
  //     );
  //   }
  // }

  bool isCommenting = false;

  Future<void> _onCommentPost(String postId, String comment) async {
    if (isCommenting) return; // prevent double submission
    isCommenting = true;
    setState(() {
      isCommenting = true;
    });

    try {
      print('Attempting to comment on post: $postId with comment: $comment');
      await PostService.commentOnPost(postId, comment);
      print('Comment posted successfully');

      // Only refresh posts if needed - you might want to handle this differently
      // to avoid unnecessary API calls
      final updatedPosts = await PostService.getPostsByInterest();
      final updatedPost = updatedPosts.firstWhere((p) => p.id == postId);
      _updatePostInList(updatedPost);
    } catch (e) {
      print('Error commenting on post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to comment: $e')),
        );
      }
    } finally {
      setState(() {
        isCommenting = false;
      });
    }
  }

  void _updatePostInList(PostModel updatedPost) {
    setState(() {
      final index = posts.indexWhere((post) => post.id == updatedPost.id);
      if (index != -1) {
        posts[index] = updatedPost;
      }
    });
  }

  // void _onPostUpdated(PostModel updatedPost) {
  //   setState(() {
  //     final index = posts.indexWhere((post) => post.id == updatedPost.id);
  //     if (index != -1) {
  //       posts[index] = updatedPost;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = THelperFunctions.screenWidth(context);
    double screenHeight = THelperFunctions.screenHeight(context);

    return Scaffold(
      backgroundColor: Scolor.primary,
      body: Column(
        children: [
          /// *Custom Top Bar*
          CustomTopBar1(),

          /// *Debug Toggle Button*
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ScreenHeadings(text: "Posts"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen()),
                    );
                  },
                  child: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       showDebugInfo = !showDebugInfo;
                //     });
                //   },
                //   child: Text(
                //     showDebugInfo ? 'Hide Debug' : 'Show Debug',
                //     style: TextStyle(color: Colors.white, fontSize: 12),
                //   ),
                // ),
              ],
            ),
          ),

          /// *Debug Info Section*
          if (showDebugInfo)
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DEBUG INFO:',
                      style: TextStyle(
                          color: Colors.yellow, fontWeight: FontWeight.bold)),
                  Text('Loading: $isLoading',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text('Posts Count: ${posts.length}',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text('Error: $errorMessage',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                  ElevatedButton(
                    onPressed: AuthHelper.debugAuthData,
                    child: Text('Log Auth Data'),
                  ),
                ],
              ),
            ),

          /// *Posts List*
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0), // Less padding
              child: _buildPostsList(screenWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(double screenWidth) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'Error loading posts',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                errorMessage,
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'No posts available',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              'Be the first to create a post!',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: EdgeInsets.only(bottom: screenWidth * 0.02),
            child: PostCard(
              post: post,
              onComment: (comment) => _onCommentPost(post.id, comment),
              onPostUpdated: _updatePostInList, // Add this callback
              // Remove onLike callback - handled internally now
            ),
          );
        },
      ),
    );
  }
}
