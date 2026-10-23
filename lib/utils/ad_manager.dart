import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static const bool _testMode = true; // set to false for production

  // Ad Unit IDs
  static String get bannerAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Google test banner
    }
    return 'ca-app-pub-2350572386584705/9840115937'; // Real ID
  }

  // Used for the 300x250 ad on the pause screen.
  // In AdMob, create a new *Banner* ad unit for this and paste its ID below.
  static String get mediumRectangleAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Google test banner
    }
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // Real ID
  }

  static String get interstitialAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    }
    return 'ca-app-pub-2350572386584705/9840115937'; // Real ID (replace: needs its own interstitial unit)
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
  }

  /// 300x250 ad. The caller owns the ad: call `.load()`, show it with
  /// `AdWidget`, and dispose it (including inside [onFailed]).
  static BannerAd createMediumRectangleAd({
    required VoidCallback onLoaded,
    required VoidCallback onFailed,
  }) {
    return BannerAd(
      adUnitId: mediumRectangleAdUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) => onFailed(),
      ),
    );
  }

  static Future<InterstitialAd?> loadInterstitialAd() async {
    InterstitialAd? ad;
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (a) => ad = a,
        onAdFailedToLoad: (error) => ad = null,
      ),
    );
    return ad;
  }
}