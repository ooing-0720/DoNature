import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:donation_nature/media/media.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';

class PostService {
  // PostServicer를 factory 생성자로 만들어서 싱글톤으로 사용
  static final PostService _postService = PostService._internal();

  factory PostService() => _postService;

  // 초기화
  PostService._internal();

  // CREATE
  Future createPost(Map<String, dynamic> json) async {
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

    // if (sido == null) {
    //   // 도 전체(도 선택 - 시 선택X)
    //   querySnapshot = await collectionReference
    //       .where('location_si/do', isEqualTo: sido)
    //       .orderBy("date", descending: true)
    //       .get();
    // } else {
    // 시 전체(도 선택 - 시 선택 - 구 선택X)
    querySnapshot = await collectionReference
        .where('location_si/do', isEqualTo: sido)
        .where('location_gu/gun/si', isEqualTo: gugunsi)
        .orderBy("date", descending: true)
        .get();

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
  Future<void> deletePost(Post post) async {
    Media _media = Media();
    _media.deleteImage(post.title!);
    await post.reference?.delete();
  }

  // 파이어베이스에 정보 변경
  Future likePost(Post post, User user) async {
    if (!isLiked(post, user)) {
      // 유저의 관심 목록에 등록
      post.likeUsers!.add(user.email);
    } else {
      // 유저의 관심 목록에서 제거
      post.likeUsers!.remove(user.email);
    }
    await post.reference?.set(post.toJson());
  }

  // 관심글인지 확인
  bool isLiked(Post post, User user) {
    if (post.likeUsers!.contains(user.email) == false) {
      // 관심있어요 누르지 않은 경우(♡)
      return false;
    } else {
      // 관심있어요 이미 누른 경우(♥)
      return true;
    }
  }

  // 채팅방이 만들어진 적이 있는지 확인
  bool isChated(Post post, User user) {
    if (post.chatUsers!.contains(user.email)) {
      // 이미 만들어지 채팅방이 있다면 -> 만들어진 채팅방으로 연결
      return true;
    } else {
      // 처음 채팅하기를 누르는 거라면 -> 채팅방 생성
      return false;
    }
  }
}
