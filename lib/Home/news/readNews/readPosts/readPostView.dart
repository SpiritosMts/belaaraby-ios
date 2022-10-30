import 'dart:io';

import 'package:belaaraby/Home/news/addNews/addVideoDialog/addVideoCtr.dart';
import 'package:belaaraby/Home/news/newsCtr.dart';
import 'package:belaaraby/Home/news/readNews/readPosts/readPostCtr.dart';
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

class ReadPostView extends StatelessWidget {
  ReadPostCtr gc = Get.find<ReadPostCtr>();
  QueryDocumentSnapshot post = Get.find<NewsCtr>().selectedPost;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ReadPostCtr>(
            initState: (_) {},
            builder: (ctr) {
              Widget itemImage() {
                if (post['image'] != '') {
                  return Image.network(
                    post['image'],
                    fit: BoxFit.cover,
                  );
                }

                return Image.asset(
                  'assets/noImage.jpg',
                  fit: BoxFit.cover,
                );
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(width: width, height: height / 3, child: itemImage()),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                child: Text(post['title'],
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.almarai(
                                      textStyle: const TextStyle(fontSize: 30, color: yellowColHex),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                child: Text(post['date'],
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.almarai(
                                      textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                child: Text(post['desc'],
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.almarai(
                                      textStyle: const TextStyle(fontSize: 20),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
