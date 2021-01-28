import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';

import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/util.dart' as utils;


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scanBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete_forever), 
          onPressed: scanBloc.borrarScansTodos
        )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _bottonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQr(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQr(BuildContext context) async {

    //https://www.uplabs.com/
    //geo:40.81263886394761,-74.24764051875003

    //String futureString = '';
    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
        futureString = e.toString();
    }

    if (futureString != null) {
      final scan = ScanModel( valor: futureString );
      scanBloc.agregarScan(scan);

      if ( Platform.isIOS ) {
        Future.delayed(Duration(microseconds: 750), () {
          utils.abrirScan( context, scan );
        });
      } else {
        utils.abrirScan(context, scan);
      }
    }
  }

  Widget _callPage(int paginaActual) {

    switch(paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default: return MapasPage();
    }
  }

  Widget _bottonNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}