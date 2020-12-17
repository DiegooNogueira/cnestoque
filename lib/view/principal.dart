import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
} 

class _PrincipalState extends State<Principal> {
  String _data="q";

_scan() async{
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE).then((value) => setState(()=>_data = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CNEstoque'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(_data),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
                child: Icon(Icons.qr_code),
                backgroundColor: Colors.green,
                onPressed: () => _scan(),
                )
    );
  }
}