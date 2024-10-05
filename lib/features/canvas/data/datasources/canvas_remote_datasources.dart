import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socrita/core/errors/failure.dart';
import 'package:socrita/features/canvas/domain/entities/chat_message_entity.dart';

abstract class CanvasRemoteDatasources {
  Future<ChatMessageEntity> sendChatMessage(
      {required ChatMessageEntity message});
}

class CanvasRemoteDatasourcesImpl implements CanvasRemoteDatasources {
  final http.Client client;
  final String apiUrl;

  CanvasRemoteDatasourcesImpl({required this.client, required this.apiUrl});

  @override
  Future<ChatMessageEntity> sendChatMessage(
      {required ChatMessageEntity message}) async {
    try {
      var object = {};

      if (message.image != null) {
        object['image_data'] = base64Encode(message.image!);
      }

      object['query'] = message.text;
      object['model'] = message.role;

      final response = await client.post(
        Uri.parse(apiUrl),
        body: json.encode(object),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return ChatMessageEntity(
          role: "model",
          text: responseData['response'],
          image: message.image,
        );
      } else {
        throw ServerFailure(
            message: 'Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is ServerFailure) {
        rethrow;
      }
      throw UnexpectedFailure(message: 'An unexpected error occurred: $e');
    }
  }
}
