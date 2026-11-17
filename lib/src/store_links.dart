import 'package:url_launcher/url_launcher.dart';

class StoreLinks {
  const StoreLinks({this.iosAppId, this.playPackage, this.developerId = ''});
  final String? iosAppId;
  final String? playPackage;

  /// Apple developer id (číslo) pro "další appky od Ol1n". Doplnit.
  final String developerId;

  Uri get ownListing => iosAppId != null
      ? Uri.parse('https://apps.apple.com/app/id$iosAppId')
      : Uri.parse('https://play.google.com/store/apps/details?id=$playPackage');

  Uri get moreFromOl1n => Uri.parse('https://olin.now');

  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}
