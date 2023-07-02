class UserRepository {
  Future<String> authenticate({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
    return 'token';
  }

  Future<void> deleteToken() async {
    // menghapus dari keystore
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    // menulis ke keystore
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> hasToken() async {
    // membaca keystore
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }
}