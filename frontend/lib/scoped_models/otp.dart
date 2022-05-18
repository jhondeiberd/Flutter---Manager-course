import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main-model.dart';
class OtpModels extends Model{
  late int _otpId;
  late int _otp;
  int _courseId = 1;
  late String _studentEmail;

  int get otpId => _otpId;
  int get otp => _otp;
  int get courseId => _courseId;
  String get studentEmail => _studentEmail;

  Future<bool> sendOtp(String email){
    bool _isLoading = true;
    _studentEmail = email;
    final Map<String, dynamic> payLoad = {
      'student_email': email,
    };
    return http.post(
        Uri.parse('${MainModel.apiEndpoint}otp'),
        // headers: {
        //   "Content-type":"application/json"
        // },
        body: payLoad
    ).then<bool>((http.Response response) {
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Successful"){
        _otpId=responseData["id"];
        bool _isLoading = false;
        return true;
      }else{
        bool _isLoading = false;
        return false;
      }
    });
  }

  Future<bool> verifyOTP(String otp){
    bool _isLoading = true;
    final Map<String, dynamic> payLoad = {
      'code': otp,
    };
    return http.post(
        Uri.parse('${MainModel.apiEndpoint}otp/${otpId}'),
        // headers: {
        //   "Content-type":"application/json"
        // },
        body: payLoad
    ).then<bool>((http.Response response) {
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success" && responseData["message"] == "Verification Success"){
        bool _isLoading = false;
        return true;
      }else{
        bool _isLoading = false;
        return false;
      }
    });
  }

  void setCourseId(int id){
    _courseId = id;
  }

}