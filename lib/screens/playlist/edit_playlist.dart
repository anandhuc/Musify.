
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';


class EditPlaylist extends StatelessWidget {
  EditPlaylist({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  final _box = Boxes.getInstance();
  String? _title;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      backgroundColor: Colors.transparent , 
      content: Container(
        width: 300 ,height: 170      ,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10 ),
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,bottom: 10  
              ) , 
               
              
              child: Text(
                "Edit your playlist name.",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 20 ,fontWeight: FontWeight.w500 ,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
               
              ),
              child: Form(
                key: formkey,
                child: TextFormField(
                  initialValue: playlistName,
                  cursorHeight: 25,
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
                            fillColor: Color.fromARGB(74, 211, 213, 255),
                            hintText: "Playlist Name...",
                            hintStyle: TextStyle(fontSize: 20)),
                          
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  onChanged: (value) {
                    _title = value;
                  }, 
                  validator: (value) {
                    List keys = _box.keys.toList();
                    if (value == "") {
                      return "Name required";
                    }
                    if (keys.where((element) => element == value).isNotEmpty) {
                      return "This name already exits";
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15,
                      top: 5,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 20 ,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15,
                      top: 5,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          List playlists = _box.get(playlistName);
                          _box.put(_title, playlists);
                          _box.delete(playlistName);
                          Get.back();
                        }
                      },
                      child: Center(
                        child: Text(
                          "Save",
                          style: GoogleFonts.rubik(
                            color: Colors.white ,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
