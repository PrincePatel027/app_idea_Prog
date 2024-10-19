import 'dart:typed_data';
import 'package:app_idea_prog/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? _imageData;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _addPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter post title',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Image:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                _imageData != null
                    ? Image.memory(
                        _imageData!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(
                        height: 100,
                        width: 100,
                        child: Placeholder(),
                      ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageData = await image.readAsBytes();
      setState(() {});
    }
  }

  Future<void> _addPost() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? id = preferences.getString("USERID");

    if (_titleController.text.isNotEmpty && _imageData != null) {
      int? res = await DbHelper.dbHelper.addPost(
        userId: id!,
        title: _titleController.text,
        image: _imageData,
      );

      if (res != null && res >= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unsuccesfull!'),
            backgroundColor: Colors.red,
          ),
        );
      }
      Navigator.pop(context, true);
    } else {
      // Show an error message if title or image is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }
}
