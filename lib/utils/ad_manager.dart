import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static const bool _testMode = true; // set to false for production

  // Ad Unit IDs
  static String get bannerAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-2350572386584705~9269164127'; // Test ID
    }
    return 'ca-app-pub-2350572386584705~9269164127'; // Real ID
  }

  static String get interstitialAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    }
    return 'ca-app-pub-2350572386584705~9269164127'; // Real ID
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