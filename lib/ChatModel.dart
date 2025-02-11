// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  String? chatId;
  String? Message;
  String? sendBy;
  String? time;
  String? type;
  ChatModel({
    this.chatId,
    this.Message,
    this.sendBy,
    this.time,
    this.type,
  });


  ChatModel copyWith({
    String? chatId,
    String? Message,
    String? sendBy,
    String? time,
    String? type,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      Message: Message ?? this.Message,
      sendBy: sendBy ?? this.sendBy,
      time: time ?? this.time,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'Message': Message,
      'sendBy': sendBy,
      'time': time,
      'type': type,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      Message: map['Message'] != null ? map['Message'] as String : null,
      sendBy: map['sendBy'] != null ? map['sendBy'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(chatId: $chatId, Message: $Message, sendBy: $sendBy, time: $time, type: $type)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.chatId == chatId &&
      other.Message == Message &&
      other.sendBy == sendBy &&
      other.time == time &&
      other.type == type;
  }

  @override
  int get hashCode {
    return chatId.hashCode ^
      Message.hashCode ^
      sendBy.hashCode ^
      time.hashCode ^
      type.hashCode;
  }
}
