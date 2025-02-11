// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chatbox {
  String? name;
  String? email;
  String? password;
  String? userid;
  Chatbox({
    this.name,
    this.email,
    this.password,
    this.userid,
  });

  Chatbox copyWith({
    String? name,
    String? email,
    String? password,
    String? userid,
  }) {
    return Chatbox(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userid: userid ?? this.userid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'userid': userid,
    };
  }

  factory Chatbox.fromMap(Map<String, dynamic> map) {
    return Chatbox(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      userid: map['userid'] != null ? map['userid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chatbox.fromJson(String source) => Chatbox.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chatbox(name: $name, email: $email, password: $password, userid: $userid)';
  }

  @override
  bool operator ==(covariant Chatbox other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      other.password == password &&
      other.userid == userid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      userid.hashCode;
  }
}
