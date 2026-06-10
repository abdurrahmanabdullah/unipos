import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/common/result.dart';
import '../interfaces/storage_datasource.dart';

import 'package:path_provider/path_provider.dart';

class StorageRemoteDataSourceImpl implements StorageDataSource {
  final FirebaseStorage _firebaseStorage;

  StorageRemoteDataSourceImpl(this._firebaseStorage);

  @override
  Future<Result<String>> uploadUserPhoto(String imgPath) async {
    final ref = _firebaseStorage
        .ref()
        .child('user_photos')
        .child('UserImage_${DateTime.now().millisecondsSinceEpoch}.jpg');

    final metadata = SettableMetadata(contentType: 'image/jpeg');

    final taskSnapshot = await ref.putFile(File(imgPath), metadata);

    final url = await taskSnapshot.ref.getDownloadURL();

    return Result.success(data: url);
  }

  @override
  Future<Result<String>> uploadProductImage(String imgPath) async {
    try {
      final file = File(imgPath);
      final directory = await getApplicationDocumentsDirectory();
      
      // Ensure directory exists
      final path = '${directory.path}/flutter_pos_images';
      final imgDir = Directory(path);
      if (!await imgDir.exists()) {
        await imgDir.create(recursive: true);
      }

      final fileName = 'ProductImage_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await file.copy('${imgDir.path}/$fileName');
      
      return Result.success(data: savedImage.path);
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
