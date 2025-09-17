import 'package:uuid/uuid.dart';
// import 'package:logging/logging.dart';

final uuid = Uuid();
// final log = Logger('UsersService');

final List<Map<String, dynamic>> mockData = [
  {
    "id": "ab5bac46-ca24-44b0-b850-5a00f5aac83b",
    "username": "alisonburgers",
    "email": "projayson@gmail.com",
  },
  {
    "id": "e6f7c360-5e01-43b3-8305-93ee43f18740",
    "username": "jaysonsales",
    "email": "jayson.sales.r@gmail.com",
  },
];

class UsersService {
  Future<List<Map<String, dynamic>>> getUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockData;
  }
}

class AddUserService {
  Future<void> addUser(Map<String, String> user) async {
    await Future.delayed(const Duration(seconds: 1));
    final id = uuid.v4();
    final newUser = {
      "id": id,
      "username": user['username']!,
      "email": user['email']!,
      "password": user['password']!,
    };
    mockData.add(newUser);
  }
}
