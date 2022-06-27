// ignore_for_file: public_member_api_docs, sort_constructors_first
class Empleado {
  String nombre;
  String cargo;
  String telefono;
  String email;


  Empleado(
      {required this.nombre,
      required this.cargo,
      required this.email,
      required this.telefono,
});

  @override
  String toString() {
    return 'Empleado(nombre: $nombre, cargo: $cargo, telefono: $telefono, email: $email)';
  }
}
