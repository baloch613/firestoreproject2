// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FriendModel {
  String? friendname;
  String? friendId;
  String? userId;
  String? id;
  FriendModel({
    this.friendname,
    this.friendId,
    this.userId,
    this.id,
  });

  FriendModel copyWith({
    String? friendname,
    String? friendId,
    String? userId,
    String? id,
  }) {
    return FriendModel(
      friendname: friendname ?? this.friendname,
      friendId: friendId ?? this.friendId,
      userId: userId ?? this.userId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'friendname': friendname,
      'friendId': friendId,
      'userId': userId,
      'id': id,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      friendname: map['friendname'] != null ? map['friendname'] as String : null,
      friendId: map['friendId'] != null ? map['friendId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) => FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendModel(friendname: $friendname, friendId: $friendId, userId: $userId, id: $id)';
  }

  @override
  bool operator ==(covariant FriendModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.friendname == friendname &&
      other.friendId == friendId &&
      other.userId == userId &&
      other.id == id;
  }

  @override
  int get hashCode {
    return friendname.hashCode ^
      friendId.hashCode ^
      userId.hashCode ^
      id.hashCode;
  }
}
