import 'package:donation_nature/board/domain/post.dart';
// import 'package:donation_nature/permission/permission_request.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';

class Media {
  // 핸드폰에서 이미지 선택
  // ImageSource.gallery 또는 ImageSource.camera로 선택 가능
  Future<String> uploadImage(ImageSource source, String title) async {
    // 접근 권한인데 갤럭시는 필요없다함?
    // PermissionRequest.getStoragePermission();

    var image = await ImagePicker().pickImage(
      source: source,

      imageQuality: 70,
      // maxWidth: 200
    );

    io.File? imageFile = io.File(image!.path);

    final ref =
        FirebaseStorage.instance.ref().child('post_image').child(title + 'jpg');
    await ref.putFile(imageFile);
    await UploadTask;

    final url = await ref.getDownloadURL();

    return url;
  }

  Future<String> uploadProfileImage(ImageSource source, String title) async {
    var image = await ImagePicker()
        .pickImage(source: source, imageQuality: 50, maxWidth: 150);

    io.File? imageFile = io.File(image!.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_image')
        .child(title + 'jpg');
    await ref.putFile(imageFile);
    await UploadTask;

    final url = await ref.getDownloadURL();

    return url;
  }

  // FireStore에서 이미지 찾기
  Future<String> downloadImage(String imageUrl) async {
    final ref =
        FirebaseStorage.instance.ref().child('post_image').child(imageUrl);

    final url = await ref.getDownloadURL();
    return url;
    return url;
  }

  Future deleteImage(String title) async {
    FirebaseStorage.instance
        .ref()
        .child('post_image')
        .child(title.hashCode.toString())
        .delete();
  }
}
