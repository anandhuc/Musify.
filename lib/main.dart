
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_firstproject/controller/all%20songs/list_all_songs.dart';
import 'package:musicplayer_firstproject/controller/notifications.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';
import 'package:musicplayer_firstproject/screens/splashSreen.dart';
import 'package:musicplayer_firstproject/Theme/themeProvier.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationUser.init();
  Hive.registerAdapter(AllSongsModelAdapter());
  await Hive.openBox("songs");
  final box = Boxes.getInstance();
  List _keys = box.keys.toList();
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final allSongsController = AllSongsController();

  try {
    if (!kIsWeb) {
      bool permissionStatus = await onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await allSongsController.fetchDatas();
        await onAudioQuery.permissionsRequest();
      }
    }
  } catch (e) {
    const CircularProgressIndicator();
  }


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown,
  ]);
  

 
  runApp(ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider()..initialize(),
    
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  

  @override
  Widget build(BuildContext context) {  
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
         
       
      return GetMaterialApp( 
        debugShowCheckedModeBanner: false,
        title: 'Musify',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: provider.themeMode,
    
        home: const SplashScreen(),
    
      );
      }
    );
  }
}
