import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer_firstproject/screens/favscreen/screen_favourites.dart';
import 'package:musicplayer_firstproject/screens/playlist/playlist_list.dart';

class Fav_playlist extends StatelessWidget {
  const Fav_playlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenPLaylist(),));
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                Icon(Icons.playlist_add,size: 50 ,),
                Text('Your playlists',style: TextStyle(fontSize: 20 ),)
              ],
            ),
            width: 150,
            height: 150 , 
            decoration: BoxDecoration(
       
               color:Color.fromARGB(80, 241, 242, 245),
              borderRadius: BorderRadius.circular(25) 
            ),
          ),
        ),
         InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenFav(),));
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                Icon(Icons.favorite_border_outlined,size: 50 ,),
                Text('Favorites',style: TextStyle(fontSize: 20 ),)
              ],
            ),
            width: 150,
            height: 150 , 
            decoration: BoxDecoration(
       
              color:Color.fromARGB(80, 241, 242, 245),
              borderRadius: BorderRadius.circular(25) 
            ),
          ),
        ), 
        
       ],
      ),
    );
    
  }
}