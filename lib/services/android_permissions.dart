import 'package:permission_handler/permission_handler.dart';

class AndroidPermissions {
  static Future<bool> ensureReadPhoneState() async {
    final status = await Permission.phone.status;
    if (status.isGranted) return true;
    final res = await Permission.phone.request();
    return res.isGranted;
  }
}
