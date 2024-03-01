import 'package:flutter/material.dart';
import 'package:typicodenetworking/models/post.dart';
import 'package:typicodenetworking/pages/createpost.dart';
import 'package:typicodenetworking/pages/postdetail.dart';
import 'package:typicodenetworking/widgets/post_widget.dart';
import 'package:typicodenetworking/services/apiservice.dart';
import 'package:typicodenetworking/widgets/loading_widget.dart';
import 'package:typicodenetworking/widgets/showmessage_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  List<Post> _posts = [];

  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  fetchUserPosts() {
    _isLoading = true;
    _apiService.fetchPosts().then((result) {
      if (result.status) {
        _posts.addAll(result.value as List<Post>);
      } else {
        print(result.message);
        showMessage(_context, "Error", result.message);
      }
      _isLoading = false;
      setState(() {});
    });
  }

  toCreatePost() {
    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (context) {
          return CreatePostPage();
        },
      ),
    ).then((isCreateSuccess) {
      if (isCreateSuccess != null && isCreateSuccess == true) {
        fetchUserPosts(); //refresh if new post is added
      }
    });
  }

  toPostDetail(Post post) {
    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (context) {
          return PostDetail(post);
        },
      ),
    ).then((isModified) {
      if (isModified != null) {
        fetchUserPosts();
      }
    });
  }

  fetchPostDetail(Post post) async {
    _apiService.fetchPostDetail(post.id!).then((result) {
      if (result.status) {
        //got the data and jump to detail screen
        final thePost = result.value as Post;
        toPostDetail(thePost);
      } else {
        print(result.message);
        showMessage(_context, "Error", result.message);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: toCreatePost,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_posts.length == 0)
                  const Text(
                    'No Data yet!',
                  ),
                if (_posts.length > 0)
                  Expanded(
                    child: ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          var currentPost = _posts[index];
                          return GestureDetector(
                              onTap: () {
                                _isLoading = true;
                                setState(() {
                                  fetchPostDetail(currentPost);
                                });
                              },
                              child: PostWidget(currentPost));
                        }),
                  ),
              ],
            ),
          ),
          if (_isLoading)
            const Positioned(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
