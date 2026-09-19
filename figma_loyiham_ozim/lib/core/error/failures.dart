sealed class Failure {
  const Failure(this.message);
  final String message;
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Kirish muvaffaqiyatsiz']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Topilmadi']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tarmoq xatosi']);
}
