import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:remote_demo/model/post.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'},
    );

    import 'dart:convert';
    import 'package:flutter/cupertino.dart';
    import 'package:http/http.dart' as http;
    import 'package:remote_demo/model/user.dart'; // Assuming you create a User model

    class UserRepository {
    final String baseUrl = "https://jsonplaceholder.typicode.com";

    // Fetches a list of Users instead of Posts
    Future<List<User>> fetchUsers() async {
    final response = await http.get(
    Uri.parse('$baseUrl/users'),
    headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => User.fromJson(item)).toList();
    } else {
    throw Exception("System failed to retrieve directory");
    }
    }

    // A unique addition: Deleting a user resource
    Future<bool> removeUser(int id) async {
    final response = await http.delete(
    Uri.parse('$baseUrl/users/$id'),
    );

    if (response.statusCode == 200) {
    return true;
    } else {
    debugPrint("Delete Error: ${response.statusCode}");
    return false;
    }
    }
    }