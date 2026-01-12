class Node {
  final String name;
  Node(this.name);
  factory Node.fromJson(Map<String, dynamic> j) => Node(j['node']);
}
