import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/controller/audio_controller.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/screens/nowplaying/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenRecentPlayed extends StatefulWidget {
  const ScreenRecentPlayed({Key? key}) : super(key: key);

  @override
  State<ScreenRecentPlayed> createState() => _ScreenRecentPlayedState();
}

class _ScreenRecentPlayedState extends State<ScreenRecentPlayed> {
final _box = Boxes.getInstance();
final recent= ValueNotifier([]);
final _audioController = AudioController();
List<Audio> songList =[];




  @override
  Widget build(BuildContext context) {

  List _keys = _box.keys.toList();
    if(_keys.where((element) => 
    element=="recent").isNotEmpty){
      recent.value = _box.get("recent");
    }
      

    
    return Stack(
      children: 
        [
          Image.asset(
        'assets/hmscrn.jpeg',
     width: double.infinity,    height: double.infinity,
        
        fit: BoxFit.fill, 
      ),
          
          Scaffold(
            backgroundColor: Colors.transparent ,
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light? 
             Color.fromARGB(255  , 174, 169, 254) :Color.fromARGB(255, 74, 72, 110)
                ,
            title: Text('Recently played',style: GoogleFonts.dancingScript(color: Colors.white ),) ,
          ),
    
          body: recent.value.isNotEmpty?
          Padding(padding: EdgeInsets.all(8),
          child: ValueListenableBuilder(
            valueListenable: recent,
             builder:(context, List<dynamic> newrecent, child) {
              return ListView.separated(
                itemBuilder: (context, index) {
                 return tile(context,newrecent,index);
                }, 
                separatorBuilder: (context, index) => SizedBox(height: 10,), 
                itemCount: newrecent.length); 
               
             }, ),
            ):
            ValueListenableBuilder(valueListenable: recent,
             builder: (context, List<dynamic> list, child) {
               return Center(
                child: Column(
                  children: [
                    Text('No recent songs')
                  ],
                ),
               );
             },)
        ),
      ],
    );
 
  }
  tile(BuildContext context, List newrecent, int index) {
    return ListTile(
      onTap: () async{
        songList = _audioController.converterToAudio(newrecent);
        await _audioController.openToPlayingScreen(songList,newrecent.length- index-1);
        Navigator.of(context).push(
          MaterialPageRoute(builder: 
          (context) => ScreenNowPlaying(),)
        );
        
      },
                  tileColor: Color.fromARGB(80, 245, 246, 247),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  leading: Container(
                    width: 50, height: 50,
                    child: 
                    ClipRRect(
                      borderRadius:BorderRadius.circular(15),
                      child: QueryArtworkWidget(
                        id: recent.value[newrecent.length- index-1].id,
                         type: ArtworkType.AUDIO,
                         nullArtworkWidget: ClipRRect(
                          child: Image(image: AssetImage("assets/music.png")),
                         ) ),

                  ),),
                  title: Text(
                    newrecent[newrecent.length- index-1].title,
                    style: TextStyle(fontSize: 20),
                    maxLines: 1,
                  ),
                  subtitle: Text(newrecent[newrecent.length- index-1].artist, style: TextStyle(fontSize: 15),maxLines: 1,) ,
                  
                );
              }
  
  














}