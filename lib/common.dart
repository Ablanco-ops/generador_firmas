import 'package:flutter/material.dart';

void customSnack(String texto, BuildContext context) {
  SnackBar snackBar = SnackBar(content: Text(texto));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}