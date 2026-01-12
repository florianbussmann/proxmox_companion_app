import 'package:proxmox_companion_app/services/proxmox_api.dart';

class MockProxmoxApi extends ProxmoxApi {
  MockProxmoxApi(super.baseUrl);

  @override
  Future<void> login(String user, String pass, {String realm = 'pam'}) async {
    ticket = 'fake-ticket'; // simulate successful login
  }

  @override
  Future<List<Map<String, dynamic>>> getNodes() async {
    return [
      {'node': 'node1'},
      {'node': 'node2'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getVMs(String node) async {
    return [
      {'vmid': 1, 'name': 'vm1', 'status': 'running'},
      {'vmid': 2, 'name': 'vm2', 'status': 'stopped'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getLXCs(String node) async {
    return [
      {'vmid': 3, 'name': 'lxc1', 'status': 'running'},
      {'vmid': 4, 'name': 'lxc2', 'status': 'stopped'},
    ];
  }
}
