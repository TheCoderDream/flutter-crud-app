import 'package:crud/post_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';


void main() {
  runApp(
    Provider(
      create: (context) => ApiService(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.cyan
      ),
      home: PostList(),
    );
  }
}