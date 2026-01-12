import 'dart:convert';
import 'package:http/http.dart' as http;

class ProxmoxApi {
  final String baseUrl; // e.g. https://pve.example.com:8006
  String? ticket;
  String? csrf;
  String? apiToken; // user@realm!tokenid=secret

  ProxmoxApi(this.baseUrl);

  Map<String, String> get _headers {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (ticket != null) h['Cookie'] = 'PVEAuthCookie=$ticket';
    if (csrf != null) h['CSRFPreventionToken'] = csrf!;
    if (apiToken != null) h['Authorization'] = 'PVEAPIToken=$apiToken';
    return h;
  }

  /// Login using username/password
  Future<void> login(String user, String pass, {String realm = 'pam'}) async {
    final uri = Uri.parse('$baseUrl/api2/json/access/ticket');
    final res = await http.post(
      uri,
      body: {'username': '$user@$realm', 'password': pass},
    );

    if (res.statusCode != 200) {
      throw Exception('Login failed');
    }

    final data = json.decode(res.body)['data'];
    ticket = data['ticket'];
    csrf = data['CSRFPreventionToken'];
  }

  /// Get nodes
  Future<List<dynamic>> getNodes() async {
    final uri = Uri.parse('$baseUrl/api2/json/nodes');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Failed to load nodes');
    return json.decode(res.body)['data'];
  }

  /// Get LXCs for a node
  Future<List<dynamic>> getLXCs(String node) async {
    final uri = Uri.parse('$baseUrl/api2/json/nodes/$node/lxc');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Failed to load LXCs');
    return json.decode(res.body)['data'];
  }

  /// Get VMs for a node
  Future<List<dynamic>> getVMs(String node) async {
    final uri = Uri.parse('$baseUrl/api2/json/nodes/$node/qemu');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Failed to load VMs');
    return json.decode(res.body)['data'];
  }
}
