import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abc_3/Models/modelo_estudiante.dart';


class EstudiantesServices extends ChangeNotifier{
  final String _urlBase = 'abcflutter-55566-default-rtdb.firebaseio.com';


final List<Estudiante> listaEstudiantes = [];
late Estudiante selectedStudent;
bool cargandoInfo = false;

EstudiantesServices() {
  cargarEstudiantes();
}

Future<List<Estudiante>> cargarEstudiantes() async {
  cargandoInfo = true;
  final url = Uri.https(_urlBase, ' persona.json');
  final respuesta = await http.get(url);
                                               
  print(respuesta.body);

  final Map<String, dynamic> obj = json.decode(respuesta.body);

  obj.forEach((key, value) {
    final estudiante = Estudiante.fromMap(value);
    estudiante.id = key;
    listaEstudiantes.add(estudiante);
  });
  print(listaEstudiantes[0].nombre);

  cargandoInfo = false;
  notifyListeners();
  return listaEstudiantes;

}

Future<bool> saveEstudiante(Estudiante estudiante, bool isEdit) async{
  var requestMethod='';
  final Uri url;
  if(isEdit){
    requestMethod = "PATCH";
    url = Uri.https(_urlBase, ' persona/${estudiante.id}.json');
  } else {
    requestMethod = "POST";
    url = Uri.https(_urlBase, ' persona.json');

  }
  final request = http.MultipartRequest(requestMethod, url);
  request.fields["nombre"] = estudiante.nombre;
  request.fields["genero"] = estudiante.genero;
  request.fields["telefono"] = estudiante.telefono;

  var response = await request.send();
  print("guardar${response.statusCode} ${response.stream.bytesToString()}");
  if(response.statusCode == 200){
    if (requestMethod == "POST") {
      estudiante.id = response.stream.bytesToString() as String?;
      listaEstudiantes.add(estudiante);
    } else {
      final studentIndex = listaEstudiantes.indexWhere((student) => student.id == estudiante.id);
      listaEstudiantes[studentIndex] = estudiante;
    }
    notifyListeners();
    return true;
  } else {
    return false;
  }

}

Future<bool> deleteEstudiante(String? estudianteId) async {
  final url = Uri.https(_urlBase, ' persona/$estudianteId.json');
  final respuesta = await http.delete(url);
  print(respuesta.statusCode);
  if(respuesta.statusCode == 200){
    listaEstudiantes.removeWhere((item) => item.id == estudianteId);
    notifyListeners();
    return true;
  } else {
    return false;
  }

}

}