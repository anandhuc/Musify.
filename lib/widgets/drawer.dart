import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/screens/recently%20played/recent.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return Drawer(
      width: 270,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).brightness == Brightness.light? 
            Color.fromARGB(255, 252, 220, 205):Color.fromARGB(255, 126, 99, 86),
            Theme.of(context).brightness == Brightness.light?


            Color.fromARGB(244, 154, 147, 249):
            Color.fromARGB(244, 86, 83, 141)
          ], 
        )),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(22, 42, 37, 37),
                ),
                child: Center(
                  child: Text("Musify.", 
                      style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.light? 
                        Color.fromARGB(255, 3, 3, 3):Color.fromARGB(255, 254, 253, 253)
                      ))),
                ),
              ),
            ),
            ListTile(
              
              
                // leading: const Icon(Icons.share, size: 35), 
                title: Text('Recently Played',
                    style: GoogleFonts.amiri(
                        textStyle: TextStyle(
                      fontSize: 20,
                     
                    ))),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ScreenRecentPlayed(),));
                }),
           
            ListTile(
              // leading: const Icon(
              //   Icons.whatsapp,
              // size: 35,
              // ),
              title: Text("Share app",
                  style: GoogleFonts.amiri (
                      textStyle: TextStyle(
                    fontSize: 20,
                    
                  ))),
              onTap: () {},
              
            ),
            ListTile(
              // leading: const Icon(
              //   Icons.star_border_outlined,
              //   size: 35,
              // ),
              title: Text("About Us",
                  style: GoogleFonts.amiri(
                      textStyle: TextStyle(
                    fontSize: 20,
                   
                  ))),
              onTap: () {
                aboutUsUrllaunch();
              },
            ),
            ListTile(
              // leading: const Icon(
              //   Icons.logout,
              //   size: 35,
              // ),
              title: Text("Exit ",
                  style: GoogleFonts.amiri(
                      textStyle: TextStyle(
                    fontSize: 20,
                   
                  ))),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
            Spacer(
              flex: 1,
            ),
            Padding( 
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Version',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 119, 119, 119),
                        letterSpacing: 2),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 119, 119, 119),
                        letterSpacing: 2),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void aboutUsUrllaunch() async {
    final Uri _url = Uri.parse(
        'https://docs.google.com/document/d/1UZmoEzlENJkKdSMjCQUb0wDBoV63z1Loxmw5sJ6p6EE/edit?usp=sharing');

    if (await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
