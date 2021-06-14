import 'package:url_launcher/url_launcher.dart' as launcher;

extension NxUriExtension on Uri {
  Future<void> launch() async {
    await launcher.launch(this.toString());
  }
}
