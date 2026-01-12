class Lxc {
  final int vmid;
  final String name;
  final String status;

  Lxc({required this.vmid, required this.name, required this.status});

  factory Lxc.fromJson(Map<String, dynamic> j) => Lxc(
    vmid: j['vmid'],
    name: j['name'] ?? 'LXC ${j['vmid']}',
    status: j['status'],
  );
}
