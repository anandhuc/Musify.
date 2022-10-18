import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);  

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    gotohome();
    super.initState();
  }
  @override 
  Widget build(BuildContext context) {
    return Stack(

      children: [Image.asset('assets/splsh.jpeg',width:double.infinity,height: double.infinity ,fit: BoxFit.fill ,)       
      ,Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: 
        
          
            Center(
              child: Column(    children: [
                SizedBox(height: 150   ),
                Image.asset('assets/music-logo-black-and-white-png-21.png',height: 100,width: 100,),
                  Text('Musify.', style: GoogleFonts.dancingScript(  textStyle: TextStyle(fontSize: 50 ,color: Colors.white,fontWeight: FontWeight.w500  )) ),
              
                
                ],
              ),
            ),
            
        
        ),
      ),
    ]);
    
  }

  Future<void> gotohome()async{
  await Future.delayed(Duration(seconds: 3 )); 
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (ctx) =>HomeScreen ()
     )
     );
}
}