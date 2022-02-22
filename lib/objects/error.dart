import 'dart:convert';

AnswerError answerErrorFromJson(String str) =>
    AnswerError.fromJson(json.decode(str));

String answerErrorToJson(AnswerError data) => json.encode(data.toJson());

class AnswerError {
  AnswerError({
    required this.message,
  });

  String message;

  factory AnswerError.fromJson(Map<String, dynamic> json) => AnswerError(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
