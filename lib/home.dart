import 'package:flutter/material.dart';
import 'package:generador_firmas/separador_screen.dart';
import 'package:provider/provider.dart';

import 'common.dart';
import 'datos.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Datos>(context);
    final display = MediaQuery.of(context).size;
    if (!provider.cargadoHome) {
      provider.cargarPreferencias();
      provider.cargadoHome = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Generador de Firmas')),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
              child: Text(
            'Configuración',
            style: Theme.of(context).textTheme.headline4,
          )),
          ListTile(
            title: const Text('Plantilla de Firma'),
            subtitle: Text(provider.firma.path),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: provider.seleccionarFirma,
            ),
          ),
          ListTile(
            title: const Text('Carpeta de salida'),
            subtitle: Text(provider.dirSalida ?? 'No seleccionado'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: provider.seleccionarSalida,
            ),
          ),
          ListTile(
            title: const Text('Separadores'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  Navigator.of(context).pushNamed(SeparadorScreen.routeName),
            ),
          ),
        ]),
      ),
      body: Center(
        child: Container(
          width: display.width * 0.5,
          margin: EdgeInsets.symmetric(vertical: display.height * 0.1),
          child: Column(children: [
            Form(
              child: Card(
                child: provider.listaEmpleados.isEmpty
                    ? Column(
                        children: [
                          FormWidget(
                            display: display,
                            titulo: 'Nombre:',
                            campo: TextFormField(
                              onChanged: (value) => provider.nombre = value,
                            ),
                          ),
                          FormWidget(
                            display: display,
                            titulo: 'Cargo:',
                            campo: TextFormField(
                              onChanged: (value) => provider.cargo = value,
                            ),
                          ),
                          FormWidget(
                            display: display,
                            titulo: 'Email:',
                            campo: TextFormField(
                              onChanged: (value) => provider.email = value,
                            ),
                          ),
                          FormWidget(
                            display: display,
                            titulo: 'Telefono:',
                            campo: TextFormField(
                              onChanged: (value) => provider.telefono = value,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: display.height * 0.6,
                        width: display.width * 0.5,
                        child: ListView.builder(
                            itemCount: provider.listaEmpleados.length,
                            itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                      '${provider.listaEmpleados[index].nombre} - ${provider.listaEmpleados[index].cargo}'),
                                  subtitle: Text(
                                      provider.listaEmpleados[index].email),
                                  trailing: Text(
                                      provider.listaEmpleados[index].telefono),
                                )),
                      ),
              ),
            ),
            SizedBox(
              height: display.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () => provider.seleccionarExcel(context),
                    child: const Text('Importar Excel')),
                ElevatedButton(
                    onPressed: () => provider.obtenerFirma(context),
                    child: const Text('Obtener Firma')),
              ],
            )
            // SingleChildScrollView(child: Html(data: provider.html)),
          ]),
        ),
      ),
    );
  }
}
