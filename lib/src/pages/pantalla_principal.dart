import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:appcall/src/audio/lista_grabaciones.dart';
import 'package:appcall/src/audio/grabaciones.dart';

class PantallaInicial extends StatefulWidget {
  static String id = 'pantalla_inicial';
  final String _title;

  const PantallaInicial({Key key, @required String title})
      : assert(title != null),
        _title = title,
        super(key: key);

  @override
  _PantallaInicialState createState() => _PantallaInicialState();
}

class _PantallaInicialState extends State<PantallaInicial> {
  TextEditingController _numerocel = new TextEditingController();
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;

  @override
  void initState() {
    super.initState();
    records = [];
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    fileStream = null;
    appDirectory = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: RecordListView(
                  records: records,
                ),
              ),
              Expanded(
                flex: 1,
                child: RecorderView(
                  onSaved: _onRecordComplete,
                ),
              ),
              Flexible(
                child: Image.asset(
                  'img/calli.png',
                  height: 300.0,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              _numero(),
              SizedBox(
                height: 30.0,
              ),
              //_botonGrabar(),
              SizedBox(
                height: 0,
              ),
               _botonLlamar(),
            ],
          ),
        ),
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }

  Widget _numero() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 60.0),
          child: TextField(
            controller: _numerocel,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              icon: Icon(Icons.call_made),
              hintText: 'Ingrese su número por favor',
              labelText: 'Número a llamar',
            ),
            onChanged: (value) {
              //Aquí se guarda el número ingresado
            },
          ),
        );
      },
    );
  }

  Widget _botonGrabar() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text(
              'GRABAR',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10.0,
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: () {});
    });
  }

  Widget _botonLlamar() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text(
              'LLAMAR',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10.0,
          color: Colors.greenAccent,
          textColor: Colors.black,
          onPressed: () async {
            FlutterPhoneDirectCaller.callNumber(_numerocel.text);
          });
    });
  }
}
