import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/controller/audio_controller.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/screens/nowplaying/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenFav extends StatefulWidget {
  const ScreenFav({Key? key}) : super(key: key);

  @override
  State<ScreenFav> createState() => _ScreenFavState();
}

class _ScreenFavState extends State<ScreenFav> {
final _box = Boxes.getInstance();
final favorites= ValueNotifier([]);
final _audioController = AudioController();
List<Audio> songList =[];

  @override
  Widget build(BuildContext context) {


    List _keys = _box.keys.toList();
    if(_keys.where((element) => 
    element=="fav").isNotEmpty){
      favorites.value = _box.get("fav");
    }

    
    return Stack(children: [
     Image.asset(
           Theme.of(context).brightness == Brightness.light    ?
           
         'assets/hmscrn.jpeg'  :'assets/hmscr-dark.jpeg'  
           
         
          ,width: double.infinity ,height: double.infinity ,fit: BoxFit.fill,),
        
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light? 
             Color.fromARGB(255  , 174, 169, 254) :Color.fromARGB(255, 74, 72, 110), 
              
          title: Text(
            'Favorites',
            style: GoogleFonts.dancingScript(fontSize: 25),
          ),
        ),
        body: favorites.value.isNotEmpty?
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ValueListenableBuilder(
            valueListenable: favorites,
            builder: (BuildContext context, List<dynamic> newFavourites, _) {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                tile(context,newFavourites,index) ,
                 separatorBuilder: (ctx, indx) =>
                  SizedBox(height: 10,) ,
                   itemCount: newFavourites.length);
            },
            
          ),
        ):
        ValueListenableBuilder(
          valueListenable: favorites, 
          builder:  (BuildContext context, List<dynamic> list, _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  Icon(Icons.favorite,
                  color: Colors.red,),
                  SizedBox(height: 10,),
                  Text("No Favorites Songs Added.",style: GoogleFonts.dancingScript(
                    fontSize: 30,fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ); 
            
          },)





      ),
    ]);
  }


  
  tile(BuildContext context, List newFavourites, int index) {
    return ListTile(
      onTap: () async{
        songList = _audioController.converterToAudio(newFavourites);
        await _audioController.openToPlayingScreen(songList, index);
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
                        id: favorites.value[index].id,
                         type: ArtworkType.AUDIO,
                         nullArtworkWidget: ClipRRect(
                          child: Image(image: AssetImage("assets/music.png")),
                         ) ),

                  ),),
                  title: Text(
                    newFavourites[index].title,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(newFavourites[index].artist, style: TextStyle(fontSize: 15)),
                  trailing: IconButton(
                      tooltip: 'Remove',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog( 
                            
                            backgroundColor: Theme.of(context).brightness == Brightness.light?
                             Color.fromARGB(255, 211, 207, 248):Color.fromARGB(255, 125, 122, 153), 
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Remove from favorites ? ',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () async{
                                        // remove from playlist function
                                        setState(() {
                                          
                                          favorites.value.removeWhere((element) => 
                                        element.id.toString()== newFavourites[index].id.toString());
                                         _box.put("fav", favorites.value);


          
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1 ),
                                            behavior:SnackBarBehavior.floating ,
                                            width: 160  ,
                                          padding: EdgeInsets.all(15  ),
          
                                            content: Text(
                                                'Removed from Favourites'),
                                          ),
                                        );
                                        });
                                      },
                                      child: Text('Remove',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black))),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.black)))
                                ],
                              )
                            ],
                          ),
                        );
                      }, 
                      icon: Icon(Icons.delete)),
                );
              }
  }
    




  








           
