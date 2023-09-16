import 'package:flutter/material.dart';
import 'package:snap_example/constant/dimens.dart';
import 'package:snap_example/screen/map_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
             style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(double.infinity,58)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.medium.toDouble())))
            ,elevation:MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
          return    states.contains(MaterialState.pressed)?
           Color.fromARGB(255, 13, 220, 141)  : Color.fromARGB(255, 2, 207, 36);
            }
            
            
            )  )


        )
      ),
      home: const MyHomePage(),
    );
  }
}



