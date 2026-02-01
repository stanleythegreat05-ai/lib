class User {
  final int id;
  final String name;
  final String email;
  final String company;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      // Accessing nested JSON data for the company name
      company: json["company"]["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}