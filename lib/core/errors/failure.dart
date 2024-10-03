class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure({required super.message});
}

class NoInternetFailure extends Failure {
  NoInternetFailure({required super.message});
}
