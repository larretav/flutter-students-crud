import 'package:abc_3/Services/estudiantes_services.dart';
import 'package:abc_3/Services/student_form_service.dart';
import 'package:abc_3/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abc_3/Models/modelo_estudiante.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textController = TextEditingController();

  void _showDialog({String? initialText, int? index}) {
    _textController.text = initialText ?? '';

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text(index == null ? 'Agregar' : 'Editar'),
    //       content: Column(
    //         children: [
    //           TextField(
    //             controller: _textController,
    //             decoration: InputDecoration(hintText: 'Agregar'),
    //           )
    //         ],
    //       ) ,
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('cancelar'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //         TextButton(
    //           child: Text(index == null ? 'agregar' : 'actualizar'),
    //           onPressed: () {
    //             if (index == null) {
    //               _addTask(_textController.text);
    //             } else {
    //               _editTask(index, _textController.text);
    //             }
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
    showDialog(
      context: context,
      builder: (context) {
        return _StudentForm( initialText: initialText,index: index);
      },
    );
  }

  void _addTask(String task) {
    setState(() {
      print("agregar$task");
    });
  }


  //editar
  void _editTask(int index, String newTask) {
    setState(() {
      print("editar$index $newTask");
    });
  }

  //borrar
  void _deleteTask(String? index, EstudiantesServices estudianteServices) {
    
    estudianteServices.deleteEstudiante(index).then(
      (response) {
        print("borrar$index");
        print("borrar$response");
      });
  }

  @override
  Widget build(BuildContext context) {
    final estudianteServices = Provider.of<EstudiantesServices>(context);

    if (estudianteServices.cargandoInfo) return const LoadingPage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FireBase'),
      ),
      body: ListView.builder(
        itemCount: estudianteServices.listaEstudiantes.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                title: Text(estudianteServices.listaEstudiantes[index].nombre),
                subtitle: Text(estudianteServices.listaEstudiantes[index].genero),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
                leading: const Icon(Icons.person, color: Colors.blueAccent),
              ),
              Column(
                children: [
                  IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    estudianteServices.selectedStudent = estudianteServices.listaEstudiantes[index].copy();
                    _showDialog(initialText: estudianteServices.listaEstudiantes[index].nombre, index: index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(estudianteServices.listaEstudiantes[index].id, estudianteServices);
                  },
                ),
                ],
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showDialog();
        },
      ),
    );
  }

}


class _StudentForm extends StatelessWidget {
  
  const _StudentForm({super.key, this.initialText, this.index});

  final String? initialText;
  final int? index;

  @override
  Widget build(BuildContext context) {

    final studentService = Provider.of<EstudiantesServices>(context);
    final student = studentService.selectedStudent;

    return AlertDialog(
          title: Text(index == null ? 'Agregar' : 'Editar'),
          content: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: student.nombre,
                onChanged: (value) => student.nombre = value,
                decoration: const InputDecoration(labelText:'Nombre' ),
                
              ),
              const SizedBox(height: 30),

              TextFormField(
                initialValue: student.telefono,
                onChanged: (value) => student.telefono = value,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: student.genero,
                onChanged: (value) => student.genero = value,
                decoration: const InputDecoration(labelText: 'Género'),
              ),
            ],
          ) ,
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(index == null ? 'Agregar' : 'Actualizar'),
              onPressed: () {
                if (index == null) {
                  studentService.saveEstudiante(student, true);
                } else {
                  studentService.saveEstudiante(student, false);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  }
}