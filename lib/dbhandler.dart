
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Node.dart';


class dbHelper{

  Future<Database> openDB() async {
    Directory dir = await getApplicationDocumentsDirectory(); //Checks where the app is installed for the database
    String path = join(dir.path, 'data.db');

    if (await databaseExists(path) == false) { //If not found (likely first install), the data is read from the database and made into a database usable by flutter.
      ByteData data = await rootBundle.load(join("assets", "data.db"));
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

      return await openDatabase(path, readOnly: true);
    }else{
      return await openDatabase(path, readOnly: true);
    }
  }

  Future<Node> getNode(int id) async{ //Function to query all information from a specific node using SQL.
    Database db = await openDB();
    String query = "select * from Nodes where NodeID = ${id}";
    var response = await db.rawQuery(query);
    List<dynamic> nodeValues = response[0].values.toList(); //Response info is turned into a list.

    Node newNode = Node(nodeValues[0],nodeValues[1],nodeValues[2],nodeValues[3],nodeValues[4],nodeValues[5]); //Turns the response list into a Node object and returns.
    return newNode;

  }

}



