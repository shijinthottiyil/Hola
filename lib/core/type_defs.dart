import 'package:fpdart/fpdart.dart';
import 'package:hola/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = Future<void>;
