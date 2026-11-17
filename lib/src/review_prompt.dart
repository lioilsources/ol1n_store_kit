import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'review_policy.dart';

/// Použití: volat [recordLaunch] při startu, [recordError] po chybě,
/// [requestReviewIfAppropriate] po "happy momentu" (level, uložený obrázek, pohádka).
class Ol1nReview {
  Ol1nReview._();
  static const _policy = ReviewPolicy();

  static Future<ReviewState> _load(SharedPreferences p) async => ReviewState(
        launches: p.getInt('ol1n_rev_launches') ?? 0,
        happyMoments: p.getInt('ol1n_rev_happy') ?? 0,
        lastPrompt: _dt(p.getInt('ol1n_rev_last')),
        lastErrorAt: _dt(p.getInt('ol1n_rev_err')),
      );

  static DateTime? _dt(int? ms) =>
      ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);

  static Future<void> recordLaunch() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('ol1n_rev_launches', (p.getInt('ol1n_rev_launches') ?? 0) + 1);
  }

  static Future<void> recordError() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('ol1n_rev_err', DateTime.now().millisecondsSinceEpoch);
  }

  /// [trigger] jen pro logování/budoucí analytiku.
  static Future<bool> requestReviewIfAppropriate(String trigger) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('ol1n_rev_happy', (p.getInt('ol1n_rev_happy') ?? 0) + 1);
    final now = DateTime.now();
    if (!_policy.shouldPrompt(await _load(p), now)) return false;
    final review = InAppReview.instance;
    if (!await review.isAvailable()) return false;
    await p.setInt('ol1n_rev_last', now.millisecondsSinceEpoch);
    await review.requestReview();
    return true;
  }
}
