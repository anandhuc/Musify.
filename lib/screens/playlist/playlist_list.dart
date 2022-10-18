

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';
import 'package:musicplayer_firstproject/screens/playlist/edit_playlist.dart';
import 'package:musicplayer_firstproject/screens/playlist/playlist_songs.dart';


class ScreenPLaylist extends StatefulWidget {
  const ScreenPLaylist({Key? key}) : super(key: key);

  @override
  State<ScreenPLaylist> createState() => _ScreenPLaylistState();
}

class _ScreenPLaylistState extends State<ScreenPLaylist> {

final playlistControler = TextEditingController();
final _box = Boxes.getInstance();
List<AllSongsModel>playlist=[];
final formKey= GlobalKey<FormState>();
List allPlaylist=[];
final listenable = ValueNotifier([]);




  @override
  Widget build(BuildContext context) {
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
            'Add your Playlsit',
            style: GoogleFonts.dancingScript (color: Color.fromARGB(255, 255, 255, 255),fontSize: 25 ),
          ),
         
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                tileColor: Color.fromARGB(128, 254, 254, 255), 
                shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                
                leading: Icon(Icons.music_note ,color: Color.fromARGB(255, 0, 0, 0) ,),
                title: Text('Create your playlist ',style:TextStyle(fontWeight: FontWeight.bold) ,),

                onTap: () {
                  showDialog(context: context,
                   builder: (ctx)=>listtile(context));
                },
              ),
              SizedBox(height: 10,),
             ValueListenableBuilder(
              valueListenable: _box.listenable(),
               builder: (BuildContext context, Box newPlayList, _) {
                final allkeys =_box.keys.toList();
                allkeys.remove("allSongs");
                allkeys.remove("fav");
               allkeys.remove("recent");  
                allPlaylist = allkeys.toList();
                return Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(), 
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: ()async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>ScreenPlaylistSongs(
                              titlePlaylist: allPlaylist[index]) ,)); 
                          
                        },
                        leading: Icon(Icons.library_music,color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text(allPlaylist[index]),
                        trailing: Wrap(
                          children: [IconButton(onPressed: (){
                            showDialog(context: context,
                             builder:(context) => EditPlaylist(playlistName:allPlaylist[index]),); 
                          }, icon: Icon(Icons.edit,color: Color.fromARGB(255, 0, 0, 0))),
                            
                            IconButton(
                            icon: Icon(Icons.delete,color: Color.fromARGB(255, 0, 0, 0) ),
                            onPressed: ()async{
                              deletefun(index);
                            }, 
                          ),
             ] ),
                      );
                    }, separatorBuilder: (context, index) =>
                     Divider(
                      indent: 15,
                      endIndent: 15, 
                      color: Colors.black ,
                     ),  itemCount: allPlaylist.length),
                );





                 
               },)

            
            
            
            ],
          )
        ),
      ),
    ]);  
  }

listtile(BuildContext context){
   return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 15,
        sigmaY: 15,
      ),
      child: Dialog(
        backgroundColor: Colors.transparent ,
        child: Container( 
          decoration: BoxDecoration(
               gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ 
             Theme.of(context).brightness == Brightness.light? 
            Color.fromARGB(255, 252, 220, 205):Color.fromARGB(255, 126, 99, 86),
            Theme.of(context).brightness == Brightness.light?

 
             Color.fromARGB(500, 174, 169, 254):
            Color.fromARGB(244, 86, 83, 141)
           ],
        ),
         borderRadius: BorderRadius.circular(15  )
          ),
          width: 300,
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Create Playlist",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 ,color: Color.fromARGB(255, 252, 252, 253) ),
                ),
                SizedBox(
                  height: 10,
                ),


 // textfeild......................................  

                Form(
                    key: formKey,
                    child: SizedBox(
                      height: 50 ,
                      child: TextFormField(
                        
                        maxLines: 1, 
                        controller: playlistControler,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(15 ),
                           borderSide: BorderSide(color: Colors.white ,width: 2  )
                          ), 
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15 )
                          ) ,
                          contentPadding: EdgeInsets.all(15 ) ,
                          
                            filled: true,
                            // suffix: Padding(
                            //   padding: const EdgeInsets.only(top: 5  ),
                            //   child: IconButton(
                            //       onPressed: () {
                            //         playlistControler.clear();
                            //       },
                            //       icon: Icon(Icons.clear)),
                            // ),  
                            fillColor: Color.fromARGB(79, 211, 213, 255),
                            hintText: "Playlist Name...",
                            hintStyle: TextStyle(fontSize: 20)),
                            
                        validator: (value) {
                          
                          List keys = _box.keys.toList();
                          if (value!.isEmpty) {
                            return "Requried*";
                          }
                          if (keys
                              .where((element) => element == value)
                              .isNotEmpty) {
                            return "this name is already exists";
                          }
                        },
                      ),
                    )),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end ,
                  children: [
                    TextButton(
                        onPressed: () {
                          playlistControler.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',style: TextStyle(fontSize: 20 ,color: Color.fromARGB(255, 237, 238, 250)),)),
                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            String playListName = playlistControler.text;
                            _box.put(playListName, playlist);
                            playlistControler.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Create',style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 237, 238, 250) )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
}


  
  deletefun(int index) async {
    return await Get.defaultDialog(
      backgroundColor: Colors.transparent ,
      title: '',
       content:  Container(
        height: 200, 
         decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
           
             Theme.of(context).brightness == Brightness.light? 
            Color.fromARGB(255, 252, 220, 205):Color.fromARGB(255, 126, 99, 86),
            Theme.of(context).brightness == Brightness.light?


             Color.fromARGB(500, 174, 169, 254):
            Color.fromARGB(244, 86, 83, 141)
         ],
        ), 
        borderRadius: BorderRadius.circular(15)), 
          child:
            Column(
              children:[
                SizedBox(height: 10,), 
                CircleAvatar(
                  backgroundColor:Color.fromARGB(500, 174, 169, 254),   
                  child: Center(
                    child: Icon( 
                      Icons.delete,
                      color: Color.fromARGB(255, 78, 77, 77),
                      size: 50,
                    ),
                  ),
                  radius: 40,
                ),
              SizedBox(height: 10,), 
            
           
            Text(
              "Are you sure to delete ?",
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              height: 10,
            ),
            Text( "${allPlaylist[index]}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.clear,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 20 ),
          IconButton(
              onPressed: () async {
                await _box.delete(allPlaylist[index]);
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.done,
                color: Colors.green,
              )) 

              ],
            )

 
        


   ] )));

  }
}



          
      