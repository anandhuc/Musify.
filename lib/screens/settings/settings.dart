import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musicplayer_firstproject/controller/notifications.dart';
import 'package:musicplayer_firstproject/themchanger.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenSettings extends StatelessWidget {
  ScreenSettings({Key? key}) : super(key: key);
  ValueNotifier<bool> valueswitch = ValueNotifier(true);
bool _enabled = true;
  @override
  Widget build(BuildContext context) {

    var defValue = NotificationUser.getNotifiStatus();
    if(defValue == null){
      valueswitch.value =true;
    }else{
      valueswitch.value =defValue;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(child: 
      Column(
        children: [
          ListTile(
            title: Text('Push Notification',style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400  ) ,),
            trailing: ValueListenableBuilder(
              valueListenable: valueswitch,
               builder: (context, bool newswitchValue, _) {
                return Switch(value: valueswitch.value,
                 onChanged: (value) {
                   valueswitch.value =value;
                   NotificationUser.saveNotification(valueswitch.value);
                   restartNotify();
                 },);
               } ,
          )
        ),
        Divider(
          height: 2 ,
          indent: 20 ,
          endIndent: 20,
        
          thickness: 1 ,
        ),
        ListTile(
          title: Text('Dark Mode',style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400  )),
          trailing: ThemeChangeBotton()
        ),
         Divider(
          height: 2 ,
          indent: 20 ,
          endIndent: 20,
        
          thickness: 1 ,
        ),
        ListTile(
          onTap: () async {
            // go to privacy page
                _privacylaunchUrl();
          },
          title: Text('Privacy',style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400  )),
        ),
         Divider(
          height: 2 ,
          indent: 20 ,
          endIndent: 20,
        
          thickness: 1  ,
        ), 
        ListTile(
          title: Text('Terms and Conditions',style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400  )),
          onTap: () {
            // go to terms and conditions page
            _termsAndConditionslaunchUrl();
          },
        ),
        ],
      )),
    );
  }
       
  void _privacylaunchUrl() async{
     final Uri _url = Uri.parse('https://docs.google.com/document/d/1a20Nm6PedO39r9rimRdVSFlwBTmwGMprrp4APdluW5I/edit?usp=sharing');

   
    if (await launchUrl(_url)){
      throw 'Could not launch $_url';
    }
  }
  
  void _termsAndConditionslaunchUrl() async{

 final Uri _url = Uri.parse('https://docs.google.com/document/d/1o4RJt2XQMEd5kIt9dw1IE9-PAwz2Hi5ZGHSBb8Rv4lk/edit?usp=sharing');

  if (await launchUrl(_url)){
      throw 'Could not launch $_url';
    }

  }
  
  void restartNotify() {
    if (_enabled) {
      _enabled = false;
      Get.snackbar(
        "Mussy",
        "App need restart to change the settings",
        colorText: Color.fromARGB(255, 7, 7, 7),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white 
      );
      Timer(const Duration(seconds: 5), () {
        _enabled = true;
      });
    }
  }
  
} 