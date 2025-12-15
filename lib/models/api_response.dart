class ApiResponse {
  bool get ok => code == 200 || code == 201;
  int? code;
  dynamic body;
  dynamic data;
  String? message;
  int? from;
  int? to;
  int? totalData;
  int? currentPage;
  int? totalPages;

  ApiResponse({
    this.code,
    this.body,
    this.data,
    this.message,
    this.from = 0,
    this.to = 0,
    this.totalData = 0,
    this.totalPages = 0,
    this.currentPage = 0,
  });

  factory ApiResponse.parse(response) {
    if (response != null) {
      int code = response.statusCode;
      dynamic body = response.data ?? "";
      dynamic data;
      dynamic meta;
      String message = "";
      int? fromValue,
          toValue,
          totalDataValue,
          totalPagesValue,
          currentPageValue;

      if (body is Map) {
        data = body["data"];
        meta = body["meta"];
        if (meta != null) {
          fromValue = meta['from'] ?? 0;
          toValue = meta['to'] ?? 0;
          totalDataValue = meta['total'];
          totalPagesValue = meta['last_page'];
          currentPageValue = meta['current_page'];
        }

        message = body["message"] ?? "Sorry, something went wrong.";
      }

      switch (code) {
        case 200:
          // message = body["message"] ?? "";
          break;
        case 400:
          message = body["message"];
          break;
        case 401:
          message = body["message"];

          break;
        case 403:
          message = body["message"];
          break;
        case 404:
          message = body["message"];

          break;
        case 422:
          body["errors"].forEach((final String key, final value) {
            for (int i = 0; i < body["errors"][key].length; i++) {
              message = body["errors"][key][i];
            }
          });
          break;
        case 500:
          message = "Sorry an unknown error has occured";
          break;
        default:
          message = "Unkown application error.";
          break;
      }
      return ApiResponse(
        code: code,
        message: message,
        body: body,
        data: data,
        to: toValue,
        from: fromValue,
        totalData: totalDataValue,
        totalPages: totalPagesValue,
        currentPage: currentPageValue,
      );
    } else {
      return ApiResponse(
        code: 500,
        message: "There seems to be an issue with your internet connection.",
      );
    }
  }
}
