enum RequestStatus {
  initial,
  failed,
  loading,
  success;

  bool get isInitial => this == initial;
  bool get isFailed => this == failed;
  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
}
