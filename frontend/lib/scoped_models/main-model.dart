
import 'package:scoped_model/scoped_model.dart';

import 'ConnectedModels.dart';
import 'otp.dart';


class MainModel extends Model with ConnectedModels, UsersModel, CoursesModel, OtpModels, CriteriaModel,TeacherModel, StudentsModel, ReviewsModel {
  static const backendURL = String.fromEnvironment('BACKEND_URL',
                              defaultValue: '192.99.108.204:3001');
  static const apiEndpoint = 'http://${backendURL}/api/';
}

