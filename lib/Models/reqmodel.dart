import 'dart:convert';

class ReqModel {
  String? senderName;
  String? senderId;
  String? reciverName;
  String? reciverId;
  String? reqId;
  ReqModel({
    this.senderName,
    this.senderId,
    this.reciverName,
    this.reciverId,
    this.reqId,
  });

  ReqModel copyWith({
    String? senderName,
    String? senderId,
    String? reciverName,
    String? reciverId,
    String? reqId,
  }) {
    return ReqModel(
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      reciverName: reciverName ?? this.reciverName,
      reciverId: reciverId ?? this.reciverId,
      reqId: reqId ?? this.reqId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderName': senderName,
      'senderId': senderId,
      'reciverName': reciverName,
      'reciverId': reciverId,
      'reqId': reqId,
    };
  }

  factory ReqModel.fromMap(Map<String, dynamic> map) {
    return ReqModel(
      senderName:
          map['senderName'] != null ? map['senderName'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      reciverName:
          map['reciverName'] != null ? map['reciverName'] as String : null,
      reciverId: map['reciverId'] != null ? map['reciverId'] as String : null,
      reqId: map['reqId'] != null ? map['reqId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReqModel.fromJson(String source) =>
      ReqModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReqModel(senderName: $senderName, senderId: $senderId, reciverName: $reciverName, reciverId: $reciverId, reqId: $reqId)';
  }

  @override
  bool operator ==(covariant ReqModel other) {
    if (identical(this, other)) return true;

    return other.senderName == senderName &&
        other.senderId == senderId &&
        other.reciverName == reciverName &&
        other.reciverId == reciverId &&
        other.reqId == reqId;
  }

  @override
  int get hashCode {
    return senderName.hashCode ^
        senderId.hashCode ^
        reciverName.hashCode ^
        reciverId.hashCode ^
        reqId.hashCode;
  }
}
