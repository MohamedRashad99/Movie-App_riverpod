import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  // We add the api key by running 'flutter run --dart-define=movieApiKey=MYKEY
  final movieApiKey =  "acea91d2bff1c53e6604e4985b6989e2";
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
