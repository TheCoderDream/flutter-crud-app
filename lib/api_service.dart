import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

const jsonHeader = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> update(Post post) async {
    final response = await http.put(
        Uri.parse('$_baseUrl/posts/${post.id}'),
      headers: jsonHeader,
      body: jsonEncode(post.toJson())
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return Post.fromJson(res);
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: jsonHeader,
      body: jsonEncode(post)
    );

    if (response.statusCode == 201) {
      final res = jsonDecode(response.body);
      return Post.fromJson(res);
    }
    else {
      throw Exception('Failed to create post');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/posts/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}