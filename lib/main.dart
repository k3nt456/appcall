import 'package:appcall/src/pages/pantalla_principal.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(Recorder());

class Recorder extends StatelessWidget {
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      title: 'Grabador de llamadas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: PantallaInicial.id,
      routes: {
        PantallaInicial.id : (context) => PantallaInicial(
          title: 'Grabar voz',
        ),
      },
    );
  }
}

