// To parse this JSON data, do
//
//     final smsAnswer = smsAnswerFromJson(jsonString);

import 'dart:convert';

SmsAnswer smsAnswerFromJson(String str) => SmsAnswer.fromJson(json.decode(str));

String smsAnswerToJson(SmsAnswer data) => json.encode(data.toJson());

class SmsAnswer {
  SmsAnswer({
    required this.status,
    required this.statusCode,
    required this.sms,
    required this.balance,
  });

  String status;
  int statusCode;
  Map<String, Sm> sms;
  double balance;

  factory SmsAnswer.fromJson(Map<String, dynamic> json) => SmsAnswer(
        status: json["status"],
        statusCode: json["status_code"],
        sms: Map.from(json["sms"])
            .map((k, v) => MapEntry<String, Sm>(k, Sm.fromJson(v))),
        balance: json["balance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "sms": Map.from(sms)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "balance": balance,
      };
}

class Sm {
  Sm({
    required this.status,
    required this.statusCode,
    required this.smsId,
    required this.statusText,
  });

  String status;
  int statusCode;
  String smsId;
  String statusText;

  factory Sm.fromJson(Map<String, dynamic> json) => Sm(
        status: json["status"],
        statusCode: json["status_code"],
        smsId: json["sms_id"] == null ? null : json["sms_id"],
        statusText: json["status_text"] == null ? null : json["status_text"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "sms_id": smsId == null ? null : smsId,
        "status_text": statusText == null ? null : statusText,
      };
}
