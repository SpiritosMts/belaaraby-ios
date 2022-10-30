
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
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'newsCtr.dart';
import 'package:date_format/date_format.dart';

class NewsView extends StatefulWidget {
  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> with TickerProviderStateMixin {
  final NewsCtr gc = Get.find<NewsCtr>();

  late TabController _tcontroller;
  final List<String> titleList = [
    "Posts".tr,
    "Videos".tr,
  ];
  bool showButtons =Get.arguments['showButtons'];

  String currentTitle = 'News'.tr;

  @override
  void initState() {
    super.initState();

    currentTitle = titleList[0];
    _tcontroller = TabController(length: 2, vsync: this);
    _tcontroller.addListener(changeTitle); // Registering listener
  }
  @override
  void dispose() {
    _tcontroller.dispose();
    super.dispose();
  }
  void changeTitle() {
    setState(() {
      currentTitle = titleList[_tcontroller.index];
    });
  }



  postCard(post,ctx){

    return GestureDetector(
      onTap: () {
         gc.selectPost(post);
         Get.to(() => ReadPostView());
      },
      child: Stack(
        children: [
          SizedBox(
            width: 100.w,
           // height: height/1.8,
            height: 50.h,
            child: Card(
              color: blueColHex2,
             // semanticContainer: true,
              //clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              //elevation: 10,
              //color: Colors.white24,
              shadowColor: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    ///image
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: blueColHex2, borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 100.w,
                          height: 33.h,
                          //size: Size.fromRadius(30),
                          child: post['image'] != ''
                              ? Image.network(
                            post['image']!,
                            fit: BoxFit.cover,
                          )
                              : Image.asset('assets/noImage.jpg'),
                        ),
                      ),
                    ),
                    ///title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Container(
                          child: Text(  post['title'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,

                              maxLines: 1,
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(fontSize: 19,                        color: yellowColHex
                                ),
                              )),
                        ),
                      ),
                    ),
                    ///date
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Container(
                          child: Text(  post['date'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,

                              maxLines: 1,
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(
                                  height: 1.7,
                                    fontSize: 13,
                                    color: Colors.white30
                                ),
                              )),
                        ),
                      ),
                    ),
                    ///desc
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Container(
                          child: Text( post['desc'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,

                              maxLines: 2,
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(
                                    fontSize: 13,
                                  height: 1.5,

                                ),
                              )),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          ///delete
          if(showButtons)
          Positioned(
              top: 15,
              left: 15,

              child:SizedBox(
                width:50,
                height:50,
                child: MaterialButton(
                  onPressed: () {
                    gc.deletePost(ctx,post['id']);
                  },
                  color: blueColHex2,
                  textColor: yellowColHex,
                  // padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                  child:const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                ),
              )


          ),

        ],
      ),
    );

  }
  videoCard(video,ctx){

    return GestureDetector(
      onTap: () {
        gc.selectVideo(video);
        Get.to(() => ReadVideoView());
      },
      child: Stack(
        children: [
          SizedBox(
            width: 100.w,
           // height: height/1.8,
            height: 50.h,
            child: Card(
              color: blueColHex2,

              // semanticContainer: true,
              //clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              //elevation: 10,
              //color: Colors.white24,
              shadowColor: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    ///video thumbnail
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      decoration: BoxDecoration(color: blueColHex2, borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 100.w,
                          height: 33.h,
                          //size: Size.fromRadius(30),
                          child: video['url'] != ''
                              ? Image.network(
                            'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(video['url'])!}/0.jpg',
                            fit: BoxFit.cover,
                          )
                              : Image.asset('assets/noImage.jpg'),
                        ),
                      ),
                    ),
                    ///title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Container(
                          child: Text(  video['title'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,

                              maxLines: 1,
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(
                                    fontSize: 19,
                                    color: yellowColHex
                                ),
                              )),
                        ),
                      ),
                    ),
                    ///date
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Container(
                          child: Text(  video['date'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,

                              maxLines: 1,
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(
                                  height: 1.7,
                                    fontSize: 13,
                                    color: Colors.white30
                                ),
                              )),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          ///delete
          if(showButtons)
          Positioned(
              top: 15,
              left: 15,

              child:SizedBox(
                width:50,
                height:50,
                child: MaterialButton(
                  onPressed: () {
                    gc.deleteVideo(ctx,video['id']);
                  },
                  color: blueColHex2,
                  textColor: yellowColHex,
                 // padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                  child:const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                ),
              )


          ),

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            unselectedLabelColor: hintYellowColHex,
            labelColor: yellowColHex,
            controller: _tcontroller,
            isScrollable: false,
            indicatorColor: yellowColHex,
            indicatorWeight: 4,
            tabs:  [
              Tab(icon:Text(titleList[0])),
              Tab(icon:Text(titleList[1])),
            ],
          ),
          title: Text(currentTitle),
          centerTitle: true,
        ),
        body: TabBarView(
          controller: _tcontroller,
          children: [
            /// posts screen
            SafeArea(
              child: GetBuilder<NewsCtr>(
                builder: (ctr) => SingleChildScrollView(
                  child: Column(children: [
                    ///add post btn
                    if(showButtons)
                      Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:yellowColHex,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () {


                          gc.addPostDialog(context);


                        },
                        child: Text(
                          "Add post".tr,
                          style: TextStyle(color: Theme.of(context).backgroundColor),
                        ),
                      ),
                    ),
                    ///posts list
                    StreamBuilder<QuerySnapshot>(
                      stream: postsColl.snapshots(),
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

                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            var posts = snapshot.data!.docs;
                            //print('## posts found ${posts.length}');

                            if(posts.isNotEmpty){
                              return  ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  shrinkWrap: true,
                                  itemCount: posts.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    QueryDocumentSnapshot  post = posts[index];

                                    return postCard(post,context);
                                  });
                            }else{
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  child: Text('no added posts yet'.tr),
                                ),
                              );
                            }
                            return Text('data founddd');
                          } else {
                            return  Text('empty data'.tr);
                          }
                        } else {
                          return  Text('no connexion'.tr);
                        }
                      },
                    ),

                  ]),
                ),
              ),
            ),

            /// videos screen
            SafeArea(
              child: GetBuilder<NewsCtr>(
                builder: (ctr) => SingleChildScrollView(
                  child: Column(children: [
                    ///add video btn
                    if(showButtons)
                      Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:yellowColHex,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () {


                          gc.addVideoDialog(context);


                        },
                        child: Text(
                          "Add video".tr,
                          style: TextStyle(color: Theme.of(context).backgroundColor),
                        ),
                      ),
                    ),

                    ///videos list
                    StreamBuilder<QuerySnapshot>(
                      stream: videosColl.snapshots(),
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

                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            var videos = snapshot.data!.docs;
                            //print('## posts found ${posts.length}');

                            if(videos.isNotEmpty){
                              return  ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  shrinkWrap: true,
                                  itemCount: videos.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var  post = videos[index];

                                    return videoCard(post,context);
                                  });
                            }else{
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  child: Text('no added videos yet'.tr),
                                ),
                              );
                            }
                          } else {
                            return  Text('empty data'.tr);
                          }
                        } else {
                          return  Text('no connexion'.tr);
                        }
                      },
                    ),

                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
