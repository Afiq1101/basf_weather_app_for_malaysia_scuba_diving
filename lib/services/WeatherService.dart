import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService{



  Future<Map<String, dynamic>> fetchMarineWeatherGenezio({
    required double long,
    required double lat,
    required String days,
  }) async {
    final String apiUrl = "https://ec9e5ce3-b599-4189-a277-8246b4ac6d12.eu-central-1.cloud.genez.io/function-fetch-marine-weather";

    // Pass Params
    final Map<String, String> queryParams = {
      'long': "$long",
      'lat': "$lat",
      'days': days,
    };

    // Set Params into url
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the response if successful
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        return responseData;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return {'success': false, 'error': response.body};
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

}

