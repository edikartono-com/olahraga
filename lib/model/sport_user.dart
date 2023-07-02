// UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

// String userProfileToJson(UserProfile data) => json.encode(data.toJson);

class UserProfile {
  UserProfile({
    this.usermame,
    this.email,
    this.first_name,
    this.password
  });

  String? usermame;
  String? email;
  String? first_name;
  String? password;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    usermame: json['username'],
    email: json['email'],
    first_name: json['first_name'],
    password: json['password']
  );

  Map<String, dynamic> toJson() => {
    "username": usermame,
    "email": email,
    "first_name": first_name,
    "password": password
  };
}