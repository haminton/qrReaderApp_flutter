import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';

import 'package:qrreaderapp/src/utils/util.dart' as utils;

class DireccionesPage extends StatelessWidget {

  final scanBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scanBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scanBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(),);
        }

        final scan = snapshot.data;

        if ( scan.length == 0) {
          return Center(child: Text('No hay registros'),);
        }

        return ListView.builder(
          itemCount: scan.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) => scanBloc.borrarScan( scan[i].id ),
            background: Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Eiminar', style: TextStyle(color: Colors.white),),
                    Text('Eiminar', style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              color: Colors.red[300],
            ),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Colors.deepPurple,),
              title: Text(scan[i].valor),
              subtitle: Text('ID: ${ scan[i].id }'),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () => utils.abrirScan(context, scan[i]),
            ),
          )
        );
      }
    );
  }
}









