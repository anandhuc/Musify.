import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/widgets/drawer.dart';
import 'package:musicplayer_firstproject/screens/bottom%20play/bottomplay.dart';
import 'package:musicplayer_firstproject/screens/search/screen_search.dart';
import 'package:musicplayer_firstproject/screens/settings/settings.dart';
import 'package:musicplayer_firstproject/screens/songs/screen_library.dart';


import '../../widgets/bottomNav.dart';

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
