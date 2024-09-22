import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NodeCard extends StatelessWidget {
  final question;
  final count;
  final value;
  const NodeCard({Key? key, this.question, this.count, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom( //Designing the button
                fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.9,
                    MediaQuery.of(context).size.height * 0.8),
                backgroundColor: Colors.black, //Card background colour
                side: const BorderSide(
                    width: 5.0, color: Color((0xff8758ff))),//Card border colour
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0))),
            onPressed: () {},
            child: Column(children: [ //Column instead of stack for auto resising based on the question length
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: Text(count.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 56,
                        decoration: TextDecoration.underline,

                      ))),
              Padding( //Question from the node
                  padding: EdgeInsets.all(0),
                  child: Text(
                      question,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                      ))),
              Padding(padding: EdgeInsets.all(30),child: Text(textAlign: TextAlign.center,"Current Value:",style: GoogleFonts.poppins(fontSize: 30,fontWeight: FontWeight.w600),)),
              Padding(padding: EdgeInsets.all(5),child: SelectableText(textAlign: TextAlign.center,"${value}",style: GoogleFonts.poppins(fontSize: 30,fontWeight: FontWeight.w600))),
              //Align(alignment: Alignment.bottomRight,child: Text("Yes",textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 20),))
            ])));;
  }
}
