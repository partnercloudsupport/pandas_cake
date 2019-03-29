class User {
  String uid;
  String name;
  String email;
  String password;
  String sex = 'M';
  String valid;

  User();

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        sex = json['sex'],
        valid = json['valid'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'sex': sex,
        'valid': valid
      };
}
