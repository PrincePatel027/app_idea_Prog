import 'dart:developer';
import 'dart:typed_data';

import 'package:app_idea_prog/helper/db_helper.dart';
import 'package:app_idea_prog/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;
  String? email;
  String? userId;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  addPost() {
    Navigator.pushNamed(context, "add_post");
    setState(() {});
  }

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString("USERNAME");
    email = preferences.getString("USEREMAIL");
    userId = preferences.getString("USERID");
    setState(() {});
  }

  Future<void> showEditDialog(
      {required BuildContext context,
      required String postId,
      required String currentTitle,
      required Uint8List currentImage}) async {
    final TextEditingController titleController =
        TextEditingController(text: currentTitle);
    Uint8List? newImage = currentImage;

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        newImage = await image.readAsBytes();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Post"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Post Title"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImage,
                  child: newImage != null
                      ? Image.memory(newImage!, height: 100, fit: BoxFit.cover)
                      : const Text("No image selected."),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await DbHelper.dbHelper.updatePost(
                  postId: postId.toString(),
                  title: titleController.text,
                  image: newImage,
                );

                setState(() {}); // Refresh the UI after updating

                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void handleLike({required String postId}) async {
    await DbHelper.dbHelper.addLike(
      postId: postId,
      userId: userId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeUtils.getScreenHeight(context: context);
    double width = SizeUtils.getScreenWidth(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome $username👋"),
        forceMaterialTransparency: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: logOut,
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: DbHelper.dbHelper.fetchAllPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("ERROR: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List? data = snapshot.data as List;
            log(data.toString());
            return (data.isEmpty)
                ? const Center(
                    child: Text("No Posts...."),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return myPost(
                        image: data[index]['image'],
                        height: height,
                        width: width,
                        context: context,
                        title: data[index]['title'],
                        postId: data[index]['post_id'].toString(),
                      );
                    },
                  );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPost,
        label: const Text("Add Post"),
        icon: const Icon(Icons.post_add),
      ),
    );
  }

  Column myPost({
    required double height,
    required double width,
    required BuildContext context,
    required String title,
    required Uint8List image,
    required String postId,
  }) {
    return Column(
      children: [
        Container(
          height: height * 0.3,
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            bottom: width * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.04),
            color: Colors.green[100]!,
            image: DecorationImage(
              image: MemoryImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: height * 0.03,
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.04,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.016),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: width * 0.048),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                handleLike(postId: postId);
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: (isLiked)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.white54,
                                      size: 28,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white54,
                                      size: 28,
                                    ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "0",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                        SizedBox(width: width * 0.048),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showSheet(context,
                                    postId: postId, userId: userId!);
                              },
                              child: const Icon(
                                Icons.comment,
                                color: Colors.white54,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "0",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                        SizedBox(width: width * 0.048),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showEditDialog(
                                  context: context,
                                  postId: postId,
                                  currentTitle: title,
                                  currentImage: image,
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.green.withOpacity(0.8),
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: width * 0.048),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                int? res = await DbHelper.dbHelper
                                    .deletePost(postId: postId);

                                if (res != null && res >= 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Post Deleted Successfully..."),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Post Deletion Failed..."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                setState(() {});
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red.withOpacity(0.8),
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: width * 0.048)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("USERNAME", "");
    preferences.setString("USEREMAIL", "");
    preferences.setString("USERID", "");
    Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
  }

  Future<dynamic> showSheet(BuildContext context,
      {required String postId, required String userId}) {
    final TextEditingController commentController = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Comments',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Add a comment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      if (commentController.text.isNotEmpty) {
                        int? res = await DbHelper.dbHelper.addComment(
                          postId: int.parse(postId),
                          userId: int.parse(userId),
                          content: commentController.text,
                        );

                        if (res != null && res >= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Comment Added..."),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Comment Failed..."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit Comment'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
