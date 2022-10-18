import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer_firstproject/controller/all%20songs/list_all_songs.dart';
import 'package:musicplayer_firstproject/screens/home/homescreen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndexNotifier, 
      builder: (BuildContext ctx, int updatedIndex, Widget? _){
        
        return BottomNavigationBar(
        currentIndex: updatedIndex,
        onTap: (newIndex) {
          HomeScreen.selectedIndexNotifier.value=newIndex;
        },
       
        unselectedFontSize: 10,
        backgroundColor: Theme.of(context).brightness == Brightness.light? 
              Color.fromARGB(255, 228, 225, 254 ) :  Color.fromARGB(255, 52, 50, 62),
        selectedFontSize: 15,
      
        selectedItemColor: Color.fromARGB(244, 127, 118, 248),   
        unselectedItemColor: Color.fromARGB(244, 155, 155, 156), 
        showUnselectedLabels: true,
        elevation: 50  ,
       

        
        items: const[
          BottomNavigationBarItem(icon:
         Icon(Icons.music_note_outlined),
         label: 'Library'),
    
      
      

         BottomNavigationBarItem(icon:
         Icon(Icons.search_sharp),
         label: 'Search'),

         
        

    
         BottomNavigationBarItem(icon:
         Icon(Icons.settings), 
         label: 'Settings'),
         
         
        
        
      ]
      );
      },
      
    );
    
  }
}