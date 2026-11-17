import 'package:shared_preferences/shared_preferences.dart';

/// Parsuje `utm_campaign` z Play install referreru
/// (např. `utm_source=qr&utm_campaign=chrestys`).
String? parseCampaign(String? referrer) {
  if (referrer == null || referrer.isEmpty) return null;
  try {
    return Uri.splitQueryString(referrer)['utm_campaign'];
  } catch (_) {
    return null;
  }
}

/// Uloží kampaň lokálně při prvním spuštění. Odeslání pingu na metrics endpoint
/// (ANALYTICS_PLAN.md) je zatím jen lokální log - [endpoint] doplnit později.
class Ol1nAttribution {
  static const _key = 'ol1n_campaign';
  static const _doneKey = 'ol1n_attr_done';

  /// [readReferrer] vrací install referrer (Play) / campaign token (Apple).
  static Future<String?> captureOnFirstOpen(
    Future<String?> Function() readReferrer,
  ) async {
    final p = await SharedPreferences.getInstance();
    if (p.getBool(_doneKey) ?? false) return p.getString(_key);
    final campaign = parseCampaign(await readReferrer());
    await p.setBool(_doneKey, true);
    if (campaign != null) await p.setString(_key, campaign);
    return campaign;
  }
}
