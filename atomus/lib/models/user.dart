class User {
  int? id;
  String? name;
  String? cpf;
  final String email;
  final String password;
  bool? isActive;

  User.create(
      {this.id,
      required this.name,
      required this.cpf,
      required this.email,
      required this.password,
      this.isActive});

  User.login({
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User.create(
      name: json['name'],
      cpf: json['cpf'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
      'isActive': isActive,
    };
  }
}
