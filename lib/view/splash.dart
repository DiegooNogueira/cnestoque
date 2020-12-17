import 'dart:async';

import 'package:cnestoque/view/principal.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        route();
      });
      timer.cancel();
    });
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Principal()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Image.asset(
          "imagens/CNEstoque.png",
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.35,
        ),
      ),
    );
  }
}
