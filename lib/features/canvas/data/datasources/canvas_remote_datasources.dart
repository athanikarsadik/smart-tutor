import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socrita/core/errors/failure.dart';
import 'package:socrita/features/canvas/domain/entities/chat_message_entity.dart';

abstract class CanvasRemoteDatasources {
  Future<ChatMessageEntity> sendChatMessage(
      {required ChatMessageEntity message});
}

class CanvasRemoteDatasourcesImpl implements CanvasRemoteDatasources {
  final http.Client client; // Add http client
  final String apiUrl; // Add API URL

  CanvasRemoteDatasourcesImpl({required this.client, required this.apiUrl});

  @override
  Future<ChatMessageEntity> sendChatMessage(
      {required ChatMessageEntity message}) async {
    try {
      var object = {};

      if (message.image != null) {
        object['image'] = base64Encode(message.image!);
      }

      object['prompt'] = message.text;

      // 3. Make API call
      final response = await client.post(
        Uri.parse(apiUrl),
        body: json.encode(object),
        headers: {'Content-Type': 'application/json'},
      );

      // 4. Handle response
      if (response.statusCode == 200) {
        // Successful API call
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("res: $responseData");
        return ChatMessageEntity(
          role: "model",
          text: "Random text",
          image: message.image,
        );
      } else {
        // API error
        throw ServerFailure(
            message: 'Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle other exceptions (e.g., network issues)
      if (e is ServerFailure) {
        rethrow; // Rethrow ServerFailure to be handled at a higher level
      }
      throw UnexpectedFailure(message: 'An unexpected error occurred: $e');
    }
  }
}
