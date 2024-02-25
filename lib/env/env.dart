import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
    @EnviedField(varName: 'API_KEY')
    static String apiKey = _Env.apiKey;

    @EnviedField(varName: 'API_URL')
    static String apiUrl = _Env.apiUrl;

    @EnviedField(varName: 'GOOGLE_OAUTH_CLIENT_ID')
    static String googleAuthClientId = _Env.googleAuthClientId;
}