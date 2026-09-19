class Usuario {
  const Usuario({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.street,
    required this.city,
  });

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String street;
  final String city;
}
