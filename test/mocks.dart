import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  FirebaseStorage,
  Reference,
  UploadTask,
  TaskSnapshot,
])
void main() {}
