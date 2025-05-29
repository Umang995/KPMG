
import 'dart:io';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY 3.6.243.60:443";
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}



