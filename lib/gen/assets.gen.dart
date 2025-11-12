// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/EDIT.png
  AssetGenImage get edit => const AssetGenImage('assets/icons/EDIT.png');

  /// File path: assets/icons/back.png
  AssetGenImage get back => const AssetGenImage('assets/icons/back.png');

  /// File path: assets/icons/calander.png
  AssetGenImage get calander =>
      const AssetGenImage('assets/icons/calander.png');

  /// File path: assets/icons/changePass.png
  AssetGenImage get changePass =>
      const AssetGenImage('assets/icons/changePass.png');

  /// File path: assets/icons/completed.png
  AssetGenImage get completed =>
      const AssetGenImage('assets/icons/completed.png');

  /// File path: assets/icons/darkmode.png
  AssetGenImage get darkmode =>
      const AssetGenImage('assets/icons/darkmode.png');

  /// File path: assets/icons/filter.png
  AssetGenImage get filter => const AssetGenImage('assets/icons/filter.png');

  /// File path: assets/icons/info.png
  AssetGenImage get info => const AssetGenImage('assets/icons/info.png');

  /// File path: assets/icons/noNotification.png
  AssetGenImage get noNotification =>
      const AssetGenImage('assets/icons/noNotification.png');

  /// File path: assets/icons/notificationSettings.png
  AssetGenImage get notificationSettings =>
      const AssetGenImage('assets/icons/notificationSettings.png');

  /// File path: assets/icons/rejected.png
  AssetGenImage get rejected =>
      const AssetGenImage('assets/icons/rejected.png');

  /// File path: assets/icons/search.png
  AssetGenImage get search => const AssetGenImage('assets/icons/search.png');

  /// File path: assets/icons/success.png
  AssetGenImage get success => const AssetGenImage('assets/icons/success.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        edit,
        back,
        calander,
        changePass,
        completed,
        darkmode,
        filter,
        info,
        noNotification,
        notificationSettings,
        rejected,
        search,
        success
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/dummyBg1.jpg
  AssetGenImage get dummyBg1 =>
      const AssetGenImage('assets/images/dummyBg1.jpg');

  /// File path: assets/images/generate token.png
  AssetGenImage get generateToken =>
      const AssetGenImage('assets/images/generate token.png');

  /// File path: assets/images/loginBg.png
  AssetGenImage get loginBg => const AssetGenImage('assets/images/loginBg.png');

  /// File path: assets/images/loginBg2.png
  AssetGenImage get loginBg2 =>
      const AssetGenImage('assets/images/loginBg2.png');

  /// File path: assets/images/muziris.png
  AssetGenImage get muziris => const AssetGenImage('assets/images/muziris.png');

  /// File path: assets/images/muziriswhite.png
  AssetGenImage get muziriswhite =>
      const AssetGenImage('assets/images/muziriswhite.png');

  /// File path: assets/images/splashBg1.png
  AssetGenImage get splashBg1 =>
      const AssetGenImage('assets/images/splashBg1.png');

  /// File path: assets/images/splashBg2.png
  AssetGenImage get splashBg2 =>
      const AssetGenImage('assets/images/splashBg2.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        dummyBg1,
        generateToken,
        loginBg,
        loginBg2,
        muziris,
        muziriswhite,
        splashBg1,
        splashBg2
      ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
