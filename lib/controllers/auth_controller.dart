import 'dart:typed_data';
import 'package:blood/views/user/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class AuthController{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<String> createNewUser(String email, String fullName, String password, Uint8List? image) async{
    String res = 'Error Occured!';
    try{
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        Get.offAll(const Wrapper());
        String downloadUrl = await uploadImageToStorage(image);
        await firestore.collection('userdata').doc(userCredential.user!.uid).set({
          'fullName' : fullName,
          'profileImage': downloadUrl,
          'email' : email,
          'buyerId' : userCredential.user!.uid,
        });
        res = 'success';
    }
    catch(e){
        res = e.toString();
    }
    return res;
  }


  uploadImageToStorage(Uint8List? image)async{
      Reference ref = _storage.ref().child('profileImage').child(_auth.currentUser!.uid);
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

  resetPassword(String email)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  signout()async{
    await FirebaseAuth.instance.signOut();
  }

  reset(String email)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}