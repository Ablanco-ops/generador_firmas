import 'package:flutter/material.dart';
import 'package:generador_firmas/common.dart';
import 'package:provider/provider.dart';

import 'datos.dart';

class SeparadorScreen extends StatelessWidget {
  const SeparadorScreen({Key? key}) : super(key: key);
  static const routeName = '/SeparadorScreen';

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;
    final provider = Provider.of<Datos>(context);
    if (!provider.cargadoSep) {
      provider.cargarPreferencias();
      provider.cargadoSep = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Separadores'),
        leading: BackButton(
          onPressed: () {
            provider.guardarSeparadores();
            provider.cargadoSep = false;
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: Card(
        child: Container(
          width: display.width * 0.3,
          height: display.height * 0.5,
          margin: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                SepWidget(
                    display: display,
                    titulo: 'Nombre',
                    campo: TextFormField(
                        initialValue: provider.nombreSep,
                        onChanged: ((value) => provider.nombreSep = value))),
                SepWidget(
                    display: display,
                    titulo: 'Cargo',
                    campo: TextFormField(
                        initialValue: provider.cargoSep,
                        onChanged: ((value) => provider.cargoSep = value))),
                SepWidget(
                    display: display,
                    titulo: 'Email',
                    campo: TextFormField(
                        initialValue: provider.emailSep,
                        onChanged: ((value) => provider.emailSep = value))),
                SepWidget(
                    display: display,
                    titulo: 'Teléfono',
                    campo: TextFormField(
                        initialValue: provider.telefonoSep,
                        onChanged: ((value) => provider.telefonoSep = value)))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
