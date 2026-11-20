import 'package:http/http.dart';

/// [Client] wrapper that fails every [send] after [timeout].
///
/// Used so GraphQL requests do not hang on OS-default socket/DNS stalls
/// after offline→online transitions.
class TimeoutHttpClient extends BaseClient {
  TimeoutHttpClient(this._inner, {this.timeout = const Duration(seconds: 15)});

  final Client _inner;
  final Duration timeout;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request).timeout(timeout);
  }

  @override
  void close() => _inner.close();
}
