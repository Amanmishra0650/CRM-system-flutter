import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const apiBase = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:4000/api/v1');
class ApiFailure implements Exception {
  final String message;
  ApiFailure(this.message);
  @override String toString()=>message;
}
class BikeApi {
  String? token;
  Future<void> restore() async { const storage=FlutterSecureStorage();token=await storage.read(key:'token'); }
  Future<void> saveToken(String value) async {token=value;const storage=FlutterSecureStorage();await storage.write(key:'token',value:value);}
  Future<void> signOut() async {token=null;const storage=FlutterSecureStorage();await storage.delete(key:'token');}
  Future<dynamic> call(String method,String path,{Object? data,Map<String,String>? extra}) async {
    final headers=<String,String>{'Content-Type':'application/json',if(token!=null)'Authorization':'Bearer $token',...?extra};
    http.Response response;
    try {
      final request=http.Request(method,Uri.parse('$apiBase$path'))..headers.addAll(headers);
      if(data!=null)request.body=jsonEncode(data);
      response=await request.send().then(http.Response.fromStream);
    } catch (_) {throw ApiFailure('Cannot reach the server. Check the API address and connection.');}
    dynamic payload;try{payload=jsonDecode(response.body);}catch(_){payload={'error':'Unexpected server response'};}
    if(response.statusCode>=400)throw ApiFailure(payload is Map ? (payload['error']?.toString()??'Request failed'):'Request failed');
    return payload;
  }
}
