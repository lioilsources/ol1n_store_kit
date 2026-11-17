/// Čistá logika pravidel pro review prompt (testovatelná bez pluginů).
class ReviewState {
  const ReviewState({
    this.launches = 0,
    this.happyMoments = 0,
    this.lastPrompt,
    this.lastErrorAt,
  });
  final int launches;
  final int happyMoments;
  final DateTime? lastPrompt;
  final DateTime? lastErrorAt;
}

class ReviewPolicy {
  const ReviewPolicy({
    this.minLaunches = 2,
    this.minHappyMoments = 1,
    this.cooldown = const Duration(days: 60),
    this.errorQuiet = const Duration(minutes: 10),
  });
  final int minLaunches;
  final int minHappyMoments;
  final Duration cooldown;
  final Duration errorQuiet;

  bool shouldPrompt(ReviewState s, DateTime now) {
    if (s.launches < minLaunches) return false;
    if (s.happyMoments < minHappyMoments) return false;
    if (s.lastPrompt != null && now.difference(s.lastPrompt!) < cooldown) {
      return false;
    }
    if (s.lastErrorAt != null && now.difference(s.lastErrorAt!) < errorQuiet) {
      return false;
    }
    return true;
  }
}
