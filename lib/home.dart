import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'datos.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Datos>(context);
    final display = MediaQuery.of(context).size;
    if (!provider.cargado) {
      provider.cargarPreferencias();
      provider.cargado = true;
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
                              onChanged: (vaue) => provider.nombre = vaue,
                            ),
                          ),
                          FormWidget(
                            display: display,
                            titulo: 'Cargo:',
                            campo: TextFormField(
                              onChanged: (vaue) => provider.cargo = vaue,
                            ),
                          ),
                          FormWidget(
                            display: display,
                            titulo: 'Email:',
                            campo: TextFormField(
                              onChanged: (vaue) => provider.email = vaue,
                            ),
                          ),
                          FormWidget(
                            display: display,
                            titulo: 'Telefono:',
                            campo: TextFormField(
                              onChanged: (vaue) => provider.telefono = vaue,
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
                                      provider.listaEmpleados[index].telefono ??
                                          ''),
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

class FormWidget extends StatelessWidget {
  const FormWidget(
      {Key? key,
      required this.display,
      required this.titulo,
      required this.campo})
      : super(key: key);

  final Size display;
  final TextFormField campo;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: display.width * 0.1, child: Text(titulo)),
          SizedBox(
            width: display.width * 0.3,
            child: campo,
          ),
        ],
      ),
    );
  }
}
