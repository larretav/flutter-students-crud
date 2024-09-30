class Estudiante{
  String genero;
  String telefono;
  String nombre;
  String? id;

  Estudiante ({
    required this.genero,
    required this.telefono,
    required this.nombre,
  });

  factory Estudiante.fromMap(Map<String,dynamic> json) => Estudiante(
    genero: json["genero"],
    telefono: json["telefono"],
    nombre: json["nombre"],
  );

  Estudiante copy()=> Estudiante(
    genero: genero,
    telefono: telefono,
    nombre: nombre,
  );
}



