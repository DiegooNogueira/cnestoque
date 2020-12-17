import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String _data = "q";

  var settings = mysql.ConnectionSettings(
      host: "localhost", port: 3306, user: "root", password: "", db: "teste");

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) async {
      setState(() {
        _data = value;
      });
    }).catchError((error) => setState(() => _data = "Error"));
  }

  Future addProduct() async {
    var conn = await mysql.MySqlConnection.connect(settings);
    await conn.query("SELECT * FROM users").then((data) => {print(data)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CNEstoque'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_data),
              RaisedButton.icon(
                label: Text("Enviar"),
                icon: Icon(Icons.check),
                onPressed: () async => await addProduct(),
              )
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          onPressed: () async => await _scan(),
        ));
  }
}
