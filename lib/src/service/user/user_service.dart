final mockData = [
  {
    "id": 1,
    "username": "alisonburgers",
    "email": "projayson@gmail.com",
    "password": "123456",
  },
  {
    "id": 2,
    "username": "jaysonsales",
    "email": "jayson.sales.r@gmail.com",
    "password": "123456",
  },
];

class UserService {
  Future<List<dynamic>> getUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockData;
  }
}

class IsLoggedInService {
  static bool _isLoggedIn = false;

  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(seconds: 1));
    return _isLoggedIn;
  }

  static void setLoggedIn(bool value) {
    _isLoggedIn = value;
  }
}

class UserLoginService {
  Future<bool> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    for (var user in mockData) {
      if (user['email'] == email && user['password'] == password) {
        IsLoggedInService.setLoggedIn(true);
        return true; 
      }
    }
    IsLoggedInService.setLoggedIn(false); 
    return false; 
  }
}
