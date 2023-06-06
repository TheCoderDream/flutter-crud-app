import 'package:flutter/material.dart';
import 'post.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final Function(Post) onSubmit;

  PostForm({required this.onSubmit, this.post});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.post?.title
    );
    _bodyController = TextEditingController(
        text: widget.post?.body
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _bodyController,
            decoration: const InputDecoration(
              labelText: 'Description'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          SizedBox(height: 24,),
          ElevatedButton(
            child: Text(widget.post == null ? 'Create': 'Update'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  Post(
                    id: widget.post?.id ?? 0,
                    title: _titleController.text,
                    body: _bodyController.text
                  )
                );
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}