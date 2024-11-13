import 'package:equatable/equatable.dart';
import 'package:online_shop/shared/data/models/app_responses.dart';
import 'package:online_shop/shared/domain/models/models.dart';
import 'package:online_shop/shared/enums/request_status.dart';

abstract class ImageUpdateState extends Equatable {
  const ImageUpdateState({
    this.status = RequestStatus.initial,
    this.error,
  });

  final RequestStatus status;
  final AppError? error;

  @override
  List<Object?> get props => [status];
}

class UploadingImageState extends ImageUpdateState {
  const UploadingImageState({super.error, super.status});
}

class UploadingDataState extends ImageUpdateState {
  const UploadingDataState({
    super.status,
    super.error,
    required this.imageUrl,
  });
  final String imageUrl;
}

class ImageUpdateComplete extends ImageUpdateState {
  const ImageUpdateComplete({super.status, super.error, required this.user});

  final User user;

  @override
  List<Object?> get props => [status, error, user];
}
