import 'package:aleman/core/network/api/app_api.dart';

abstract class AuthenticationRepository {}

class AuthenticationRepositoryImplement implements AuthenticationRepository {
  AuthenticationRepositoryImplement(this._apiService);
  final AppServiceClient _apiService;
}
