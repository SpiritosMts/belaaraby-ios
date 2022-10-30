import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myLocale/myLocaleCtr.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';

import 'myPacks/myTheme/myThemeCtr.dart';

class MyLocaleView extends StatefulWidget {
  @override
  State<MyLocaleView> createState() => _MyLocaleViewState();
}

class _MyLocaleViewState extends State<MyLocaleView> {
  MyLocaleCtr langGc = Get.find<MyLocaleCtr>();
  MyThemeCtr themeGc = Get.find<MyThemeCtr>();
  bool theme = false;
  bool darkMode = false;
  bool background = false;
  bool notification = false;

  Color _activeSwitchColor = yellowColHex;
  Color _arrowColor = yellowColHex;
  String lang = '';

  @override
  void initState() {
    super.initState();
    print('## initState Settings');

    switch (currLang) {
      case 'ar':
        lang = 'arabic';
        break;
      case 'fr':
        lang = 'french';
        break;
      default:
        lang = 'english';
    }
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  languageList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
          child: Text(
            'choose language'.tr,
            style: GoogleFonts.almarai(
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        ListTile(
          title: Text('english'.tr),
          textColor: yellowColHex,
          onTap: () {
            langGc.changeLang('en');
            setState(() {});
            lang = 'english';
            Get.back();
          },
        ),
        const Divider(
          color: hintYellowColHex,
          thickness: 1,
        ),
        ListTile(
          title: Text('arabic'.tr),
          textColor: yellowColHex,
          onTap: () {
            langGc.changeLang('ar');
            setState(() {});
            lang = 'arabic';
            Get.back();
          },
        ),
        const Divider(
          color: hintYellowColHex,
          thickness: 1,
        ),
        ListTile(
          title: Text('french'.tr),
          textColor: yellowColHex,
          onTap: () {
            langGc.changeLang('fr');
            setState(() {});
            lang = 'french';
            Get.back();
          },
        ),
      ],
    );
  }

  showLanguageDialog(ctx) {
    showDialog(
      barrierDismissible: true,
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
              height: height / 2.5,
              width: width,
              child: languageList(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
        bottom: appBarUnderline(),
      ),
      body: GetBuilder<MyThemeCtr>(
        builder: (_) => SettingsList(

          lightTheme: const SettingsThemeData(
            dividerColor: hintYellowColHex,
            titleTextColor: yellowColHex,
            leadingIconsColor: yellowColHex,
            trailingTextColor: hintYellowColHex2,
            settingsListBackground: blueColHex,
            //settingsSectionBackground: Colors.lightBlueAccent,
            settingsTileTextColor: hintYellowColHex2,
            tileHighlightColor: hintYellowColHex,
          ),

          //shrinkWrap: true,

          //applicationType: ApplicationType.cupertino,
          contentPadding: EdgeInsets.all(11),

          sections: [
            ///common
            SettingsSection(
              //margin: EdgeInsetsDirectional.all(20),
              title: Text('general settings'.tr),
              tiles: [
                SettingsTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _arrowColor,
                  ),
                  title: Text('Language'.tr),
                  value: Text(lang.tr),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {
                    showLanguageDialog(context);
                  },
                ),
                ///dark mode
                // SettingsTile.switchTile(
                //   activeSwitchColor: _activeSwitchColor,
                //   title: Text('Dark Mode'.tr),
                //   leading: const Icon(Icons.dark_mode),
                //   enabled: true,
                //   initialValue: !themeGc.isLightTheme,
                //   onToggle: (val) {
                //     setState(() {
                //       themeGc.onSwitch(val);
                //     });
                //   },
                // ),

                ///other settings
                // SettingsTile.switchTile(
                //
                //     activeSwitchColor: _activeSwitchColor,
                //     title: Text('Custom theme'),
                //     leading: Icon(Icons.format_paint),
                //     enabled: true,
                //     initialValue: theme,
                //     onToggle: (value) {
                //       setState(() {
                //         theme = value;
                //       });
                //     },
                //     onPressed: (value) {}
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// body: Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.center,
//
//
// children: [
// /// langauges
// Column(
// children: [
// //ar
// ElevatedButton(
// onPressed: () {
// langGc.changeLang('ar');
// setState(() {});
// },
// child: Text(
// 'arabic'.tr,
// style: TextStyle(fontSize: 24),
// ),
// ),
// //en
// ElevatedButton(
// onPressed: () {
// langGc.changeLang('en');
// setState(() {});
// },
// child: Text(
// 'english'.tr,
// style: TextStyle(fontSize: 24),
// ),
// ),
// //fr
// ElevatedButton(
// onPressed: () {
// langGc.changeLang('fr');
// setState(() {});
// },
// child: Text(
// 'french'.tr,
// style: TextStyle(fontSize: 24),
// ),
// ),
// ],
// ),
// Text('current lang: <$currLang>'),
//
// ///dark/light mode
// GetBuilder<MyThemeCtr>(
// builder: (_)=>Column(
// children: [
// Switch(
// value: !themeGc.isLightTheme,
// onChanged: (val) {
// themeGc.onSwitch(val);
// },
// ),
// Text(
// 'current theme ${themeGc.isLightTheme ? '<Light>' : '<Dark>'}',
// ),
// ],
// )),
//
//
// ],
// ),
