import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const ProxmoxApp());
}

class ProxmoxApp extends StatelessWidget {
  const ProxmoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proxmox Desktop',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
