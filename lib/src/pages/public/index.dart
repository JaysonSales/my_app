import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/auth/index.dart';
import 'package:my_app/src/pages/public/error/index.dart';

final publicRoutes = <RouteBase>[...authRoutes, ...errorRoutes];
