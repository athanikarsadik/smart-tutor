import 'package:dartz/dartz.dart';
import 'package:socrita/core/errors/failure.dart';
import 'package:socrita/core/usecase/usecase.dart';
import 'package:socrita/features/canvas/domain/entities/chat_message_entity.dart';
import 'package:socrita/features/canvas/domain/repositories/canvas_repository.dart';

class SendChatMessage implements UseCase<ChatMessageEntity, ChatMessageEntity> {
  final CanvasRepository canvasRepository;

  SendChatMessage({required this.canvasRepository});
  @override
  Future<Either<Failure, ChatMessageEntity>> call(
      ChatMessageEntity params) async {
    return await canvasRepository.sendChatMessage(message: params);
  }
}
