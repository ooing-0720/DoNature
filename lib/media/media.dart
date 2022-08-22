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

    var image = await ImagePicker()
        .pickImage(source: source, imageQuality: 50, maxWidth: 150);

    //var stopwatch = Stopwatch()..start();
    io.File? imageFile = io.File(image!.path);

    final ref =
        FirebaseStorage.instance.ref().child('post_image').child(title + 'jpg');
    await ref.putFile(imageFile);
    await UploadTask;

    final url = await ref.getDownloadURL();

    // print(stopwatch.elapsed);
    // print("****************************************");
    return url;
  }

  // FireStore에서 이미지 찾기
  Future downloadImage(String title) async {
    final ref =
        FirebaseStorage.instance.ref().child('post_image').child(title + 'jpg');

    final url = await ref.getDownloadURL();
  }
}
