import 'dart:developer';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static DbHelper dbHelper = DbHelper._();

  Database? database;

  initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "sm_data.db");
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String authQuery = """
        CREATE TABLE IF NOT EXISTS auth(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL UNIQUE,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL
        );
      """;
        await db.execute(authQuery);
        log("Auth Table created succesfully...");
        String postQuery = """
            CREATE TABLE posts (
            post_id INTEGER PRIMARY KEY AUTOINCREMENT,    
            user_id INTEGER NOT NULL,                     
            title TEXT NOT NULL,                          
            image BLOB,                 
            FOREIGN KEY (user_id) REFERENCES users(user_id)
        );
        """;
        await db.execute(postQuery);
        log("Post Table created succesfully...");

        String commentQuery = """
            CREATE TABLE comments (
            comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            content TEXT NOT NULL,
            FOREIGN KEY (post_id) REFERENCES posts(post_id),
            FOREIGN KEY (user_id) REFERENCES users(user_id)
        );
        """;
        await db.execute(commentQuery);
        log("Comments Table created succesfully...");

        String likeQuery = """
           CREATE TABLE likes (
          like_id INTEGER PRIMARY KEY AUTOINCREMENT,
          post_id INTEGER NOT NULL,
          user_id INTEGER NOT NULL,
          created_at TEXT,
          FOREIGN KEY (post_id) REFERENCES posts(post_id),
          FOREIGN KEY (user_id) REFERENCES users(user_id)
        );
        """;
        await db.execute(likeQuery);
        log("Comments Table created succesfully...");
      },
    );
  }

  Future<int?> singUp(
      {required String username,
      required String email,
      required String password}) async {
    if (database == null) {
      initDB();
    } else {
      String query = """
      INSERT INTO auth(username,email,password)
      VALUES(?,?,?);
    """;
      List args = [username, email, password];
      return database?.rawInsert(query, args);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> signIn({
    required String email,
    required String password,
  }) async {
    if (database == null) {
      await initDB();
    } else {
      String query = """
      SELECT * FROM auth WHERE email=? AND password=?;
    """;

      List<String> args = [email, password];

      List<Map<String, dynamic>> result = await database!.rawQuery(query, args);
      return result;
    }
    return null;
  }

  Future<int?> addPost({
    required String userId,
    required String title,
    Uint8List? image,
  }) async {
    if (database == null) {
      await initDB();
    }
    String query = """
      INSERT INTO posts (
        user_id,
        title,
        image
      ) VALUES (?, ?, ?, ?);
    """;

    List<dynamic> args = [
      userId,
      title,
      image,
    ];
    int? res = await database?.rawInsert(query, args);
    return res;
  }

  Future<int?> deletePost({required String postId}) async {
    if (database == null) {
      await initDB();
    }

    String query = """
      DELETE FROM posts 
      WHERE post_id = ?;
    """;

    return await database!.rawDelete(query, [postId]);
  }

  Future<List<Map<String, dynamic>>> fetchAllPost() async {
    if (database == null) {
      await initDB();
    }
    String query = "SELECT * FROM posts;";
    List<Map<String, dynamic>> res = await database!.rawQuery(query);
    return res;
  }

  Future<int?> addComment({
    required int postId,
    required int userId,
    required String content,
  }) async {
    String query = """
        INSERT INTO comments (post_id, user_id, content) 
        VALUES (?, ?, ?, ?);
      """;
    return await database!.rawInsert(query, [postId, userId, content]);
  }

  Future<int?> addLike({
    required String postId,
    required String userId,
  }) async {
    String query = """
      INSERT INTO likes (post_id, user_id) 
      VALUES (?, ?, ?);
    """;
    return await database!.rawInsert(query, [postId, userId]);
  }

  Future<void> updatePost({
    required String postId,
    required String title,
    required Uint8List? image,
  }) async {
    if (database == null) {
      await initDB();
    } else {
      String query = """
      UPDATE posts 
      SET title = ?, image = ?
      WHERE post_id = ?;
    """;
      await database!.rawUpdate(query, [title, image]);
    }
  }
}
