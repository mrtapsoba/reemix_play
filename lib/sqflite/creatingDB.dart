import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import '../https/login.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'clientP.dart';

class R69MIXDB {
  R69MIXDB._();
  static final R69MIXDB r69mixDB = R69MIXDB._();
  static Database databaseR;

  Future<Database> get dataBR69mix async {

    WidgetsFlutterBinding.ensureInitialized();

    if (databaseR != null) {
      return databaseR;
    }
    
    databaseR = await initDBR();
    return databaseR;
  }

  initDBR() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "R69MIXDB.r69mixDB");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (r69mixDB){},
      onCreate: (Database r69mixDB, int version) async {

        await r69mixDB.execute ("CREATE TABLE client ("
          "identifiant INTEGER PRIMARY KEY,"
          "email TEXT,"
          "pseudo TEXT,"
          "password TEXT,"
          "nom TEXT,"
          "phone INTEGER,"
          "date INTEGER"
        ")");
        
        await r69mixDB.execute("INSERT INTO client("
        "identifiant, email, pseudo, password, nom, phone, date)"
        " VALUES(?, ?, ?, ?, ?, ?, ?)",
        [0, "info@rifkastore.com", "Rifka Store", "TRP", "Taps", 56906666, 2020]
        );
/*
        await r69mixDB.execute("INSERT INTO client("
        "identifiant, email, pseudo, password, nom, phone, date)"
        " VALUES(?, ?, ?, ?, ?, ?, ?)",
        [2, "info@reemix.com", "69 Streming", "pass", "Taps", 56906666, 2020]
        );
*/
      }
    );
  }

  insertConnect(Connect compte) async {
    final dbR = await this.dataBR69mix;
    var requeteA = await dbR.rawInsert("INSERT INTO client (identifiant, email, pseudo, password, nom, phone, date)"
    " VALUES (?, ?, ?, ?, ?, ?, ?)",
    [compte.identifiant, compte.email, compte.pseudo, compte.password, compte.nom, compte.phone, compte.date]);

    return requeteA;
  }

  delConnect(int id) async {
    final dbR = await this.dataBR69mix;
    dbR.delete("client",where: "identifiant = ?",whereArgs: [id]);
  }

  // *******************************************

  // *********    Connection     ***************

  Future<List<ClientMoi>> user() async {
    final dbR = await dataBR69mix;

    List<Map> resultats = await dbR.query("client");
    List<ClientMoi> comptes = [];
    resultats.forEach((pro){
      ClientMoi pArticle = ClientMoi.sqflite(pro);
      comptes.add(pArticle);
    });
    return comptes;
  }

  

}
