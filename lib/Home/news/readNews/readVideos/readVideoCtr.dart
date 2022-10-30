import 'package:belaaraby/Home/news/newsCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReadVideoCtr extends GetxController {

  late YoutubePlayerController controller ;
  QueryDocumentSnapshot video = Get.find<NewsCtr>().selectedVideo;



  void onInit() {
    super.onInit();
    print('## init ReadVideoCtr');
    String videoId='';
    videoId = YoutubePlayer.convertUrlToId(video['url'])!;


    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

  }

  @override
  void onClose() {
    super.onInit();
    print('## close NewsCtr');

    controller.dispose();

  }

}
