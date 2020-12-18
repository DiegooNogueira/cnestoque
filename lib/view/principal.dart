import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String _data = "";
  String _qtd = "";
  String _cdg = "";
  TextEditingController controladorCodigo;
  TextEditingController controladorQtd = TextEditingController();
  //conexao
  var settings = mysql.ConnectionSettings(
      host: "localhost",
      port: 3306,
      user: "sysbda",
      password: "masterkey",
      db: "BASESGMARTER.FDB");

  // funcao de scanear
  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) async {
      setState(() {
        _data = value;
      });
    }).catchError((error) => setState(() => _data = "Error"));
    controladorCodigo = new TextEditingController(text: _data);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Input'),
            content: Column(
              children: [
                formulario(false, "Código", TextInputType.number,
                    controladorCodigo, "Código vazio"),
                formulario(false, "Quantidade", TextInputType.number,
                    controladorQtd, "Quantidade vazio"),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  setState(() {
                    _cdg = controladorCodigo.text;
                    _qtd = controladorQtd.text;
                  });
                  Navigator.pop(context);
                },
                child: Text("Sim"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Não"),
              )
            ],
          );
        });
  }

  // funcao de adicionar
  Future addProduct() async {
    var conn = await mysql.MySqlConnection.connect(settings);
    await conn.query("select * from TESTOQUE").then((data) => {
          data.forEach((element) {
            print(element);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "imagens/CNEstoque.png",
            height: MediaQuery.of(context).size.height * 0.050,
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              _cdg != ""
                  ? Card(
                      child: InkWell(
                        splashColor: Colors.orange[800].withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.96,
                            height: MediaQuery.of(context).size.height * 0.16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Código:",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _cdg,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Quantidade:",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _qtd,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    )
                  : Container(child: null),
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
          backgroundColor: Colors.orange[900],
          onPressed: () async => await _scan(),
        ));
  }
}

Widget formulario(
    bool obscureText,
    String labelText,
    TextInputType keyboardType,
    TextEditingController controller,
    String validator) {
  return TextFormField(
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(labelText: "$labelText"),
    controller: controller,
    validator: (value) {
      if (value.isEmpty) {
        return "$validator";
      }
    },
  );
}
