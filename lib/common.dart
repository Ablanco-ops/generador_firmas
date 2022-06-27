import 'package:flutter/material.dart';

void customSnack(String texto, BuildContext context) {
  SnackBar snackBar = SnackBar(content: Text(texto));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

class SepWidget extends StatelessWidget {
  const SepWidget(
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
            width: display.width * 0.1,
            child: campo,
          ),
        ],
      ),
    );
  }
}