import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:socrita/core/network/connection_checker.dart';

import 'features/canvas/data/datasources/canvas_remote_datasources.dart';
import 'features/canvas/data/repositories/canvas_repository.dart';
import 'features/canvas/domain/usecase/send_chat_message.dart';
import 'features/canvas/presentation/controllers/deepgram_controller.dart';
import 'features/canvas/presentation/controllers/home_controller.dart';

class InitDependencies {
  static void init() {
    final client = http.Client();

    const apiUrl = 'http://34.47.131.231:5000/query';

    final connectionChecker = ConnectionCheckerImpl(InternetConnection());
    final remoteDataSource =
        CanvasRemoteDatasourcesImpl(client: client, apiUrl: apiUrl);
    final canvasRepository = CanvasRepositoryImpl(
      canvasRemoteDatasources: remoteDataSource,
      connectionChecker: connectionChecker,
    );
    final sendChatMessageUseCase =
        SendChatMessage(canvasRepository: canvasRepository);
    final homeController =
        HomeController(sendChatMessage: sendChatMessageUseCase);
    final deepgramController = DeepgramController();

    Get.put<HomeController>(homeController);
    Get.put<DeepgramController>(deepgramController);
  }
}
