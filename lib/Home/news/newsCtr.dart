

import 'package:belaaraby/Home/news/addNews/addPostDialog/addPostView.dart';
import 'package:belaaraby/Home/news/addNews/addVideoDialog/addVideoView.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsCtr extends GetxController{

  late QueryDocumentSnapshot  selectedPost ;
  late QueryDocumentSnapshot  selectedVideo;


  @override
  void onInit() {
    super.onInit();
    print('## init NewsCtr');


  }
  @override
  void onClose() {
    super.onInit();
    print('## close NewsCtr');


  }



  selectPost(post){
    selectedPost=post;
  }
  selectVideo(video){
    selectedVideo=video;
  }

  ///new post
  addPostDialog(ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: blueColHex2,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height / 2,
              width: width,
              child: AddPostView(),
            );
          },
        ),
      ),
    );

    update();
  }
  ///new video
  addVideoDialog(ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: blueColHex2,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height / 3,
              width: width,
              child: AddVideoView(),
            );
          },
        ),
      ),
    );

    update();
  }

  ///delete
  deletePost(ctx,id) {
    MyVoids().shownoHeader(ctx, txt: 'are you sure you want to delete this post?'.tr).then((value) {
      if (value) {
        /// delete garage from coll
        postsColl.doc(id).delete().then((value) async {
          MyVoids().showTos('Post deleted'.tr);

          /// delete all images
          await FirebaseStorage.instance.ref("posts/$id").listAll().then((value) {
            value.items.forEach((element) {
              FirebaseStorage.instance.ref(element.fullPath).delete();
            });
          });
          //Get.back();

        }).catchError((error) => print("Failed to delete post: $error"));
      }
    });
  }
  deleteVideo(ctx,id) {
    MyVoids().shownoHeader(ctx, txt: 'are you sure you want to delete this video?'.tr).then((value) {
      if (value) {
        /// delete garage from coll
        postsColl.doc(id).delete().then((value) async {
          MyVoids().showTos('Video deleted'.tr);

        }).catchError((error) => print("Failed to delete post: $error"));
      }
    });
  }


}