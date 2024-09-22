import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bordered_text/bordered_text.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  List<Color> colors = [];
  List<Widget> dots = [];

  void onChanged(int page) { //Redifines the list of colors and rebuilds the widget so the page indicators change color
    setState(() {
      for (Color c in colors) {
        //Changes all colors to black
        colors[colors.indexOf(c)] = Colors.black;
      }
      colors[page] = Color(0xff5CB8E4); //Reverts 1 color to blue
    });
  }

  @override
  Widget build(BuildContext context) {
    if (colors.length <= 0) {
      //gets around the problem of the list not being initialized right away.
      colors = [Color(0xff5CB8E4), Colors.black];
      onChanged(0);
    }
    dots = [
      Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
          child: Container(
              height: MediaQuery.of(context).size.width * 0.04,
              width: MediaQuery.of(context).size.width * 0.04,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff5CB8E4)),
                  color: colors[0],
                  shape: BoxShape.circle))),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
          child: Container(
              height: MediaQuery.of(context).size.width * 0.04,
              width: MediaQuery.of(context).size.width * 0.04,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff5CB8E4)),
                  color: colors[1],
                  shape: BoxShape.circle))),
    ]; //Widget list of the two page indicators at the bottom of the screen



    return Scaffold(
        backgroundColor: Color(0xff181818),
        body: Stack(children: [
          Align(
              alignment: Alignment(0, 0.8),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.95,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: PageView(onPageChanged: onChanged, children: [ //Whenever the page is swiped, onChanged() is called #event_handler
                    Container(
                        //Page 1
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff5CB8E4)),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(children: [
                          Align(
                              alignment: Alignment(0, -0.35),
                              child: BorderedText(
                                strokeWidth: 6.0,
                                strokeColor: Color(0xff8758ff),
                                child: Text("Welcome to",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 40)),
                              )),
                          Align(
                            alignment: Alignment(0,0),
                            child: BorderedText(
                              strokeWidth: 6.0,
                              strokeColor: Color(0xff5CB8E4),
                              child: Text(
                                "Intergalactic Bargain Hunt!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 45
                                ),
                              )
                            )
                          )
                        ])),
                    Container(
                      //Page 2
                      decoration: BoxDecoration( //Creates the blue outline of the page
                          border: Border.all(color: Color(0xff5CB8E4)),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(children: [Align(alignment: Alignment(0,0.7),
                          child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(width: 2.0, color: Color(0xff5CB8E4)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),fixedSize: Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.width * 0.2)),child: Text("Lets go!"), onPressed: () {Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen()));})),

                        Align(alignment: Alignment(0,-0.75), child: BorderedText(strokeColor: Color(0xff8758ff), strokeWidth: 2.0, child: Text("Swipe left for no", style: GoogleFonts.poppins(fontSize: 32, fontStyle: FontStyle.italic)))),
                        Align(alignment: Alignment(0,-0.5), child: Icon(color: Color(0xff8758ff), size: MediaQuery.of(context).size.width * 0.3,IconData(0xe092, fontFamily: 'MaterialIcons', matchTextDirection: true))),

                        Align(alignment: Alignment(0,-0.1), child: BorderedText(strokeColor: Color(0xff5CB8E4), strokeWidth: 2.0, child: Text("Swipe right for yes", style: GoogleFonts.poppins(fontSize: 32, fontStyle: FontStyle.italic)))),
                        Transform.rotate(angle: -math.pi , child: Align(alignment: Alignment(0,-0.3), child: Icon(color: Color(0xff5CB8E4), size: MediaQuery.of(context).size.width * 0.3,IconData(0xe092, fontFamily: 'MaterialIcons'))))
                      ]))]))),


          Align( //Creates the row holding the page indicators
              alignment: Alignment(0, 0.88),
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: dots)))),
        ]));
  }
}
