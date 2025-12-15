import 'package:leave_desk/api/base_api.dart';
import 'package:leave_desk/app/api.dart';
import 'package:leave_desk/models/api_response.dart';

class UserApi extends BaseApi {
  Future<ApiResponse> createBioData(Map<String, dynamic> params) async {
    var response = await post(url: Api.bioData, data: params);
    return ApiResponse.parse(response);
  }

  Future<ApiResponse> createFamilyData(Map<String, dynamic> params) async {
    var response = await post(url: Api.familyData, data: params);
    return ApiResponse.parse(response);
  }

  // Future<ApiResponse> getDashboardValues(String id) async {
  //   var response = await get(url: "${Api.getDashboardValues}/$id");
  //   return ApiResponse.parse(response);
  // }
}
