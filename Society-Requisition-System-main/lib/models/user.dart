import '../config.dart';

enum UserRole {
  chairperson,
  studentAffairs,
  accountsOfficer,
  staffHead,
  itHead,
}

class User {
  final String id;
  final String name;
  final String email;
  final String designation;
  final String profilePictureUrl;
  final UserRole role;
  final String? password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.designation,
    required this.profilePictureUrl,
    required this.role,
    required this.password,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'designation': designation,
    'profilePictureUrl': profilePictureUrl,
    'role': role.toShortString(),
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // just in case backend sends it as int
      name: json['name'],
      email: json['email'],
      designation: json['designation'],
      profilePictureUrl:
          '${ServerConfig.baseUrl}/images/' +
          json['pic_url'], // <-- map properly
      role: UserRoleExtension.fromString(json['role']),
      password: json['password'],
    );
  }
}

extension UserRoleExtension on UserRole {
  String toShortString() {
    return toString().split('.').last;
  }

  static UserRole fromString(String roleString) {
    return UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == roleString,
    );
  }
}
