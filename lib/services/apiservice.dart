import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:typicodenetworking/models/post.dart';
import 'package:typicodenetworking/models/user.dart';

class Result {
  bool status;
  dynamic value;
  String? message;
  Result(
    this.status,
    this.value, {
    this.message = "",
  });
}

class ApiService {
  final _hostUrl = "jsonplaceholder.typicode.com";
  final _scheme = "https";

  Future<Result> createPost(String title, String body, {int userid = 1}) async {
    var _path = "/posts";
    var _uri = Uri(scheme: _scheme, host: _hostUrl, path: _path);
    var param = {"title": title, "body": body, "userid": userid};
    var response = await http.post(_uri,
        headers: {"Content-Type": "application/json"}, //**** */
        body: JsonEncoder().convert(param)); //**** */

    if (response.statusCode == 201) {
      //**** */
      var postJson = JsonDecoder().convert(response.body) as dynamic;
      var post = Post.fromJson(postJson); //collect all posts
      var result = Result(true, post, message: "Creating post success");
      return result;
    } else {
      var result = Result(false, null, message: "Creating post  failed");
      return result;
    }
  }

  //delete
  Future<Result> delete(int id) async {
    var _path = "/posts/$id";
    var _uri = Uri(scheme: _scheme, host: _hostUrl, path: _path);
    var response = await http.delete(_uri);
    if (response.statusCode == 200) {
      //var postsJson = JsonDecoder().convert(response.body) as List<dynamic>;

      var result = Result(true, {}, message: "Post deleted successfully");
      return result;
    } else {
      var result = Result(false, null, message: "Deleting post  failed");
      return result;
    }
  }

  //edit/put
  Future<Result> editPost(int postid, String title, String body,
      {int userid = 1}) async {
    var _path = "/posts/$postid";
    var _uri = Uri(scheme: _scheme, host: _hostUrl, path: _path);
    var param = {"title": title, "body": body, "userid": userid};
    var response = await http.put(_uri,
        headers: {"Content-Type": "application/json"}, //**** */
        body: JsonEncoder().convert(param)); //**** */

    if (response.statusCode == 200) {
      //**** */
      var postJson = JsonDecoder().convert(response.body) as dynamic;
      var post = Post.fromJson(postJson); //collect all posts
      var result = Result(true, post, message: "Post updated successfully");
      return result;
    } else {
      var result = Result(false, null, message: "Updating post  failed");
      return result;
    }
  }

  Future<Result> fetchPosts() async {
    List<Post> posts = [];
    var _path = "/posts";
    var _uri = Uri(scheme: _scheme, host: _hostUrl, path: _path);
    var response = await http.get(_uri);
    if (response.statusCode == 200) {
      var postsJson = JsonDecoder().convert(response.body) as List<dynamic>;
      postsJson.forEach((json) {
        //loop it coz it is list of dynamic( Map)
        posts.add(Post.fromJson(json)); //collect all posts
      });
      var result = Result(true, posts);
      return result;
    } else {
      var result = Result(false, posts, message: "Fetching post failed");
      return result;
    }
  }

  Future<Result> fetchPostDetail(int id) async {
    var _path = "/posts/$id";
    var _uri = Uri(scheme: _scheme, host: _hostUrl, path: _path);
    var response = await http.get(_uri);
    if (response.statusCode == 200) {
      //var postsJson = JsonDecoder().convert(response.body) as List<dynamic>;
      var postJson = JsonDecoder().convert(response.body) as dynamic;
      var post = Post.fromJson(postJson); //collect the required post

      var result = Result(true, post);
      return result;
    } else {
      var result = Result(false, null, message: "Fetching post detail failed");
      return result;
    }
  }

  Future<List<User>> fetchUsers() async {
    var _path = "/users";
    return [];
  }
}
