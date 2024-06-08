import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chilled/resources/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectFirebase{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;


  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file,) async {
    // creating location to our firebase storage

    Reference ref =
    storage.ref().child(childName).child(_auth.currentUser!.uid);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
        file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> uploadImageToStorageWork(String childName, Uint8List file,) async {
    // creating location to our firebase storage

    Reference ref =
    storage.ref().child(childName).child(DateTime.now().millisecondsSinceEpoch.toString());

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
        file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
// adding image to firebase storage


//go online here
  void userOnlineOfflineStatus(){
    final presenceRef = FirebaseDatabase.instance.ref().child("linkApp").child("users").child(_auth.currentUser!.uid);

    presenceRef.set({
      'userId': _auth.currentUser!.uid,
      'status': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch
    });

    presenceRef.onDisconnect().set({
      'userId': _auth.currentUser!.uid,
      'status': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch
    });


  }
//go online here

//send message to the firebase chat
  Future<String?> sendMessage({
    required String messages,
    required String senderId,
    required String receiverId,
    required String type,
    required int countValue, required BuildContext context, required String receiverCode,
    bool imageAvailable = false,
    bool audioAvailable  = false
  }) async {
    try {

      final prefs = await SharedPreferences.getInstance();
      final senderCode = prefs.getString('code') ?? "XXXX";

      final message =
      await addMessage(message: messages, senderId: senderId, receiverId: receiverId, type : type,audioAvailable: audioAvailable,imageAvailable: imageAvailable);

      String? returnMessage = "";
      if (message!.contains('sent')) {
        returnMessage =  "sent" ;

        await addConversation(message: messages, senderId: senderId, receiverId: receiverId, type : type,receiverCode: receiverCode, senderCode: senderCode,audioAvailable: audioAvailable,imageAvailable: imageAvailable);


        if(receiverId == Strings.userGPT){


          sendMessageToChatGpt(messages).then((value) async {
            final messaged = await addMessage(message: value, receiverId: senderId, senderId: receiverId, type: type,audioAvailable: audioAvailable,imageAvailable: imageAvailable);

            await addConversation(message: value, senderId: receiverId, receiverId: senderId, type : type, senderCode: receiverCode, receiverCode: senderCode,audioAvailable: audioAvailable,imageAvailable: imageAvailable);

            returnMessage = messaged;


          });


        }

      } else {
        returnMessage = message;
      }

      print(message);


      return returnMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addMessage(
      {
        required String message,
        required String senderId,
        required String receiverId,
        required String type,
        required bool imageAvailable,
        required bool audioAvailable
      }) async {
    try {




      await FirebaseFirestore.instance
          .collection('chats').add({
        'message': message,
        'senderId': senderId,
        'receiverId': receiverId,
        'type': type,
        'imagesStatus': imageAvailable,
        'imagesArray': [],
        'reply': "",
        'replyStatus': false,
        'chatArray': [senderId+receiverId,receiverId+senderId],
        'react': "",
        'reactStatus': false,
        'audio': "",
        'audioStatus': audioAvailable,
        'deleted': false,
        'chatId': DateTime.now().millisecondsSinceEpoch.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });




      return 'sent';
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future<String?> addConversation(
      {
        required String message,
        required String senderId,
        required String receiverId,
        required String type,
        required String senderCode,
        required String receiverCode,
        required bool imageAvailable,
        required bool audioAvailable
      }) async {
    try {


      await FirebaseFirestore.instance
          .collection('conversation')
          .where("conversationArray", arrayContainsAny : [senderId+receiverId,receiverId+senderId])
          .where("type", isEqualTo: type)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) async {
        //Here we get the document reference and return to the post variable.

        if(snapshot.size > 0){
          var batch = FirebaseFirestore.instance.batch();
          //Updates the field value, using post as document reference
          batch.update(snapshot.docs[0].reference, {
            'lastMessage': message,
            'senderId': senderId,
            'senderCode': senderCode,
            'receiverId': receiverId,
            'receiverCode': receiverCode,
            'type': type,
            'imagesStatus': imageAvailable,
            'conversationArray': [senderId+receiverId,receiverId+senderId,senderId,receiverId],
            'audioStatus': audioAvailable,
            'conversationId': snapshot.docs[0].reference.id.toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
          batch.commit();
        }else{
          var conversationId = DateTime.now().millisecondsSinceEpoch;

          await FirebaseFirestore.instance
              .collection('conversation').doc(conversationId.toString()).set({
            'lastMessage': message,
            'senderId': senderId,
            'senderCode': senderCode,
            'receiverId': receiverId,
            'receiverCode': receiverCode,
            'type': type,
            'imagesStatus': imageAvailable,
            'conversationArray': [senderId+receiverId,receiverId+senderId,senderId,receiverId],
            'audioStatus': audioAvailable,
            'conversationId': conversationId.toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
        }

      });



      return 'sent';
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  //bots
  //gpt

  Future<String> sendMessageToChatGpt(String message) async {

    final model = GenerativeModel(model: 'gemini-pro', apiKey: 'AIzaSyDQtvkI6UDp9znJvEXLZ-4y-lsBD73sKb0');

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    var reply = response.text;
    print(reply);

    return reply.toString();
  }
  //gpt





  //bots

  //upload voice note
  uploadAudio({
    required String recordFilePath,
    required String messages,
    required String senderId,
    required String receiverId,
    required String type,
    required int countValue,
    required BuildContext context,
    required String receiverCode,
    bool imageAvailable = false,
    bool audioAvailable  = false}) async {


    Reference reference = storage.ref().child("audio").child('${DateTime.now().millisecondsSinceEpoch}.mp3');



    UploadTask uploadTask = reference.putFile(File(recordFilePath));


    try {
      TaskSnapshot snapshot = await uploadTask;
      var audioURL = await snapshot.ref.getDownloadURL();
      String strVal = audioURL.toString();



      await sendMessage(
          messages: strVal,
          senderId: senderId,
          receiverId: receiverId,
          type: type,
          context: context,
          receiverCode: receiverCode,
          audioAvailable: true,
          countValue: countValue);


    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }
  //upload voice note
//send message to the firebase chat

//push notification
  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  // for getting firebase messaging token
  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        FirebaseFirestore.instance.collection('linkStars').doc(_auth.currentUser!.uid).update({'pushToken': t});
      }
    });
  }




}