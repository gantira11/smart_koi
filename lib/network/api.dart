import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String _url = 'https://smart-koi-be.lautkita.com/';

  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token').toString();
  }

  _setHeaders() => {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      };

  auth(data, apiURL) async {
    var fullURL = _url + apiURL;
    return await http.post(
      Uri.parse(fullURL),
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  fetchData(apiURL) async {
    var fullURL = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.get(
      fullURL,
      headers: _setHeaders(),
    );
  }

  fetchDataWithParams(apiURL, queryParams) async {
    String queryString = Uri(queryParameters: queryParams).query;
    var fullURL = Uri.parse(_url + apiURL + '?' + queryString);
    await _getToken();
    return await http.get(
      fullURL,
      headers: _setHeaders(),
    );
  }

  store(apiURL, data) async {
    var fullURL = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.post(
      fullURL,
      body: data,
      headers: _setHeaders(),
    );
  }

  update(apiURL, data) async {
    var fullURL = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.put(
      fullURL,
      body: data,
      headers: _setHeaders(),
    );
  }

  delete(apiURL) async {
    var fullURL = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.delete(
      fullURL,
      headers: _setHeaders(),
    );
  }
}
