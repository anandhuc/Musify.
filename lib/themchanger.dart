import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer_firstproject/themeProvier.dart';
import 'package:provider/provider.dart';

class ThemeChangeBotton extends StatelessWidget {
  const ThemeChangeBotton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    

    return Consumer<ThemeProvider>(
      builder: (context, provider, child) => 
       DropdownButton<String>(
        value: provider.currentTheme ,   
        
        items:[ DropdownMenuItem<String>(
          value: 'system',    
          child: Text('System',style: Theme.of(context).textTheme.headline6,)), 
          
          
           DropdownMenuItem<String>(

          
          value: 'light', 
          child: Text('Light',style: Theme.of(context).textTheme.headline6,)),
          DropdownMenuItem<String>(
          value: 'dark',
          child: Text('Dark',style: Theme.of(context).textTheme.headline6,)),
          
          
          ]
         
        
        , onChanged: (String? value){
          provider.changeTheme(value?? 'dark');     
        }), 
    );






  //  return Switch(
  //   value: themeProvider.currentTheme,
  //    onChanged: (value) {
  //    final provider = Provider.of<ThemeProvider>(context,listen: false);
  //    provider.toggleTheme(value);
  //  },);

  }
}