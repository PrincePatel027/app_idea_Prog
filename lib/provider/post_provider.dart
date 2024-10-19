import 'dart:typed_data';
import 'package:app_idea_prog/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider with ChangeNotifier {
  List _posts = [];
  bool _isLoading = false;

  List get posts => _posts;
  bool get isLoading => _isLoading;

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    _isLoading = true;
    notifyListeners();

    List? fetchedPosts = await DbHelper.dbHelper.fetchAllPost();
    _posts = fetchedPosts;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPost(
      {required String title, required Uint8List image}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("USERID");
    await DbHelper.dbHelper.addPost(title: title, image: image, userId: id!);
    fetchAllPosts();
  }

  // Update post
  Future<void> updatePost(
      {required String postId, required String title, Uint8List? image}) async {
    await DbHelper.dbHelper
        .updatePost(postId: postId, title: title, image: image);
    fetchAllPosts();
  }

  // Handle like
  Future<void> handleLike(
      {required String postId, required String userId}) async {
    await DbHelper.dbHelper.addLike(
      postId: postId,
      userId: userId,
    );
    fetchAllPosts();
  }

  // Delete post
  Future<void> deletePost({required String postId}) async {
    await DbHelper.dbHelper.deletePost(postId: postId);
    fetchAllPosts();
  }
}
