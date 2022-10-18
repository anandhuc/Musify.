import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/controller/all%20songs/list_all_songs.dart';
import 'package:musicplayer_firstproject/controller/audio_controller.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';
import 'package:musicplayer_firstproject/screens/nowplaying/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({Key? key}) : super(key: key);

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final _myBox = Boxes.getInstance();
  final _audioController =AudioController();
  final _allSongsController = Get.find<AllSongsController>();
  var search =ValueNotifier([]);
  List<AllSongsModel> allSongs = [];
  List<Audio>songList=[];
  @override
  Widget build(BuildContext context) {
    List list =_myBox.get("allSongs");
    allSongs = list.cast<AllSongsModel>();     
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent ,
        body : Padding(
          padding: EdgeInsets.all(10.0) ,
          child: Column(
            children: [
              Container(
                child: TextField(
                  onChanged: (value) {
                    _allSongsController.searchItem =value;
                    _allSongsController.update(["search"]);
                     
                  },
                  decoration:const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(101, 235, 233, 254), 
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20),)
                    )
                    
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: GetBuilder<AllSongsController>(
                  id: "search",
                   builder:(_) {
                    search.value = _allSongsController.searchItem.isEmpty
                    ? allSongs
                    : allSongs.where((element) => 
                    element.title.toLowerCase().
                    contains(_allSongsController.searchItem.toLowerCase())).
                    toList();
                    return search.value.isNotEmpty?
                    ListView.separated(
                      physics: BouncingScrollPhysics() ,
                      itemBuilder: (context, index) {
                        
                        final result=search.value.cast<AllSongsModel>();
                        return showBanner(context,result,index);
                      }, separatorBuilder: (context, index) {
                       return SizedBox(height: 10,);
                      }, itemCount: search.value.length)
                      :Center(
                        child: Text('No Such Songs',style: GoogleFonts.dancingScript( 
                    fontSize: 30,fontWeight: FontWeight.bold 
                        ),),
                      );
                   },)
                   )

            ],
          ),
        ),
      ),

    );
    
  }
  
  Widget showBanner(BuildContext context, List<AllSongsModel> result, int index) {
    return  ListTile( 
       shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  tileColor:Color.fromARGB(80, 245, 246, 247)  ,
              
      leading: Hero(
        tag: index, 
        child: Container(
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: QueryArtworkWidget(
              id: result[index].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Image(
                image: AssetImage("assets/music.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        result[index].title,
        maxLines: 1,
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        
        result[index].artist.toString(),
        style: TextStyle(fontSize: 15),maxLines: 1, 
      ),
      onTap: () async {
        var indx =
            allSongs.indexWhere((element) => element.id == result[index].id);
        songList = _audioController.converterToAudio(allSongs);
        await _audioController.openToPlayingScreen(songList, indx);
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ScreenNowPlaying()),
        );
      },
    );
  }

  dilogBox() {
    return Get.defaultDialog(
        backgroundColor: Colors.black,
        title: "",
        content: Column(
          children: [
            TextButton.icon(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                onPressed: () {},
                label: Text(
                  'Add to Favorites',
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(height: 5,),
            TextButton.icon(
                icon: Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
                onPressed: () {},
                label: Text(
                  'Add to Playlist',
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(height: 5,),
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ));
  }
}
