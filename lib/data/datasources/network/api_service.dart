import 'package:http/http.dart' as http;

import '../../../core/constants/app_imports.dart';

class ApiService {
  ApiService._();
  static const String _baseUrl = "http://46.19.66.131/";
  static Map<String, String> _header() {
    final token = SharedPreferencesHelper().getString("access").toString();
    if (token.isEmpty || token == "null") {
      return {"Content-Type": "application/json"};
    }

    return {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    };
  }

  static Map<String, String> _header2() {
    return {"Content-Type": "application/json"};
  }

  //=====LOGIN=====
  static Future<HttpResult> login(String phone_number, String password) async {
    var body = {"phone_number": phone_number, "password": password};

    return await _post("api/api/login/", body: body);
  }

  static Future<HttpResult> registr(
    String name,
    String phone_number,
    String password,
  ) async {
    var body = {
      "name": name,
      "phone_number": phone_number,
      "password": password,
    };

    return await _post("api/api/register/", body: body);
  }

  static Future<HttpResult> verify_otp(
    String phone_number,
    String otp_code,
    String otp_type,
  ) async {
    var body = {
      "phone_number": phone_number,
      "otp_code": otp_code,
      "otp_type": otp_type,
    };

    return await _post("api/api/verify-otp/", body: body);
  }

  static Future<HttpResult> resetPasswordbyPhoneNumber(
    String phone_number,
  ) async {
    var body = {"phone_number": phone_number};

    return await _post("api/api/password-reset/", body: body);
  }

  static Future<HttpResult> setNewPassword(
    String reset_token,
    String new_password,
    String confirm_password,
  ) async {
    var body = {
      "reset_token": reset_token,
      "new_password": new_password,
      "confirm_password": confirm_password,
    };

    return await _post("api/api/password-reset/set-password/", body: body);
  }

  static Future<HttpResult> confirmotpforResetPassword(
    String phone_number,
    String otp_code,
  ) async {
    var body = {"phone_number": phone_number, "otp_code": otp_code};

    return await _post("api/api/password-reset-confirm/", body: body);
  }

  static Future<HttpResult> getProfile() async {
    return await _get("api/profile/");
  }

  static Future<HttpResult> getCategories() async {
    return await _get("api/categories/");
  }

  static Future<HttpResult> createIncome(
    String amount,
    String date,
    int category,
  ) async {
    return await _post(
      "api/income/",
      body: {"category": category, "amount": amount, "date": date},
    );
  }

  static Future<HttpResult> createExpense(
    String amount,
    String date,
    int category,
  ) async {
    return await _post(
      "api/expense/",
      body: {"category": category, "amount": amount, "date": date},
    );
  }

  static Future<HttpResult> getIncomeList() async {
    return await _get("api/income/");
  }

  static Future<HttpResult> getExpenseList() async {
    return await _get("api/expense/");
  }

  static Future<bool> refreshAccessToken() async {
    String? refreshToken = await SharedPreferencesHelper().getString("refresh");

    Uri url = Uri.parse('http://46.19.66.131/api/api/token/refresh/');
    try {
      var response = await http
          .post(url, body: {"refresh": refreshToken})
          .timeout(const Duration(seconds: 30));
          print(response.body);
      if (response.statusCode == 200) {

        final decoded = jsonDecode(response.body);
        final newAccess = decoded["access"];
        final newRefresh = decoded["refresh"] ?? refreshToken;

        await SharedPreferencesHelper().setString("access", newAccess);
        await SharedPreferencesHelper().setString("refresh", newRefresh);
        print("Tokenlar yangilandi");

        return true;
      } else {
        /// Tokenlarni o'chiramiz
        await SharedPreferencesHelper().remove("access");
        await SharedPreferencesHelper().remove("refresh");
        await SharedPreferencesHelper().remove("user");

       
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => SplashScreen()),
          (route) => false,
        );

        return false;
      }
    } catch (e) {
      /// Tokenlarni o'chiramiz
      await SharedPreferencesHelper().remove("access");
      await SharedPreferencesHelper().remove("refresh");
      await SharedPreferencesHelper().remove("user");

      /// SplashScreen ga redirect qilamiz
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SplashScreen()),
        (route) => false,
      );

      return false;
    }
  }
static Future<HttpResult> getOfferta(){
  return _get("api/offerta/");
}
static Future<HttpResult> getAllQuestions(){
  return _get("api/questions/");
}
static Future<HttpResult> dashboardHelp(){
  return _get("dashboard/help/");
}
  //=====GET ALL COURSES =====

  static Future<HttpResult> _post(
    String path, {
    Object? body,
    bool? isSecondHeader = false,
  }) async {
    Uri url = Uri.parse('$_baseUrl$path');
    try {
      http.Response response = await http
          .post(
            url,
            body: jsonEncode(body),
            headers: isSecondHeader == true ? _header2() : _header(),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 401) {
        final isRefreshed = await refreshAccessToken();
        if (isRefreshed) {
          return await _post(path, body: body, isSecondHeader: isSecondHeader);
        }
      }

      HttpInspector.onResponse(response);

      var decoded = jsonDecode(response.body);
      return HttpResult(
        statusCode: response.statusCode,
        isSuccess: response.statusCode == 200 || response.statusCode == 201,
        result: decoded,
        path: path,
      );
    } catch (err) {
      return HttpResult(statusCode: -1, result: err, path: path);
    }
  }

  static Future<HttpResult> _get(String path) async {
    Uri url;
    url = Uri.parse('$_baseUrl$path');
    try {
      http.Response response = await http
          .get(url, headers: _header())
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 401) {
        final isRefreshed = await refreshAccessToken();
        if (isRefreshed) {
          return await _get(path); 
        }
      }

      HttpInspector.onResponse(response);

      var decoded = json.decode(utf8.decode(response.bodyBytes));
print(decoded);
      if (response.statusCode == 200) {
        return HttpResult(statusCode: 200, isSuccess: true, result: decoded);
      } else {}
      return HttpResult(
        statusCode: response.statusCode,

        result: decoded.toString(),
        path: path,
        method: 'GET',
      );
    } catch (err) {
      return HttpResult(statusCode: -1, result: err, path: path, method: 'GET');
    }
  }

  static Future<HttpResult> _patch(String path, {Object? body}) async {
    Uri url = Uri.parse('$_baseUrl$path');

    try {
      http.Response response = await http
          .patch(url, body: jsonEncode(body), headers: _header())
          .timeout(const Duration(seconds: 30));
      HttpInspector.onResponse(response);
      var decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return HttpResult(
          statusCode: 200,
          isSuccess: true,
          result: decoded,
          method: 'PATCH',
          path: path,
        );
      }
      if (response.statusCode == 401) {
        // Unauthorized().onLogoutPresssed();
      }
      return HttpResult(
        statusCode: response.statusCode,
        result: decoded['message'].toString(),
        method: 'PATCH',
        path: path,
      );
    } catch (err) {
      return HttpResult(
        statusCode: -1,
        result: err,
        method: 'PATCH',
        path: path,
      );
    }
  }
}

class AppStrings2 {
  static const String INVALID_RESPONSE = 'Неверный ответ';
  static const String SOCKET_EXCEPTION = 'Нет соединения с интернетом';
  static const String FORMAT_ERROR = 'Неверный формат';
  static const String UNKNOWN_ERROR = 'Неизвестная ошибка';
  static const String TIMEOUT_EXCEPTION = 'Исключение тайм-аута';
  static const String HTTP_ERROR = 'HTTP-ошибка';
}
