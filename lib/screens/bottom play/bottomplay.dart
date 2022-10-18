import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer_firstproject/screens/nowplaying/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomPlay extends StatelessWidget {
  BottomPlay({Key? key}) : super(key: key);
  
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  @override
  Widget build(BuildContext context) {
    return _assetsAudioPlayer.builderCurrent(builder: (context, curPlay) {

//       var physicalScreenSize = window.physicalSize;
// var physicalWidth = physicalScreenSize.width;
// var physicalHeight = physicalScreenSize.height;
      return Container(  
        width: MediaQuery.of(context).size.width * 0.9 ,
        decoration: BoxDecoration(
            color:  Theme.of(context).brightness == Brightness.light? 
             Color.fromARGB(255  , 174, 169, 254) :Color.fromARGB(255, 74, 72, 110),
           
             borderRadius: BorderRadius.circular(20)),
        height: 70,
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.end    , 
          children: <Widget>[
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScreenNowPlaying()));
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: QueryArtworkWidget( 
                          artworkFit: BoxFit.fill,
                          id: int.parse(
                              curPlay.audio.audio.metas.id.toString()),
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            child: Image(
                              image: AssetImage("assets/music.png"), 
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 2 ,
                  ),

                  InkWell(
                    onTap: ()async =>await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenNowPlaying(),))  ,
                     child: SizedBox(
                      width: MediaQuery.of(context).size.width *0.39  ,
                       child: Marquee(  
                          text: 
                           curPlay.audio.audio.metas.title.toString(),
                         
                           style: TextStyle(fontSize: 18),
                           scrollAxis: Axis.horizontal,
                           crossAxisAlignment: CrossAxisAlignment.center,
                         
                            
                         
                       ),
                     ),
                   ),
                 
                  // SizedBox(width: 10 , ), 
                  // _assetsAudioPlayer.builderCurrentPosition(
                  //     builder: (context, duration) {
                  //   return Text(getTimeString(duration.inMilliseconds));
                  // })
                ],
              ),
            ),
            Expanded( 
              child: Row(mainAxisAlignment: MainAxisAlignment.end ,
                children: <Widget>[
                   
              //      _assetsAudioPlayer.builderCurrentPosition(
              //         builder: (context, duration) { 
              //       return Text(getTimeString(duration.inMilliseconds));
              //     }),
                  
                  
                  
                  _assetsAudioPlayer.builderCurrent(
                  builder: (context, playing) {
                    return IconButton(
                    onPressed: () async {
                      await _assetsAudioPlayer.previous();
                    },
                    icon: Icon(
                      Icons.skip_previous ,
                      size: 35 ,
                    )); 
                  }
                    
                  ),
                  _assetsAudioPlayer.builderIsPlaying(
                    
                      builder: (context, isPlay) {
                        
                    return isPlay
                        ? IconButton(
                            onPressed: () async {
                              await _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.pause,
                              size: 35,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              await _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              size: 35,
                            ),
                          );
                  }),
                  IconButton(
                    onPressed: () async {
                      await _assetsAudioPlayer.next();
                    },
                    icon: Icon(
                      Icons.skip_next,
                      size: 35,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }
}




























