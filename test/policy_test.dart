import 'package:flutter_test/flutter_test.dart';
import 'package:ol1n_store_kit/ol1n_store_kit.dart';

void main() {
  const policy = ReviewPolicy();
  final now = DateTime(2026, 11, 10);

  test('needs 2 launches and a happy moment', () {
    expect(policy.shouldPrompt(const ReviewState(launches: 1, happyMoments: 1), now), isFalse);
    expect(policy.shouldPrompt(const ReviewState(launches: 2, happyMoments: 0), now), isFalse);
    expect(policy.shouldPrompt(const ReviewState(launches: 2, happyMoments: 1), now), isTrue);
  });

  test('60 day cooldown', () {
    expect(
        policy.shouldPrompt(
            ReviewState(launches: 5, happyMoments: 3, lastPrompt: now.subtract(const Duration(days: 30))), now),
        isFalse);
    expect(
        policy.shouldPrompt(
            ReviewState(launches: 5, happyMoments: 3, lastPrompt: now.subtract(const Duration(days: 61))), now),
        isTrue);
  });

  test('never right after an error', () {
    expect(
        policy.shouldPrompt(
            ReviewState(launches: 5, happyMoments: 3, lastErrorAt: now.subtract(const Duration(minutes: 1))), now),
        isFalse);
  });

  test('parseCampaign', () {
    expect(parseCampaign('utm_source=qr&utm_campaign=chrestys'), 'chrestys');
    expect(parseCampaign(null), isNull);
    expect(parseCampaign('utm_source=organic'), isNull);
  });
}
