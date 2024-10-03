// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

class ChatMessageEntity {
  final String role;
  final Uint8List? image;
  final String text;

  ChatMessageEntity({
    required this.role,
    this.image,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'image': image?.asMap(),
      'text': text,
    };
  }

  String toJson() => json.encode(toMap());

  ChatMessageEntity copyWith({
    String? role,
    Uint8List? image,
    String? text,
  }) {
    return ChatMessageEntity(
      role: role ?? this.role,
      image: image ?? this.image,
      text: text ?? this.text,
    );
  }
}
