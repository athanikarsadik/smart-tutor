import 'package:dartz/dartz.dart';
import 'package:socrita/core/errors/failure.dart';
import 'package:socrita/features/canvas/domain/entities/chat_message_entity.dart';
import 'package:socrita/features/canvas/domain/repositories/canvas_repository.dart';

import '../../../../core/network/connection_checker.dart';
import '../datasources/canvas_remote_datasources.dart';

class CanvasRepositoryImpl implements CanvasRepository {
  final CanvasRemoteDatasources canvasRemoteDatasources;
  final ConnectionChecker connectionChecker;

  CanvasRepositoryImpl(
      {required this.canvasRemoteDatasources, required this.connectionChecker});

  @override
  Future<Either<Failure, ChatMessageEntity>> sendChatMessage(
      {required ChatMessageEntity message}) async {
    if (!await (connectionChecker.isConnected)) {
      return Left(NoInternetFailure(message: "No internet connection!"));
    }

    try {
      final result =
          await canvasRemoteDatasources.sendChatMessage(message: message);
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } on UnexpectedFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
          UnexpectedFailure(message: 'An unexpected error occurred: $e'));
    }
  }
}
