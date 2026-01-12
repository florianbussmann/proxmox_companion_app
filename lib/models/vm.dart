class Vm {
  final int vmid;
  final String name;
  final String status;

  Vm({required this.vmid, required this.name, required this.status});

  factory Vm.fromJson(Map<String, dynamic> j) => Vm(
    vmid: j['vmid'],
    name: j['name'] ?? 'VM ${j['vmid']}',
    status: j['status'],
  );
}
