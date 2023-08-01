import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<String> uploadPhotoToServer(Uint8List bytes, String idToken) async {
  final url = Uri.parse('your_upload_url_here');
  final headers = {
    'Authorization': 'Bearer $idToken',
    'Content-Type': 'application/json',
  };
  final body = {
    'image': base64Encode(bytes),
  };
  final response = await http.post(url, headers: headers, body: jsonEncode(body));
  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    final photoUrl = responseBody['photoUrl'];
    return photoUrl;
  } else {
    throw Exception('Failed to upload photo');
  }
}
