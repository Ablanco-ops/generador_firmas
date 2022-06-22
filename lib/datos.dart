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
  bool cargado = false;
  String html = '';
  String nombre = '';
  String cargo = '';
  String telefono = '';
  String email = '';
  List<Empleado> listaEmpleados = [];

  void _readHtml() {
    final doc = parser.parse(firma.readAsBytesSync());
    html = doc.outerHtml;
    if (kDebugMode) {
      print(html);
    }
    notifyListeners();
  }

  void cargarPreferencias() async {
    firma = File(await Preferences.getPath('firma'));
    dirSalida = await Preferences.getPath('firma');
  }

  void _crearFirma(String nombre, String cargo, String email, String telefono) {
    File editado = File('$dirSalida\\$nombre.html');
    html = html
        .replaceAll('@nombre', nombre)
        .replaceAll('@cargo', cargo)
        .replaceAll('@telefono', telefono)
        .replaceAll('@correo', email);
    editado.writeAsString(html);
  }

  void leerExcel(BuildContext context) {
    var bytes;
    try{
      bytes = excel.readAsBytesSync();
      
    }
    catch (e){
      customSnack('Error al leer Excel', context);
    }
    if (bytes !=null){
      Excel archivo = Excel.decodeBytes(bytes);
    Sheet hoja = archivo[archivo.getDefaultSheet()!];
    listaEmpleados.clear();
    for (int i = 1; i <= hoja.maxRows; i++) {
      if (hoja.cell(CellIndex.indexByString("C$i")).value.contains('@')) {
        listaEmpleados.add(Empleado(
            nombre: hoja.cell(CellIndex.indexByString("A$i")).value,
            cargo: hoja.cell(CellIndex.indexByString("B$i")).value,
            email: hoja.cell(CellIndex.indexByString("C$i")).value,
            telefono:
                hoja.cell(CellIndex.indexByString("D$i")).value.toString()));
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
        _crearFirma(nombre, cargo, email, telefono);
      } else {
        for (Empleado empleado in listaEmpleados) {
          _crearFirma(empleado.nombre, empleado.cargo, empleado.email,
              empleado.telefono ?? '');
        }
      }
    }
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
}
