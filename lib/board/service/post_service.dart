import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:firebase_core/firebase_core.dart';

class PostService {
  // PostServicer를 factory 생성자로 만들어서 싱글톤으로 사용
  static final PostService _postService = PostService._internal();

  factory PostService() => _postService;

  // 초기화
  PostService._internal();

  // CREATE
  Future createPost(Map<String, dynamic> json) async {
    /*
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("bulletin_board").doc();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
    */

    await FirebaseFirestore.instance.collection("bulletin_board").add(json);
  }

  // READ All(전체 게시글 목록 출력)
  Future<List<Post>> getPosts() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("bulletin_board");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.orderBy("date", descending: true).get();

    List<Post> posts = [];
    for (var doc in querySnapshot.docs) {
      Post post = Post.fromQuerySnapshot(doc);
      posts.add(post);
    }

    return posts;
  }

  // Select One(목록에서 게시글 선택)
  Future<Post> getPost(DocumentReference reference) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("bulletin_board");
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await collectionReference.doc("$reference").get();

    var post = Post.fromJson(documentSnapshot.data(), reference);
    return post;
  }

  // Select All Matching Tags(위치 태그 구분)
  Future<List<Post>> selectPostsByLocation(
      String? sido, String? gugunsi) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("bulletin_board");
    QuerySnapshot<Map<String, dynamic>> querySnapshot;

    if (sido == null) {
      // 도 전체(도 선택 - 시 선택X)
      querySnapshot = await collectionReference
          .where('location_si/do', isEqualTo: sido)
          .orderBy("date", descending: true)
          .get();
    } else {
      // 시 전체(도 선택 - 시 선택 - 구 선택X)
      querySnapshot = await collectionReference
          .where('location_si/do', isEqualTo: sido)
          .where('location_gu/gun/si', isEqualTo: gugunsi)
          .orderBy("date", descending: true)
          .get();
    }

    List<Post> posts = [];
    for (var doc in querySnapshot.docs) {
      Post post = Post.fromQuerySnapshot(doc);
      posts.add(post);
    }

    return posts;
  }

  // UPDATE
  Future updatePost(
      {required DocumentReference reference,
      required Map<String, dynamic> json}) async {
    await reference.set(json);
  }

  // DELETE
  Future<void> deletePost(DocumentReference reference) async {
    await reference.delete();
  }
}
