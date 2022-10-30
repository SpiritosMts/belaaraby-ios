

import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImagesScroll extends StatefulWidget {
  List<String> imageList =[];

   ImagesScroll({Key? key, required this.imageList}) : super(key: key);

  @override
  State<ImagesScroll> createState() => _ImagesScrollState();
}

class _ImagesScrollState extends State<ImagesScroll> {
  // List<String> imageList =[
  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_zuAhx0-haR0q2M7VxciZDNv9iW6kVAWoSg&usqp=CAU',
  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_zuAhx0-haR0q2M7VxciZDNv9iW6kVAWoSg&usqp=CAU',
  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_zuAhx0-haR0q2M7VxciZDNv9iW6kVAWoSg&usqp=CAU',
  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_zuAhx0-haR0q2M7VxciZDNv9iW6kVAWoSg&usqp=CAU',
  // ];

  //images
  var pageController = PageController(viewportFraction: .8, initialPage: 0);
  int activePage = 0;
  @override
  void initState() {
    super.initState();

    /// to scroll from end
    // pageController = PageController(viewportFraction: .8, initialPage: widget.imageList.length-1);
    // activePage =  widget.imageList.length-1;
  }
  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: currentIndex == index ? yellowColHex : yellowColHex.withOpacity(.2), shape: BoxShape.circle),
      );
    });
  }
  //
  Widget scrollImages(List<String> images,{bool showIndi =true}){

    print('update imageScroll: activeImageIndex=> $activePage');
    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: 200,
            child: PageView.builder(
                controller: pageController,
                itemCount: images.length,
                pageSnapping: true,
                onPageChanged: (page) {
                  setState(() {
                    activePage = page;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Image.network(
                          height: 500,
                          images[pagePosition],
                          fit: BoxFit.cover,
                        ),
                        // make img controllable
                        onTap: () => Get.dialog(
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                              child: PinchZoom(
                                resetDuration: const Duration(minutes: 1),
                                maxScale: 2.5,
                                child: Image.network(images[pagePosition]),
                              ),
                            ),
                            barrierDismissible: false,
                            useSafeArea: true),
                      ));
                }),
          ),
        ),
        if(showIndi)
        Row(mainAxisAlignment: MainAxisAlignment.center, children: indicators(images.length, activePage)),
        //divider

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return scrollImages(widget.imageList);
  }
}
