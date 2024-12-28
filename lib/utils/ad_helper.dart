import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2263996615198513/6235893444';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2263996615198513/6980631925';
    }

    throw UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2263996615198513/7331953899';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2263996615198513/6980631925';
    }

    throw UnsupportedError('Unsupported platform');
  }

  static Future<BannerAd?> createBannerAd({
    required void Function(BannerAd ad) onAdLoaded,
    required void Function(String error) onAdFailedToLoad,
    AdSize size = const AdSize(width: 400, height: 100),
  }) async {
    final BannerAd bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(ad as BannerAd),
        onAdFailedToLoad: (ad, err) => onAdFailedToLoad(err.toString()),
      ),
    );

    try {
      await bannerAd.load();
      return bannerAd;
    } catch (e) {
      onAdFailedToLoad(e.toString());
      return null;
    }
  }

}
