import 'package:flutter/material.dart';
import 'package:abc_3/Models/modelo_estudiante.dart';


class StudentFormService extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Estudiante? student;

  StudentFormService(this.student);
  
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

}