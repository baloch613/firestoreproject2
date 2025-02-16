// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReqModel {
  String? senderName;
  String? senderId;
  String? reciverName;
  String? reciverId;
  String? requestId;
  String? status;
  ReqModel({
    this.senderName,
    this.senderId,
    this.reciverName,
    this.reciverId,
    this.requestId,
    this.status,
  });

  ReqModel copyWith({
    String? senderName,
    String? senderId,
    String? reciverName,
    String? reciverId,
    String? requestId,
    String? status,
  }) {
    return ReqModel(
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      reciverName: reciverName ?? this.reciverName,
      reciverId: reciverId ?? this.reciverId,
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderName': senderName,
      'senderId': senderId,
      'reciverName': reciverName,
      'reciverId': reciverId,
      'requestId': requestId,
      'status': status,
    };
  }

  factory ReqModel.fromMap(Map<String, dynamic> map) {
    return ReqModel(
      senderName: map['senderName'] != null ? map['senderName'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      reciverName: map['reciverName'] != null ? map['reciverName'] as String : null,
      reciverId: map['reciverId'] != null ? map['reciverId'] as String : null,
      requestId: map['requestId'] != null ? map['requestId'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReqModel.fromJson(String source) =>
      ReqModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReqModel(senderName: $senderName, senderId: $senderId, reciverName: $reciverName, reciverId: $reciverId, requestId: $requestId, status: $status)';
  }

  @override
  bool operator ==(covariant ReqModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.senderName == senderName &&
      other.senderId == senderId &&
      other.reciverName == reciverName &&
      other.reciverId == reciverId &&
      other.requestId == requestId &&
      other.status == status;
  }

  @override
  int get hashCode {
    return senderName.hashCode ^
      senderId.hashCode ^
      reciverName.hashCode ^
      reciverId.hashCode ^
      requestId.hashCode ^
      status.hashCode;
  }
}
