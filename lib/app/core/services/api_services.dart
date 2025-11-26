import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService extends GetConnect {
  ApiService() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  // BASE URL (rename agar tidak conflict)
  static const String apiBaseUrl = "http://10.0.2.2:8000/api";

  // STORAGE
  final GetStorage storage = GetStorage();

  // HEADERS
  Map<String, String> _headers({bool auth = true}) {
    final token = storage.read("token");

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (auth && token != null) "Authorization": "Bearer $token",
    };
  }

  // GENERIC REQUESTS
  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) {
    final uri = Uri.parse(
      "$apiBaseUrl$path",
    ).replace(queryParameters: query?.map((k, v) => MapEntry(k, "$v")));

    return get(uri.toString(), headers: _headers(auth: auth));
  }

  Future<Response> postRequest(String path, dynamic body, {bool auth = true}) {
    return post("$apiBaseUrl$path", body, headers: _headers(auth: auth));
  }

  Future<Response> putRequest(String path, dynamic body, {bool auth = true}) {
    return put("$apiBaseUrl$path", body, headers: _headers(auth: auth));
  }

  Future<Response> deleteRequest(String path, {bool auth = true}) {
    return delete("$apiBaseUrl$path", headers: _headers(auth: auth));
  }

  // AUTH
  Future<Response> register(Map<String, dynamic> body) {
    return postRequest("/register", body, auth: false);
  }

  Future<Response> login(Map<String, dynamic> body) {
    return postRequest("/login", body, auth: false);
  }

  Future<Response> logout() {
    return postRequest("/logout", {}, auth: true);
  }

  Future<Response> getUser() {
    return getRequest("/user");
  }

  // HISTORY
  Future<Response> getTaskHistory() {
    return getRequest("/tasks/history");
  }

  Future<Response> getTaskHistoryDetail(int id) {
    return getRequest("/tasks/history/$id");
  }

  // TASK CRUD
  Future<Response> getTasks() {
    return getRequest("/tasks");
  }

  Future<Response> createTask(Map<String, dynamic> body) {
    return postRequest("/tasks", body);
  }

  Future<Response> getTaskDetail(int id) {
    return getRequest("/tasks/$id");
  }

  Future<Response> updateTask(int id, Map<String, dynamic> body) {
    return putRequest("/tasks/$id", body);
  }

  Future<Response> deleteTask(int id) {
    return deleteRequest("/tasks/$id");
  }
}
