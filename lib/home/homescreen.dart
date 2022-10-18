import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/drawer.dart';
import 'package:musicplayer_firstproject/screens/bottom%20play/bottomplay.dart';
import 'package:musicplayer_firstproject/screens/search/screen_search.dart';
import 'package:musicplayer_firstproject/screens/settings/settings.dart';
import 'package:musicplayer_firstproject/screens/songs/screen_library.dart';
import 'package:musicplayer_firstproject/themeProvier.dart';

import '../bottomNav.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _screens = [ScreenLibrary(), ScreenSearch(), ScreenSettings()];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/hmscrn.jpeg'
                : 'assets/hmscr-dark.jpeg',
            key: Key(Theme.of(context).brightness.toString()),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: DrawerScreen(),
          appBar: AppBar(
            centerTitle: true,
            title: Text('Musify.',
                style: GoogleFonts.dancingScript(
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white))),
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Color.fromARGB(255, 174, 169, 254)
                : Color.fromARGB(255, 74, 72, 110),
            iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 254, 254)),
          ),
          bottomNavigationBar: BottomNavBar(),
          body: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, _) {
                return Stack(children: [
                  _screens[updatedIndex],
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.01,
                    bottom: 5,
                    right: MediaQuery.of(context).size.width * 0.01,
                    child: BottomPlay(),
                  )
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
//  drawer: Drawer( 

//         child: ListView(
//           children: [
//             const SizedBox(height: 60 ,
//               child: DrawerHeader(decoration: BoxDecoration( 
//                 color: Colors.blue,
//               ), child: Text("Additional Information",style: TextStyle(fontSize: 25 ),)
//               ),
//             ), 
//               ListTile(
//                 leading:  const Icon(Icons.share,size: 35),
//                 title:  const Text("Share Dukaan App",style: TextStyle(fontSize: 20),),
//                 trailing:  const Icon(Icons.arrow_right_sharp),
//                 onTap: () {  
                 
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.keyboard_alt,size: 35) ,
//                 title: const Text("Change Language",style: TextStyle(fontSize: 20),),
//                 trailing: const Icon(Icons.arrow_right_sharp),
//                 onTap: () {
                  
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.whatsapp,size: 35,) ,
//                 title: const Text("WhatsApp Chat Support",style: TextStyle(fontSize: 20),),
//                 trailing:  Switch(value: true, onChanged: (value) {
                  
//                 },),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.lock_open_outlined ,size: 35,) ,
//                 title: const Text("Privacy Policy",style: TextStyle(fontSize: 20),),
//                 onTap: () {
                  
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.star_border_outlined ,size: 35,) ,
//                 title: const Text("Rate Us",style: TextStyle(fontSize: 20),),
//                 onTap: () {
                  
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.logout ,size: 35,) ,
//                 title: const Text("Sign Out ",style: TextStyle(fontSize: 20),),
//                 onTap: () {
                  
//                 },
//               ) ,
//               SizedBox(height: 345 ,
//               ) ,  
//               Column(
//                 children: [
//                   Text('Version',style: TextStyle(fontSize: 15,letterSpacing: 2 ,color: Colors.grey),),
//                   Text('2.4.2',style: TextStyle(fontWeight: FontWeight.w500 ,  fontSize: 15,letterSpacing: 2 ,color: Color.fromARGB(255, 150, 149, 149))) 
//                 ],
//               ),
                  
//                 ],
//         ),
//       ),