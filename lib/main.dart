import 'dart:math';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coursework/nodeCard.dart';
import 'dbhandler.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'Node.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent)); //Makes android status bar transparent
  runApp(const MaterialApp(home: splashScreen(), debugShowCheckedModeBanner: false)); //Entry point
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool ended = false;
  late int current;
  late int yesID;
  late int noID;
  double value = 1000000000000000.0;
  String question = "";
  late double yesMultiplier;
  late double noMultiplier;

  var controller = SwipableStackController();
  late int previousNode;
  late double previousValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        changeNode(1);
        previousNode = 0;
        previousValue = value;
      });
    });
  }

  String numberFormatter(number) { //Counts how many commas are in the number, then corresponds that to the appropriate suffix
    List<String> suffixes = [
      "Thousand",
      "Million",
      "Billion",
      "Trillion",
      "Quadrillion",
      "Quintillion"
    ];
    int count = 0;
    for (var char in number.split('')) {
      if (char == ",") {
        count += 1;
      }
    }
    return number.split(',')[0] + " " + suffixes[count - 1];
  }

  void changeNode(id) async { //Queries the id passed to it from the database in order to get the next node's information #event_handler
    Node currentNode = await dbHelper().getNode(id);
    setState(() {
      current = currentNode.NodeID;
      question = currentNode.question;
      yesID = currentNode.yesID;
      noID = currentNode.noID;
      yesMultiplier = currentNode.yesMultiplier;
      noMultiplier = currentNode.noMultiplier;
    });
  }

  void rewind() { // uses the swipeable stack controller to rewind and change the current displayed node information back to the previous one.  #event_handler
    controller.rewind();
    setState(() {
      changeNode(previousNode);
      value = previousValue;
    });
  }

  void showEndScreen(double value) { //takes the final value and creates a comma formatted and a word based value, and passes them both to the end screen. #event_handler
    String formattedValue = NumberFormat.decimalPattern().format(value);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => endScreen(realValue: formattedValue, displayValue: numberFormatter(formattedValue))));
  }

  Widget build(BuildContext context) {
    if (ended == true) { //If this isn't the first time the widget has been built, all value are reset.
      setState(() {
        value = 1000000000000000.0;
        changeNode(1);
      });
    }
    return Scaffold(
        backgroundColor: Color(0xff181818),
        //Background Colour, not seen when using gradient image
        appBar: AppBar(
          title: const Text(
            "IGBH",
            style: TextStyle(fontFamily: 'RubikMonoOne'),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff181818), //Appbar Colour
        ),
        body: Stack(children: [
          Positioned.fill(
              bottom: MediaQuery.of(context).size.height * 0.03,
              child: SwipableStack(
                  horizontalSwipeThreshold: 0.6,
                  allowVerticalSwipe: false,
                  swipeAssistDuration: const Duration(milliseconds: 165),
                  controller: controller,
                  onSwipeCompleted: (index, direction) {

                    if (direction == SwipeDirection.right) {
                      if (current == 35){ //If current node is one of the final 2 end before the final node is drawn
                        ended=true;
                        index=1;
                        showEndScreen(value);
                      }
                      setState(() {
                        previousValue = value; //assigns the value to the previous value variable before operating on it
                        value *= yesMultiplier;
                        previousNode = current;
                      });
                      changeNode(yesID);
                    } else {
                      if (current==34 || current == 35){ //If current node is one of the final 2 end before the final node is drawn
                        ended=true;
                        index=1;
                        showEndScreen(value);
                      }
                      setState(() {
                        previousValue = value;
                        value *= noMultiplier;
                        previousNode = current;
                      });
                      changeNode(noID);
                    }

                  },
                  overlayBuilder: (context, properties) { //Creates the overlay shown before fully swiping
                    double opacity = pow(min(properties.swipeProgress, 1.0), 3).toDouble(); //used to create a curved graph to create a smoother fade in
                    double multiplier = 0.0;
                    if (properties.direction == SwipeDirection.left) { //identifies which way the swipe is leaning and sets the multiplier accordingly
                      multiplier = noMultiplier;
                    }
                    if (properties.direction == SwipeDirection.right) {
                      multiplier = yesMultiplier;
                    }
                    return Opacity( //Definition of the overlay
                        opacity: opacity,
                        child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Center(
                                    child: Text(style: GoogleFonts.poppins(fontSize: 28), NumberFormat.compact( //Function from intl package
                                            locale: 'en-GB').format((value * multiplier - value)))))));
                  },
                  builder: (context, properties) {
                    return NodeCard( //Custom model holding the question, current index and current value
                        question: question,
                        count: properties.index + 1,
                        value: NumberFormat.compact(locale: 'en-GB').format(value));
                  })),


          //Buttons
          Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Color(0xff5CB8E4),
                              width: 3,
                              style: BorderStyle.solid)),
                      width: 75,
                      height: 75,
                      child: FittedBox(
                          child: FloatingActionButton(
                        child: Icon(
                          IconData(0xe318, fontFamily: 'MaterialIcons'),
                          color: Color(0xff8758ff),
                        ),
                        onPressed: () { //Returns to splash screen on pressed #event_handler
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => splashScreen()));
                        },
                        heroTag: "Home",
                        backgroundColor: Colors.black,
                      ))))),
          Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Color(0xff5CB8E4),
                              width: 3,
                              style: BorderStyle.solid)),
                      width: 75,
                      height: 75,
                      child: FittedBox(
                          child: FloatingActionButton(
                        child: Icon(
                          IconData(0xf048, fontFamily: 'MaterialIcons'),
                          color: Color(0xff8758ff),
                        ),
                        onPressed: () { //Rewinds using the stack controller to the last node #event_handler
                          rewind();
                        },
                        heroTag: "Rewind",
                        backgroundColor: Colors.black,
                      )))))
          //right button
        ]));
  }
}

class endScreen extends StatelessWidget {
  endScreen({Key? key, required this.displayValue, required this.realValue}) : super(key: key);
  final String realValue;
  final String displayValue;

  @override
  Widget build(BuildContext context) { //3 Widgets in a Stack
    return Scaffold(
        backgroundColor: Color(0xff181818),
        body: Stack(
          children: [
            Align(
                alignment: Alignment(0, -0.5),
                child: BorderedText(strokeColor: Color(0xff8758ff), strokeWidth: 4.0 ,child: Text(
                    textAlign: TextAlign.center,
                    "The estimated total cost of your planet was:",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic)))),
            Align(
              alignment: Alignment(0,0),
              child: BorderedText(strokeWidth: 4.0, strokeColor: Color(0xff5CB8E4), child: Text(textAlign: TextAlign.center, "\$${realValue}", style: GoogleFonts.poppins(fontSize: 30, color: Colors.black),))
            ),

            Align(
                alignment: Alignment(0,0.3),
                child: BorderedText(strokeWidth: 4.0, strokeColor: Color(0xff5CB8E4), child: Text("(${displayValue})", style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),))
            ),

            Align(
                alignment: Alignment(0, 0.7),
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(width: 2.0, color: Color(0xff5CB8E4)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),fixedSize: Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.width * 0.2)),child: Text("Play again?",style: GoogleFonts.poppins(fontSize: 25),), onPressed: () {Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen()));})),
          ],
        ));
  }
}
