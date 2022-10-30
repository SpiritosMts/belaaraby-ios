
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:get/get.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';


Color selectedTimeBoxColor = yellowCol;
Color unselectedTimeBoxColor = Colors.white24;

const TimeOfDay timeZero = TimeOfDay(hour: 00, minute: 00);
extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
class TimesPickerCtr extends GetxController {

  Map<String, TimeOfDay>? openHours = {
    "mo_o": timeZero,
    "mo_c": timeZero,

    "tu_o": timeZero,
    "tu_c": timeZero,

    "we_o": timeZero,
    "we_c": timeZero,

    "th_o": timeZero,
    "th_c": timeZero,

    "fr_o": timeZero,
    "fr_c": timeZero,

    "sa_o": timeZero,
    "sa_c": timeZero,

    "su_o": timeZero,
    "su_c": timeZero,


  };
  Map<String, bool>? openDays = {
    "mo":true,
    "tu":true,
    "we":true,
    "th":true,
    "fr":true,
    "sa":true,
    "su":false,
  };
  Map<String, String> get openHoursString => openHours!.map((key, value) => MapEntry(key, value.to24hours()));

  //Map<String, String> openHoursString = openHours.map((key, value) => MapEntry(key, value.to24hours()));

  @override
  void onInit() {
    print('## onInit TimesPickerCtr');
  }
  // open the picker
  Future<TimeOfDay> openTimePicker(ctx,TimeOfDay time)  async {

    TimeOfDay timeVar = timeZero;
    await Navigator.of(ctx).push(
      showPicker(
        themeData: ThemeData(
          cardColor:blueColHex,


            textTheme: textThemeGlob.apply(
              bodyColor: Colors.white,
            ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: yellowCol
          )
        ),
        accentColor: yellowCol,

        context: ctx,
        displayHeader:false,
        iosStylePicker: true,
        is24HrFormat: true,
        elevation: 5,
        minHour: 0,
        maxHour: 23,
        value: time,
        cancelText: 'Exit'.tr,
        hourLabel: 'hours'.tr,
        minuteLabel: 'minutes'.tr,
        okText: 'Ok'.tr,
        blurredBackground:true,
        barrierDismissible:true,
        minuteInterval: MinuteInterval.ONE,
        onChange: (TimeOfDay newTime){
          timeVar =  newTime;
          update();
        },

      ),
    );
    return timeVar;
  }
  // single time box
  Widget timeWidget(TimeOfDay time ,String weekAbr){
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color:  (openDays![weekAbr]!=null && openDays![weekAbr]==true)?
          selectedTimeBoxColor:
          unselectedTimeBoxColor,
        ),
        borderRadius:const BorderRadius.all(
            Radius.circular(10.0) //
        ),
      ),
      child: Text(
        time.to24hours(),
        textAlign: TextAlign.center,
        //  style: Theme.of(context).textTheme.headline6,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: (openDays![weekAbr]!=null && openDays![weekAbr]==true)?
          selectedTimeBoxColor:
          unselectedTimeBoxColor,
        ),
      ),
    );
  }
  // time row checkbox +arrow +two time box + weekAbr
  Widget weekTimeRow(ctx,String frWeek,String weekAbr){
    return Container(
      padding:const EdgeInsets.only(right: 10,left:20,top: 5,bottom: 5),
      width: MediaQuery.of(ctx).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // week_name_checkBox
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    activeColor: yellowColHex,

                    checkColor: blueColHex,
                    value: openDays![weekAbr],
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                        openDays![weekAbr] = value!;
                        update();
                    },
                  ),
                ),

                Container(
                  child: SizedBox(
                    width: 53,
                    child: Text(

                      "$frWeek :",
                      maxLines: 1,
                      style: const TextStyle(

                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // open_hour
          GestureDetector(
            onTap: () async {
              fieldUnfocusAll();

              if(openDays![weekAbr]!=null && openDays![weekAbr]==true){
                openHours!['${weekAbr}_o'] = await openTimePicker(ctx,openHours!['${weekAbr}_o']??timeZero);
              }
            },
            child: timeWidget(openHours!['${weekAbr}_o']??timeZero, weekAbr),
          ),
          // arrow_icon
          Container(
            child:Icon(
              Icons.arrow_forward,
              color: (openDays![weekAbr]!=null && openDays![weekAbr]==true)?
              selectedTimeBoxColor:
              unselectedTimeBoxColor,
              size: 24.0,
            ) ,
          ),
          // close_hour
          GestureDetector(

            onTap: () async {
              fieldUnfocusAll();

              if(openDays![weekAbr]!=null && openDays![weekAbr]==true) {
                openHours!['${weekAbr}_c'] = await openTimePicker(ctx,openHours!['${weekAbr}_c'] ?? timeZero);
              }
            },
            child: timeWidget(openHours!['${weekAbr}_c']??timeZero, weekAbr),
          ),
        ],
      ),
    );
  }



}
