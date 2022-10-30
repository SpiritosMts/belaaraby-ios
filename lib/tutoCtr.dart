import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'main.dart';

class TutoController extends GetxController {

double opacityShadow =.8;
//Color colorShadow = Color(0XFFe9dda9);
Color colorShadow = Colors.red;
TextStyle tutoTextStyle = const TextStyle(
    color: Colors.white,
    height: 1.5,
  fontWeight: FontWeight.w500
);
bool hideSkip = true;
AlignmentGeometry alignSkip = Alignment.topCenter;
  @override
  void onInit() {
    print('## onInit TutoController');
  }




  late TutorialCoachMark homeTCM;
  late TutorialCoachMark drawerTCM;
  late TutorialCoachMark productsTCM;
  late TutorialCoachMark itemsTCM;
  late TutorialCoachMark promoteItemTCM;

  ///home
  GlobalKey gpsKey = GlobalKey();
  GlobalKey searchKey = GlobalKey();
  GlobalKey refreshKey = GlobalKey();
  GlobalKey sliderKey = GlobalKey();
  GlobalKey drawedKey = GlobalKey();
  void showHomeTuto(ctx) {
    homeTCM = TutorialCoachMark(
      targets: _homeTargets(),
      colorShadow: colorShadow,
      textSkip: "SKIP",
      alignSkip: alignSkip ,
      hideSkip: hideSkip,
      opacityShadow: opacityShadow,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
    bool showTuto = sharedPrefs!.getBool('homeTuto') == null ? true : sharedPrefs!.getBool('homeTuto')!;
    sharedPrefs!.setBool('homeTuto',false);


    if(showTuto){
      Future.delayed(const Duration(microseconds: 300), () {
        homeTCM.show(context: ctx);
      });
    }  }
  List<TargetFocus> _homeTargets() {
    List<TargetFocus> targets = [];
    ///gps
    targets.add(
      TargetFocus(
        identify: "gpsKey",
        keyTarget: gpsKey,
        paddingFocus: 0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'تعرف على موقعك الحالي بالضغط على زر تحديد الموقع (لابد من تفعيل خاصية GPS الخاصة بالهاتف)',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    ///slider
    targets.add(
      TargetFocus(
        identify: "sliderKey",
        keyTarget: sliderKey,
        shape: ShapeLightFocus.RRect,
        paddingFocus: 5,


        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
               'حدد المسافة القصوى للمحلات التي يرجى اظهارها على الخريطة (60 كم في هذه الحالة)',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    ///search
    targets.add(
      TargetFocus(
        identify: "searchKey",
        keyTarget: searchKey,
        paddingFocus: -2,

        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'ابحث عن أي منتج للمحلات الموجودة بالخريطة',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    ///refresh
    targets.add(
      TargetFocus(
        identify: "refreshKey",
        keyTarget: refreshKey,
        paddingFocus: -2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'قم بإعادة تحديث بيانات المحلات',
                      style: tutoTextStyle
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    ///drawer
    targets.add(
      TargetFocus(
        identify: "drawedKey",
        keyTarget: drawedKey,
        paddingFocus: -6,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'تعرف على المزيد من المميزات الخاصة بالتطبيق (إضافة أو تصفح المتاجر ،الأخبار ...)',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );



    return targets;
  }

  ///drawer
  GlobalKey addStoreKey = GlobalKey();
  GlobalKey myStoresKey = GlobalKey();
  GlobalKey newsKey = GlobalKey();
  void showDrawerTuto(ctx) {
    drawerTCM = TutorialCoachMark(
      targets: _drawerTargets(),
      colorShadow: colorShadow,
      textSkip: "SKIP",
      alignSkip: alignSkip ,

      hideSkip: hideSkip,
      paddingFocus: 0,
      opacityShadow: opacityShadow,

    );
    bool showTuto = sharedPrefs!.getBool('drawerTuto') == null ? true : sharedPrefs!.getBool('drawerTuto')!;
    sharedPrefs!.setBool('drawerTuto',false);

    if( showTuto){

      Future.delayed(const Duration(milliseconds: 300), () {
        drawerTCM.show(context: ctx);
      });
    }
  }
  List<TargetFocus> _drawerTargets() {
    List<TargetFocus> targets = [];

    ///add_store
    targets.add(
      TargetFocus(
        identify: "addStoreKey",
        keyTarget: addStoreKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'أضف متجرك الخاص وذلك بإدخال المعلومات المناسبة الخاصة به',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    ///my_stores
    targets.add(
      TargetFocus(
        identify: "myStoresKey",
        keyTarget: myStoresKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'تصفح جميع المتاجر الخاصة بك',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    ///news
    targets.add(
      TargetFocus(
        identify: "newsKey",
        keyTarget: newsKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'اطلع على أحدث الأخبار والمستجدات',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );




    return targets;
  }

  ///products
  GlobalKey manageKey = GlobalKey();
  GlobalKey promoteKey = GlobalKey();
  GlobalKey addCategKey = GlobalKey();
  void showProductsTuto(ctx) {
    productsTCM = TutorialCoachMark(
      targets: _productsTargets(),
      colorShadow: colorShadow,
      textSkip: "SKIP",
      alignSkip: alignSkip ,
      hideSkip: hideSkip,
      paddingFocus: 0,
      opacityShadow: opacityShadow,

    );
    bool showTuto = sharedPrefs!.getBool('productsTuto') == null ? true : sharedPrefs!.getBool('productsTuto')!;
    sharedPrefs!.setBool('productsTuto',false);

    if(showTuto){

      Future.delayed(const Duration(milliseconds: 300), () {
        productsTCM.show(context: ctx);
      });
    }
  }
  List<TargetFocus> _productsTargets() {
    List<TargetFocus> targets = [];

    ///Manage
    targets.add(
      TargetFocus(
        identify: "manageKey",
        keyTarget: manageKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'تحتوي هذه القائمة على جميع الفئات الخاصة بالمحل',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    ///Promote
    targets.add(
      TargetFocus(
        identify: "promoteKey",
        keyTarget: promoteKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                     'بينما تحتوي هذه على المنتجات التي سيتم عرضها في واجهة المحل',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    ///addCateg
    targets.add(
      TargetFocus(
        identify: "addCategKey",
        keyTarget: addCategKey,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        paddingFocus: 5,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'يمكنك إضافة فئة جديدة بإدخال إسم وصورة اختيارية',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );




    return targets;
  }

  ///items
  GlobalKey addItemKey = GlobalKey();
  void showItemsTuto(ctx) {
    itemsTCM = TutorialCoachMark(
      targets: _itemsTargets(),
      colorShadow: colorShadow,
      textSkip: "SKIP",
      alignSkip: alignSkip ,

      hideSkip: hideSkip,
      paddingFocus: 0,
      opacityShadow: opacityShadow,

    );
    bool showTuto = sharedPrefs!.getBool('itemsTuto') == null ? true : sharedPrefs!.getBool('itemsTuto')!;
    sharedPrefs!.setBool('itemsTuto',false);
    if(showTuto){

      Future.delayed(const Duration(milliseconds: 300), () {
        itemsTCM.show(context: ctx);
      });
    }
  }
  List<TargetFocus> _itemsTargets() {
    List<TargetFocus> targets = [];

    ///addItem
    targets.add(
      TargetFocus(
        identify: "addItemKey",
        keyTarget: addItemKey,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        paddingFocus: 5,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'يمكنك إضافة منتج إلى الفئة الحالية',
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  ///items
  GlobalKey promoteItemKey = GlobalKey();
  void showPromoteItemTuto(ctx) {
    promoteItemTCM = TutorialCoachMark(
      targets: _promoteItemTargets(),
      colorShadow: colorShadow,
      textSkip: "SKIP",
      alignSkip: alignSkip ,
      hideSkip: hideSkip,
      paddingFocus: 0,
      opacityShadow: opacityShadow,

    );
    bool showTuto = sharedPrefs!.getBool('promoteItemTuto') == null ? true : sharedPrefs!.getBool('promoteItemTuto')!;
    sharedPrefs!.setBool('promoteItemTuto',false);
    if(showTuto){
      Future.delayed(const Duration(milliseconds: 300), () {
        promoteItemTCM.show(context: ctx);
      });
    }
  }
  List<TargetFocus> _promoteItemTargets() {
    List<TargetFocus> targets = [];

    ///promote_item
    targets.add(
      TargetFocus(
        identify: "promoteItemKey",
        keyTarget: promoteItemKey,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        paddingFocus: 6,

        contents: [
          TargetContent   (
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "يمكنك إضافة المنتج إلى الواجهة الخاصة بالمحل",
                      style: tutoTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }



}
