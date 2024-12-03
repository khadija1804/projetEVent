import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:event/views/auth/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../views/bottom_nav_bar/bottom_bar_view.dart';
import '../views/profile/add_profile.dart';
import 'package:path/path.dart' as Path;

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;

    final cloudinary = Cloudinary.full(
      cloudName: 'dxehtrjk7',
      apiKey: '722922166728159',
      apiSecret: 'qvXPrxB62MDLR_0mkyyuFU6ruqc',
    );

  void login({String? email, String? password}) {
    isLoading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      /// Login Success

      isLoading(false);
      Get.to(() => BottomBarView());
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occured
    });
  }

  void signUp({String? email, String? password}) {
    ///here we have to provide two things
    ///1- email
    ///2- password

    isLoading(true);

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      isLoading(false);

      /// Navigate user to profile screen
      Get.to(() => ProfileScreen());
    }).catchError((e) {
      /// print error information
      print("Error in authentication $e");
      isLoading(false);
    });
  }

  void forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar('Email Sent', 'We have sent password reset email');
    }).catchError((e) {
      print("Error in sending password reset email is $e");
    });
  }

  signInWithGoogle() async {
    isLoading(true);
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      isLoading(false);

      ///SuccessFull loged in
      Get.to(() => BottomBarView());
    }).catchError((e) {
      /// Error in getting Login
      isLoading(false);
      print("Error is $e");
    });
  }


  var isProfileInformationLoading = false.obs;
  Future<String> uploadImageToCloudinary(File file) async {
    try {
      final response = await cloudinary.uploadFile(
        filePath: file.path,
      );

      if (response.isSuccessful) {
        return response.secureUrl ?? '';
      } else {
        print("Error uploading image: ${response.error}");
        return '';
      }
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }
  

  uploadProfileData(String imageUrl, String firstName, String lastName,
      String mobileNumber, String dob, String gender) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'first': firstName,
      'last': lastName,
      'dob': dob,
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(()=> BottomBarView());
    });

  }
  void logout() async {
  try {
    isLoading(true);

    // Sign out from Firebase
    await auth.signOut();

    // Sign out from Google if the user is signed in via Google
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    isLoading(false);

    Get.offAll(() => LoginView()); 
  } catch (e) {
    isLoading(false);
    Get.snackbar('Error', 'Failed to logout: $e');
    print("Error during logout: $e");
  }
}
}
