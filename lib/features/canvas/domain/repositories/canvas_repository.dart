import 'package:dartz/dartz.dart';
import 'package:socrita/features/canvas/domain/entities/chat_message_entity.dart';

import '../../../../core/errors/failure.dart';

abstract class CanvasRepository {
  Future<Either<Failure, ChatMessageEntity>> sendChatMessage(
      {required ChatMessageEntity message});
}
