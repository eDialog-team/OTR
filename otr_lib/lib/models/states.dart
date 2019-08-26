enum NetworkState { serverError, loading }

class OTRState {
  final NetworkState _networkState;
  final String _message;
  bool _errorDisplayed = false;
  factory OTRState.serverError({message = "Erreur"}) {
    return  OTRState._(NetworkState.serverError, message);
  }

  factory OTRState.loading({message = "Loading"}) {
    return  OTRState._(NetworkState.loading, message);
  }

  OTRState._(this._networkState, this._message);

  String get message => _message;
  bool get errorDisplayed => _errorDisplayed;
  NetworkState get networkState => _networkState;

  void errorProcessed() {
    this._errorDisplayed = true;
  }

  void errorProcessedReset() {
    this._errorDisplayed = false;
  }
}
