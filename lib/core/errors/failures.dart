abstract class Failure {
  final String message;

  Failure(this.message);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  ValidationFailure({required this.errors, required String message})
    : super(message);
}


class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}