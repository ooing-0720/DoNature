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
        await collectionReference.orderBy("date").get();

    List<Post> posts = [];
    for (var doc in querySnapshot.docs) {
      Post post = Post.fromQuerySnapshot(doc);
      posts.add(post);
    }

    return posts;
  }

  // Select All Matching Tags(위치 태그 구분)
  Future<List<Post>> selectPostsByLocation(
      String? dou, String? si, String? gu, String? dong) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("bulletin_board");
    QuerySnapshot<Map<String, dynamic>> querySnapshot;

    if (si == null) {
      // 도 전체(도 선택 - 시 선택X)
      querySnapshot = await collectionReference
          .where('location_do', isEqualTo: dou)
          .orderBy("date")
          .get();
    } else if (gu == null) {
      // 시 전체(도 선택 - 시 선택 - 구 선택X)
      querySnapshot = await collectionReference
          .where('location_do', isEqualTo: dou)
          .where('location_si', isEqualTo: si)
          .orderBy("date")
          .get();
    } else if (dong == null) {
      // 구 전체(도 선택 - 시 선택 - 구 선택 - 동 선택X)
      querySnapshot = await collectionReference
          .where('location_do', isEqualTo: dou)
          .where('location_si', isEqualTo: si)
          .where('location_gu', isEqualTo: gu)
          .orderBy("date")
          .get();
    } else {
      // (도 선택 - 시 선택 - 구 선택 - 동 선택)
      querySnapshot = await collectionReference
          .where('location_do', isEqualTo: dou)
          .where('location_si', isEqualTo: si)
          .where('location_gu', isEqualTo: gu)
          .where('location_dong', isEqualTo: dong)
          .orderBy("date")
          .get();
    }

    List<Post> posts = [];
    for (var doc in querySnapshot.docs) {
      Post post = Post.fromQuerySnapshot(doc);
      posts.add(post);
    }

    return posts;
  }

/*
  // Select All Containing Keyword(검색)
  Future<List<Post>> searchKeyword(String? keyword) async {
    if (keyword == null) {
      return getPosts();
    }

    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("bulletin_board");
    QuerySnapshot<Map<String, dynamic>> querySnapshot;

    for(var snapshot in collectionReference.docu)
  }
*/
  // UPDATE

  // DELETE
}
