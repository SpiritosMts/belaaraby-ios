import 'package:belaaraby/Home/news/ads/addAdsCtr.dart';
import 'package:belaaraby/Home/news/readNews/readPosts/readPostView.dart';
import 'package:belaaraby/Home/news/readNews/readVideos/readVideoView.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:date_format/date_format.dart';

class AddAdsView extends StatefulWidget {
  @override
  State<AddAdsView> createState() => _AddAdsViewState();
}

class _AddAdsViewState extends State<AddAdsView> with TickerProviderStateMixin {
  final AddAdsCtr gc = Get.find<AddAdsCtr>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ads management'.tr),
        bottom: appBarUnderline(),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///add ads btn
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: yellowColHex,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                onPressed: () async {
                  if(gc.adUrl!=''){
                    gc.proposeDeleteAd(context);
                  }else{
                   await gc.showChoiceDialog(context);

                  }
                },
                child: Text(
                  "Add Ads".tr,
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
              ),
            ),

            SizedBox(height: height/4),
            ///ad image
            GetBuilder<AddAdsCtr>(
              builder: (ctr) => StreamBuilder<QuerySnapshot>(
                stream: adsColl.snapshots(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('');
                    }
                    else if (snapshot.hasData) {

                      var ad = snapshot.data!.docs.first;
                      String adUrl = ad.get('adUrl');
                      if(gc.canAffectUrl){
                        gc.adUrl=adUrl;
                        print('## adUrl = <$adUrl>');
                        gc.canAffectUrl =false;
                      }

                      if ( adUrl != '') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.network(
                            adUrl,
                            width: width,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Text('no added ads yet'.tr),
                          ),
                        );
                      }
                    }
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  } else {
                    return Text('no connexion'.tr);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
