class Session {
  late final String id;
  final String name;
  final bool isActive;
  final List<String> users;

  Session({
    required this.id,
    required this.name,
    required this.isActive,
    required this.users,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['_id'],
      name: json['name'],
      isActive: json['isActive'],
      users: (json['users'] as List<dynamic>?)
          ?.map((event) => event.toString())
          .toList() ?? [],
    );
  }
}