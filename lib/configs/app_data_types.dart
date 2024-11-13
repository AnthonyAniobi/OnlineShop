import 'package:dartz/dartz.dart';
import 'package:online_shop/shared/data/models/app_responses.dart';

typedef AsyncApiErrorOr<T> = Future<Either<ApiError, T>>;
typedef ApiErrorOr<T> = Either<ApiError, T>;
