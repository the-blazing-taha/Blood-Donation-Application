import 'dart:typed_data';
import 'package:blood/views/auth/loginscreen.dart';
import 'package:blood/views/user/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class AuthController{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<Uint8List> pickProfileImage(ImageSource source)async{
    final XFile? file = await _imagePicker.pickImage(source: source);
    if(file!=null){
      return await file.readAsBytes();
    }
    else{
      throw Exception('No image selected!');
    }
  }
  Future<String> createNewUser({
    required String email,
    required String fullName,
    required String password,
    Uint8List? image, // <-- Make it nullable
  }) async {
    String res = 'Error Occurred!';
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? downloadUrl;

      // Only upload image if user provided one
      if (image != null) {
        downloadUrl = await uploadImageToStorage(image);
      }

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'profileImage': downloadUrl ?? '', // Default empty string if no image
        'userId': userCredential.user!.uid,
      });

      res = 'success';
      Get.offAll(Wrapper());
    } catch (e) {
      res = e.toString();
    }
    return res;
  }



  uploadImageToStorage(Uint8List? image)async{
      Reference ref = _storage.ref().child('profileImages').child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
  }


  Future<String> loginUser(String email, String password) async{
      String res= 'some error occured!';
      try{
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }catch (e){
        res = e.toString();
      }
      return res;
  }

  signout()async{
    await FirebaseAuth.instance.signOut();
    Get.offAll(LoginScreen()); // Clears the navigation stack
  }

  reset(String email)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}