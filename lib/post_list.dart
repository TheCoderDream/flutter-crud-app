import 'package:crud/api_service.dart';
import 'package:crud/post_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'post.dart';

class PostList extends StatefulWidget {

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<List<Post>> _postList;

  @override
  void initState() {
    super.initState();
    _postList = context.read<ApiService>().getPosts();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<List<Post>>(
          future: _postList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final postList = snapshot.data!;
              return ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        postList[index].title,
                      ),
                      subtitle: Text(
                          postList[index].body
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showPostForm(post: postList[index]);
                            },
                          ),
                          SizedBox(width: 10,),
                          IconButton(
                            hoverColor: Colors.pink,
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deletePost(postList[index].id);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showPostForm();
        },
      ),
    );
  }


  void _refreshPost() {
    setState(() {
      _postList = context.read<ApiService>().getPosts();
    });
  }

  void _deletePost(int id) async {
    await context.read<ApiService>().deletePost(id);
    _refreshPost();
  }
  
  void _showPostForm({Post? post}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: PostForm(
            post: post,
            onSubmit: (newPost) async {
              if (post == null) {
                await context.read<ApiService>().createPost(newPost);
              } else {
                await context.read<ApiService>().update(newPost);
              }
              _refreshPost();
            },
          ),
        )
    );
  }
}