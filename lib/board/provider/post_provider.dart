import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostProvider {
  late CollectionReference collectionReference;
  List<Post> posts = [];

  PostProvider({reference}) {
    collectionReference =
        reference ?? FirebaseFirestore.instance.collection("bulletin_board");
  }

  Future<void> fetchPosts() async {
    posts = await collectionReference.get().then((QuerySnapshot results) {
      return results.docs.map((DocumentSnapshot document) {
        return Post.fromSnapShot(document);
      }).toList();
    });
  }
}
