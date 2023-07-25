import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class AppTypography {
  /// font familys

  static const String fontFamilyProxima = "ProximaNova";
  static const String fontFamilyProduct = "ProximaNova";

  static const tinyText = TextStyle(
    fontFamily: fontFamilyProxima,
    fontSize: 8,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const tinyText2 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.2,
    color: AppColors.greyB3,
  );

  static const tinyText2Large = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
    color: AppColors.greyAD,
  );

  static final tinyText2LargeRed = tinyText2Large.copyWith(
    color: AppColors.red5B,
  );

  static const p = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    // height: 1.6,
    color: AppColors.blueFF,
  );

  static final pBlueAlert = p.copyWith(
    color: AppColors.blueAlert,
  );

  static final pHRed5B = p.copyWith(
    height: 1.1,
    color: AppColors.red5B,
  );

  static const pDark33 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: AppColors.dark33,
  );

  static const pDark33SemiBoldPro = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1.5,
    color: AppColors.dark33,
  );

  static const pGrey97 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: AppColors.grey97,
  );

  static final pDark33H = pDark33.copyWith(
    height: 1.3,
  );

  static final pDark33SemiBold = pDark33.copyWith(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w600,
  );

  static final pSemiBold = p.copyWith(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
    color: null,
  );

  static const pSmall1 = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w700,
    fontSize: 17,
    height: 1.4,
    color: AppColors.dark33,
  );

  static final pSmall1NH = pSmall1.copyWith(
    height: null,
  );

  static const pSmall1P = TextStyle(
    fontFamily: fontFamilyProxima,
    fontSize: 17,
    color: AppColors.dark33,
  );

  static final pSmall1Dark00 = pSmall1P.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.dark00,
  );

  static final pSmall1Dark00SemiBold = pSmall1Dark00.copyWith(
    fontWeight: FontWeight.w600,
  );

  static const pSmallGrey85 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 17,
    height: 1.3,
    color: AppColors.grey85,
  );

  static final pSmallDark33 = pSmallGrey85.copyWith(
    color: AppColors.dark33,
  );

  static final pSmallDark33Medium = pSmallDark33.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final pSmallDark33H11 = pSmallDark33.copyWith(
    height: 1.1,
  );

  static final pSmall1SemiBoldDark33 = pSmall1.copyWith(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
  );

  static final pSamll1SemiBoldDark00 = pSmall1SemiBoldDark33.copyWith(
    color: AppColors.dark00,
  );

  static const pSmall1SemiBold = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
    fontSize: 17,
    color: AppColors.greyD6,
  );

  static final pSmall1SemiBoldWhite = pSmall1SemiBold.copyWith(
    color: AppColors.white,
  );

  static final pSmall1SemiBoldRed5B = pSmall1SemiBoldWhite.copyWith(
    color: AppColors.red5B,
  );

  static const pSmallRegular = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 17,
    color: AppColors.greyAD,
  );

  static final pSmallRegularDark = pSmallRegular.copyWith(
    height: 22 / 16,
    color: AppColors.dark00,
  );
  static final pSmallRegularGrey9A = pSmallRegularDark.copyWith(
    color: AppColors.grey9A,
  );

  static final pSmallRegularDark00 = pSmallRegular.copyWith(
    fontFamily: fontFamilyProduct,
    fontStyle: FontStyle.normal,
    height: 22 / 17,
    color: AppColors.dark00,
  );

  static final pSmallRegularDark33 = pSmallRegularDark00.copyWith(
    height: 24 / 17,
    color: AppColors.dark33,
  );

  static final pSmallRegularDark33Bold = pSmallRegularDark33.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final pSmallRegularDark33SemiBold = pSmallRegularDark33.copyWith(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
  );

  static final pSmallRegularWhite = pSmallRegularDark00.copyWith(
    color: AppColors.white,
  );

  static const pSmall = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.4,
    color: AppColors.dark6A,
  );

  static const pSmallDark00 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.dark00,
    height: 1.5,
  );

  static const pSmallRedBold = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: fontFamilyProxima,
    fontSize: 16,
    decoration: TextDecoration.none,
    color: AppColors.redAlert,
  );

  static final pSmallBlueBold = pSmallRedBold.copyWith(
    color: AppColors.blueAlert,
  );

  static const pSmallBlack = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  static const pSmallMedium = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const pSmallSemiBold = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.6,
    color: AppColors.dark33,
  );

  static final guideStyle = TextStyle(
    color: AppColors.dark33.withOpacity(.8),
    fontFamily: fontFamilyProduct,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final pSmall2 = pSmall.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.dark33,
    height: null,
  );

  static const pSmall3 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: AppColors.greyAD,
  );

  static final pSmall3CharcoalGray = pSmall3.copyWith(
    color: AppColors.charcoalGray,
  );

  static final pSmall3Grey84_ = pSmall3.copyWith(
    color: AppColors.grey84,
  );

  static final pSmall3Grey97 = pSmall3.copyWith(
    color: AppColors.grey97,
  );

  static final pSmall3Dark00 = pSmall3.copyWith(
    height: 22 / 15,
    color: AppColors.dark00,
  );

  static final pSmall3H = pSmall3.copyWith(
    height: 1.3,
  );

  static final pSmall3Grey84 = pSmall3Dark00.copyWith(
    fontStyle: FontStyle.normal,
    color: AppColors.grey84,
  );

  static final pSmall3Yellow16 = pSmall3.copyWith(
    fontFamily: fontFamilyProduct,
    height: 1.6,
    color: AppColors.yellow16,
  );

  static final pSmall3Dark3306 = pSmall3.copyWith(
    height: 1.5,
    color: AppColors.dark33.withOpacity(0.6),
  );

  static final pSmall3Medium = pSmall3.copyWith(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w500,
  );

  static final pSmall3Dark33 = pSmall3.copyWith(
    color: AppColors.dark33,
  );

  static final pSmall3Dark33Medium = pSmall3Dark33.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final pSmallDark33Bold = pSmall3Dark33.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final pSmall3Dark33H15 = pSmall3Dark33.copyWith(
    height: 1.5,
  );

  static final pSmall3Dark33H14 = pSmall3Dark33.copyWith(
    height: 1.4,
  );

  static final pSmall3Dark33H = pSmall3Dark33.copyWith(
    fontStyle: FontStyle.normal,
    height: 22 / 13,
  );

  static final pSmallRedB5 = pSmall3.copyWith(
    color: AppColors.red5B,
  );

  static final pSmall32 = pSmall3.copyWith(
    fontFamily: fontFamilyProduct,
    color: AppColors.dark33,
  );

  static const pTiny = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.4,
    color: AppColors.grey95,
  );

  static const pTinyBoldBlue91 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w700,
    fontSize: 13,
    color: AppColors.blue91,
  );

  static final pTinyBoldRedAlert = pTinyBoldBlue91.copyWith(
    color: AppColors.redAlert,
  );

  static const pTinyYellow = TextStyle(
    fontFamily: fontFamilyProxima,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 16 / 13,
    color: AppColors.yellow00,
  );

  static final pTinyDark33 = pTinyYellow.copyWith(
    height: 18 / 13,
    color: AppColors.dark33,
  );

  static final pTinyDark33Normal = pTinyDark33.copyWith(
    fontWeight: FontWeight.w400,
  );

  static final pTinyGrey94 = pTinyDark33.copyWith(
    fontWeight: FontWeight.w400,
    color: AppColors.grey94,
  );

  static final pTinyGrey84 = pTiny.copyWith(
    color: AppColors.grey84,
  );

  static final pTinyGreyE9 = pTinyGrey94.copyWith(
    color: AppColors.greyE9,
  );

  static final pTinyGreyADMedium = pTinyDark33.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.greyAD,
  );

  static final pTinyYellow16 = pTinyYellow.copyWith(
    color: AppColors.yellow16,
  );

  static final pTinyGreyB3 = pTiny.copyWith(
    color: AppColors.greyB3,
  );

  static final pTinyGreyAD = pTiny.copyWith(
    color: AppColors.greyAD,
  );

  static final pTinyGreyADH11 = pTinyGreyAD.copyWith(
    height: 1.1,
  );

  static final pTinyGreyADH15 = pTinyGreyAD.copyWith(
    height: 1.5,
  );

  static final pTinyDark00 = pTiny.copyWith(
    color: AppColors.dark00,
  );

  static const pTiny2 = TextStyle(
    fontFamily: fontFamilyProxima,
    color: AppColors.dark6A,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const pTinyPro = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.1,
  );

  static const pTiny2BoldRed = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyProxima,
    fontSize: 14,
    decoration: TextDecoration.none,
    color: AppColors.redAlert,
  );

  static final pTiny2BoldBlue = pTiny2BoldRed.copyWith(
    color: AppColors.blueAlert,
  );

  static final pTiny2Dark00 = pTiny2.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.dark00,
  );

  static const pTiny215 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontSize: 15,
    height: 22 / 15,
    color: AppColors.dark33,
  );

  static const pTiny215ProDark33 = TextStyle(
    fontFamily: fontFamilyProduct,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 22 / 15,
    color: AppColors.dark33,
  );
  static const pTiny215Pro = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.5,
    color: AppColors.dark33,
  );

  static final pTiny215ProGreyAD = pTiny215ProDark33.copyWith(
    color: AppColors.greyAD,
  );

  static final pTiny215ProGrey84 = pTiny215ProDark33.copyWith(
    color: AppColors.grey84,
  );

  static const pTiny215Yellow = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 24 / 15,
    color: AppColors.yellow00,
  );

  static const pTiny215YellowNormal = TextStyle(
    fontFamily: fontFamilyProduct,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: AppColors.yellow00,
  );

  static const pTiny2GreyAD = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: AppColors.greyAD,
  );

  static final pTiny215GreyAD = pTiny215.copyWith(
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.greyAD,
  );

  static final pTiny215GreyADnh = pTiny215GreyAD.copyWith(height: null);

  static const h3Small = TextStyle(
    fontFamily: fontFamilyProxima,
    color: AppColors.dark00,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const h3Small2 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontSize: 19,
    fontWeight: FontWeight.w600,
  );

  static final h3 = TextStyle(
    color: AppColors.dark33.withOpacity(.8),
    fontFamily: fontFamilyProduct,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static final h3Dark00 = h3.copyWith(
    color: AppColors.dark00,
    fontWeight: FontWeight.w600,
  );

  static final h3charcoalGray = h3.copyWith(
    color: AppColors.charcoalGray,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyProxima,
  );

  static const h3Large = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w500,
    fontSize: 21,
    color: AppColors.dark33,
  );

  static const h2Small = TextStyle(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: 1.3,
    color: AppColors.dark00,
  );

  static final h2SmallDark33SBold = h2Small.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.dark33,
  );

  static final h2SmallDarkSBoldH = h2SmallDark33SBold.copyWith(
    height: null,
    fontWeight: FontWeight.w700,
  );

  static final h2SmallSemiBold = h2Small.copyWith(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w600,
    color: AppColors.dark33,
  );

  static const h2SmallYellow = TextStyle(
    fontFamily: fontFamilyProduct,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 22,
    height: 28 / 22,
    color: AppColors.yellow00,
  );

  static final h2SmallDark00 = h2SmallYellow.copyWith(
    color: AppColors.dark00,
  );

  static final h2SmallDark00Medium = h2SmallDark00.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final h2SmallDark33 = h2Small.copyWith(
    fontWeight: FontWeight.w700,
    color: AppColors.dark33,
    height: null,
  );

  static final h2SmallDark33Normal = h2SmallYellow.copyWith(
    color: AppColors.dark33,
  );

  static final h2SmallDark33Medium = h2SmallDark33Normal.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final h2SmallDark33SemiBold = h2SmallDark33.copyWith(
    fontWeight: FontWeight.w600,
  );

  static const h2 = TextStyle(
    color: AppColors.dark33,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilyProduct,
    fontSize: 24,
    height: 1.4,
    fontStyle: FontStyle.normal,
  );

  static const h2ExtraLarge = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: fontFamilyProduct,
    fontSize: 28,
    height: 1.1,
    fontStyle: FontStyle.normal,
  );

  static const h1 = TextStyle(
    fontFamily: fontFamilyProxima,
    fontWeight: FontWeight.w500,
    fontSize: 32.0,
    height: 1.1,
    color: AppColors.dark33,
  );

  static final h1Normal = h1.copyWith(
    fontWeight: FontWeight.w400,
  );

  static final h1Bold = h1.copyWith(
    fontFamily: fontFamilyProduct,
    fontWeight: FontWeight.w700,
  );
}
