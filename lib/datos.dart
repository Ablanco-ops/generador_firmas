import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:generador_firmas/common.dart';
import 'package:generador_firmas/empleado.dart';
import 'package:generador_firmas/preferences.dart';
import 'package:html/parser.dart' as parser;

class Datos extends ChangeNotifier {
  File firma = File('');
  File excel = File('');
  String? dirSalida;
  bool cargadoHome = false;
  bool cargadoSep = false;
  String html = '';
  String nombre = '';
  String cargo = '';
  String telefono = '';
  String email = '';

  String nombreSep = '';
  String cargoSep = '';
  String telefonoSep = '';
  String emailSep = '';
  List<Empleado> listaEmpleados = [];
  Map<String, int> listaNombres = {};

  void _readHtml() {
    final doc = parser.parse(firma.readAsBytesSync());
    html = doc.outerHtml;

    notifyListeners();
  }

  Future<void> cargarPreferencias() async {
    firma = File(await Preferences.getPath('firma'));
    dirSalida = await Preferences.getPath('dirSalida');
    nombreSep = await Preferences.getPath('nombreSep');
    cargoSep = await Preferences.getPath('cargoSep');
    emailSep = await Preferences.getPath('emailSep');
    telefonoSep = await Preferences.getPath('telefonoSep');
    notifyListeners();
  }

  void _crearFirma() {
    File editado;
    if (listaNombres.containsKey(nombre)) {
      listaNombres[nombre] = listaNombres[nombre]! + 1;
    } else {
      listaNombres[nombre] = 0;
    }

    if (listaNombres[nombre] == 0) {
      editado = File('$dirSalida\\$nombre.html');
    } else {
      editado = File('$dirSalida\\$nombre${listaNombres[nombre]}.html');
    }
    cargarPreferencias();
    if (nombre != '') {
      nombre = '$nombre$nombreSep';
    }
    if (cargo != '') {
      cargo = '$cargo$cargoSep';
    }
    if (email != '') {
      email = '$email$emailSep';
    }
    if (telefono != '') {
      telefono = '$telefono$telefonoSep';
    }
    html = html
        .replaceFirst('@nombre', nombre)
        .replaceFirst('@cargo', cargo)
        .replaceFirst('@telefono', telefono)
        .replaceAll('@email', email);

    editado.writeAsString(html);
    _readHtml();
  }

  void leerExcel(BuildContext context) {
    var bytes;
    try {
      bytes = excel.readAsBytesSync();
    } catch (e) {
      customSnack('Error al leer Excel', context);
    }
    if (bytes != null) {
      Excel archivo = Excel.decodeBytes(bytes);
      Sheet hoja = archivo[archivo.getDefaultSheet()!];
      listaEmpleados.clear();
      for (int i = 1; i <= hoja.maxRows; i++) {
        if (hoja.cell(CellIndex.indexByString("C$i")).value.contains('@')) {
          String tfno;
          if (hoja.cell(CellIndex.indexByString("D$i")).value.toString() ==
              'null') {
            tfno = '';
          } else {
            tfno = hoja.cell(CellIndex.indexByString("D$i")).value.toString();
          }

          listaEmpleados.add(Empleado(
              nombre: hoja.cell(CellIndex.indexByString("A$i")).value,
              cargo: hoja.cell(CellIndex.indexByString("B$i")).value ?? '',
              email: hoja.cell(CellIndex.indexByString("C$i")).value,
              telefono: tfno));
        }
      }
      if (kDebugMode) {
        print(listaEmpleados);
      }
      notifyListeners();
    }
  }

  void obtenerFirma(BuildContext context) {
    if (firma.path == '') {
      customSnack('Selecciona una firma en Configuracion', context);
    } else if (dirSalida == '') {
      customSnack('Selecciona una carpeta de salida', context);
    } else {
      _readHtml();
      if (listaEmpleados.isEmpty) {
        _crearFirma();
      } else {
        listaNombres.clear();
        for (Empleado empleado in listaEmpleados) {
          nombre = empleado.nombre;
          cargo = empleado.cargo;
          email = empleado.email;
          telefono = empleado.telefono;

          _crearFirma();
        }
      }
    }
    customSnack('Firmas creadas', context);
  }

  Future<void> seleccionarFirma() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['html']);
    if (result != null) {
      await Preferences.setPath('firma', result.files.single.path!);
      firma = File(result.files.single.path!);
      notifyListeners();
    }
  }

  Future<void> seleccionarSalida() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      await Preferences.setPath('dirSalida', result);
      dirSalida = result;
      if (kDebugMode) {
        print(dirSalida);
      }
      notifyListeners();
    }
  }

  Future<void> seleccionarExcel(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      excel = File(result.files.single.path!);
      notifyListeners();
      leerExcel(context);
    }
  }

  void guardarSeparadores() async {
    await Preferences.setPath('nombreSep', nombreSep);
    await Preferences.setPath('cargoSep', cargoSep);
    await Preferences.setPath('emailSep', emailSep);
    await Preferences.setPath('telefonoSep', telefonoSep);
  }
}
