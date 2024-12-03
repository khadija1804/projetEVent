import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';




import 'dart:convert';

class DataController extends GetxController{


  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot? myDocument;



  var allUsers  = <DocumentSnapshot>[].obs;
  var filteredUsers = <DocumentSnapshot>[].obs;
  var allEvents = <DocumentSnapshot>[].obs;
  var filteredEvents = <DocumentSnapshot>[].obs;
  var joinedEvents = <DocumentSnapshot>[].obs;

  final cloudinary = Cloudinary.full(
      cloudName: 'dxehtrjk7',
      apiKey: '722922166728159',
      apiSecret: 'qvXPrxB62MDLR_0mkyyuFU6ruqc',
    );

  var isEventsLoading = false.obs;


  var isMessageSending = false.obs;
  sendMessageToFirebase({
    Map<String,dynamic>? data,
    String? lastMessage,
    String? grouid
  })async{

   isMessageSending(true);

    await FirebaseFirestore.instance.collection('chats').doc(grouid).collection('chatroom').add(data!);
    await FirebaseFirestore.instance.collection('chats').doc(grouid).set({
      'lastMessage': lastMessage,
      'groupId': grouid,
      'group': grouid!.split('-'),
    },SetOptions(merge: true));

    isMessageSending(false);

  }


  createNotification(String recUid){
    FirebaseFirestore.instance.collection('notifications').doc(recUid).collection('myNotifications').add({
      'message': "Send you a message.",
      'image': myDocument!.get('image'),
      'name': myDocument!.get('first')+ " "+ myDocument!.get('last'),
      'time': DateTime.now()
    });
  }

  getMyDocument(){
    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid)
        .snapshots().listen((event) {
          myDocument = event;
    });
  }
  
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



Future<String> uploadThumbnailToCloudinary(Uint8List file) async {
  String fileUrl = '';
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();

  try {
    // Upload file to Cloudinary
    final response = await cloudinary.uploadFile(
      fileBytes: file,
      resourceType: CloudinaryResourceType.image, // Specify resource type
      folder: 'myfiles', // Optional: specify a folder in Cloudinary
      fileName: '$fileName.jpg', // File name in Cloudinary
    );

    if (response.isSuccessful) {
      fileUrl = response.secureUrl ?? '';
      print("Thumbnail uploaded: $fileUrl");
    } else {
      print("Error uploading thumbnail: ${response.error}");
    }
  } catch (e) {
    print("Error uploading thumbnail: $e");
  }

  return fileUrl;
}



 Future<bool> createEvent(Map<String,dynamic> eventData)async{
   bool isCompleted = false;

   await FirebaseFirestore.instance.collection('events')
   .add(eventData)
   .then((value) {
     isCompleted = true;
     Get.snackbar('Event Uploaded', 'Event is uploaded successfully.',
         colorText: Colors.white,backgroundColor: Colors.blue);
   }).catchError((e){
     isCompleted = false;
   });


   return isCompleted;
 }

 Future<bool> updateEvent(String eventId, Map<String, dynamic> updatedData) async {
  bool isUpdated = false;

  try {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .update(updatedData)
        .then((value) {
      isUpdated = true;
      Get.snackbar('Success', 'Event updated successfully.',
          colorText: Colors.white, backgroundColor: Colors.green);
    });
  } catch (e) {
    isUpdated = false;
    Get.snackbar('Error', 'Failed to update the event.',
        colorText: Colors.white, backgroundColor: Colors.red);
  }

  return isUpdated;
}


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyDocument();
    getUsers();
    getEvents();
  }


  var isUsersLoading = false.obs;

  getUsers(){
    isUsersLoading(true);
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      allUsers.value = event.docs;
      filteredUsers.value.assignAll(allUsers);
      isUsersLoading(false);
     });
  }


  getEvents(){
    isEventsLoading(true);

    FirebaseFirestore.instance.collection('events').snapshots().listen((event) {
      allEvents.assignAll(event.docs);
      filteredEvents.assignAll(event.docs);


    joinedEvents.value =   allEvents.where((e){
        List joinedIds = e.get('joined');

        return joinedIds.contains(FirebaseAuth.instance.currentUser!.uid);

      }).toList();





      isEventsLoading(false);
     });


  }




}