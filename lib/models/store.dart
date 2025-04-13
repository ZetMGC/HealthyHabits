class Store {
  final String name;
  final String address;
  final String type;

  Store({
    required this.name,
    required this.address,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'type': type,
  };

  static Store fromJson(Map<String, dynamic> json) => Store(
    name: json['name'],
    address: json['address'],
    type: json['type'],
  );


  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Store &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              address == other.address &&
              type == other.type;

  @override
  int get hashCode => name.hashCode ^ address.hashCode ^ type.hashCode;
}
