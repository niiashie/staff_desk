import 'package:leave_desk/api/base_api.dart';
import 'package:leave_desk/app/api.dart';
import 'package:leave_desk/models/api_response.dart';

class AuthApi extends BaseApi {
  Future<ApiResponse> login(Map<String, dynamic> params) async {
    var response = await post(url: Api.login, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> registration(Map<String, dynamic> params) async {
    var response = await post(url: Api.registration, data: params);
    return ApiResponse.parse(response);
  }

  // Future<ApiResponse> getDashboardValues(String id) async {
  //   var response = await get(url: "${Api.getDashboardValues}/$id");
  //   return ApiResponse.parse(response);
  // }
}
