import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer_firstproject/screens/songs/fav_play.dart';
import 'package:musicplayer_firstproject/screens/songs/screen_songs.dart';

class ScreenLibrary extends StatelessWidget {
  const ScreenLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Column(
      children: [
        Fav_playlist(),
        Expanded(child: 
         ScreenSongs()
        )
      ],
    ));
    
  }
}