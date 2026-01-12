import 'package:flutter/material.dart';
import '../services/proxmox_api.dart';
import '../models/node.dart';
import '../models/lxc.dart';
import '../models/vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiCtrl = TextEditingController(text: 'https://pve.local:8006');
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  List<Node> nodes = [];
  Map<String, List<Vm>> vms = {};
  Map<String, List<Lxc>> lxcs = {};
  bool loggedIn = false;

  Future<void> _login() async {
    final api = ProxmoxApi(apiCtrl.text);
    await api.login(userCtrl.text, passCtrl.text);
    final rawNodes = await api.getNodes();
    nodes = rawNodes.map((e) => Node.fromJson(e)).toList();

    for (final n in nodes) {
      // Fetch both QEMU VMs and LXCs
      final rawVMs = await api.getVMs(n.name);
      vms[n.name] = rawVMs.map((e) => Vm.fromJson(e)).toList();

      final rawLXCs = await api.getLXCs(n.name);
      lxcs[n.name] = rawLXCs.map((e) => Lxc.fromJson(e)).toList();
    }

    setState(() => loggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Proxmox Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: apiCtrl,
                decoration: const InputDecoration(labelText: 'Proxmox Host'),
              ),
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _login, child: const Text('Login')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Proxmox Companion')),
      body: ListView(
        children: nodes.map((n) {
          return ExpansionTile(
            title: Text('Node: ${n.name}'),
            children: [
              ...vms[n.name]!.map(
                (vm) => ListTile(
                  leading: Icon(
                    Icons.computer,
                    color: vm.status.toLowerCase() == 'running'
                        ? Colors.green
                        : Colors.grey,
                  ), // VM icon
                  title: Text(vm.name),
                  subtitle: Text('Status: ${vm.status}'),
                ),
              ),
              ...lxcs[n.name]!.map(
                (lxc) => ListTile(
                  leading: Icon(
                    Icons.storage,
                    color: lxc.status.toLowerCase() == 'running'
                        ? Colors.green
                        : Colors.grey,
                  ), // LXC icon
                  title: Text(lxc.name),
                  subtitle: Text('Status: ${lxc.status}'),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
