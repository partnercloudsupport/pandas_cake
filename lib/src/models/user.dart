class User {
  static final collection = 'users';
  String uid;
  String name;
  String email;
  String password;
  String sex = 'M';
  bool isAdmin = false;

  User();

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        sex = json['sex'],
        isAdmin = json['isAdmin'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'sex': sex,
        'isAdmin': isAdmin
      };
}
