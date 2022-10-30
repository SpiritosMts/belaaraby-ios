import 'dart:io';

import 'package:belaaraby/Home/news/addNews/addVideoDialog/addVideoCtr.dart';
import 'package:belaaraby/Home/news/newsCtr.dart';
import 'package:belaaraby/Home/news/readNews/readVideos/readVideoCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/addItemDialog/addItemCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class ReadVideoView extends StatelessWidget {
  ReadVideoCtr gc = Get.find<ReadVideoCtr>();

  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.height;
    return GetBuilder<ReadVideoCtr>(
        initState: (_) {
          print('## open AddVideoView View');
        },
        dispose: (_) {
          print('## close AddVideoView View');
        },
        builder: (ctr) =>

            Scaffold(
              body: Center(
                child: YoutubePlayer(
                  controller: gc.controller,
                  showVideoProgressIndicator: true,
                  progressColors: const ProgressBarColors(
                    playedColor: yellowCol,
                    handleColor: Colors.grey
                  ),

                    onReady: (){
                      gc.controller.addListener((){
                        print('## ready to play video');
                      });
                    },
                  onEnded: (YoutubeMetaData _md) {
                    gc.controller.seekTo(const Duration(seconds: 0));
                  },

                ),
              ),
            )

    );
  }
}
