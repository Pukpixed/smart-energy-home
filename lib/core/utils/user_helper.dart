import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class UserHelper {
  static String uid(context) {
    return context.read<AuthProvider>().uid!;
  }
}
