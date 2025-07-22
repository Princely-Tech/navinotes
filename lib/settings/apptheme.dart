import 'package:navinotes/packages.dart';

double mobilePadding = 10;
double tabletPadding = 20;

Color shadowColor = AppTheme.black.withAlpha(0x19);
List<BoxShadow> boxShadows = [
  BoxShadow(
    color: shadowColor,
    blurRadius: 15,
    offset: Offset(0, 10),
    spreadRadius: 0,
  ),
  BoxShadow(
    color: shadowColor,
    blurRadius: 6,
    offset: Offset(0, 4),
    spreadRadius: 0,
  ),
];
List<BoxShadow> cardShadows = [
  BoxShadow(
    color: shadowColor,
    blurRadius: 3,
    offset: Offset(0, 1),
    spreadRadius: 0,
  ),
  BoxShadow(
    color: shadowColor,
    blurRadius: 2,
    offset: Offset(0, 1),
    spreadRadius: 0,
  ),
];

class AppTheme {
  AppTheme._();
  static const Color primaryColor = Color(0xFF10B981);
  static const Color black = Color(0xFF000000);
  static const Color mintCream = Color(0xFFE8F5E8);
  static const Color paleSage = Color(0xFFE0E8D9);
  static const Color softLinen = Color(0xFFF8F6F0);
  static const Color vanillaDust = Color(0xFFF5F5DC);
  static const Color caramelMist = Color(0xFFC4A484);
  static const Color royalGold = Color(0xFFD4AF37);
  static const Color cocoaVeil = Color(0x333C2A1E);
  static const Color oatCream = Color(0xFFF5F1E8);
  static const Color deepRoast = Color(0xFF3C2A1E);
  static const Color spicedAmber = Color(0xFFD97706);
  static const Color bloodFire = Color(0xFFDC2626);
  static const Color vitalGreen = Color(0xFF16A34A);
  static const Color electricViolet = Color(0xFF9333EA);
  static const Color solarGold = Color(0xFFEAB308);
  static const Color tealStone = Color(0xFF006D5B);
  static const Color jungleTeal = Color(0xFF0D8D7A);
  static const Color graphite = Color(0xFF333333);
  static const Color tropicalTeal = Color(0xFF1A9A84);
  static const Color mintWhisper = Color(0xFFDCFCE7);
  static const Color lavenderBlush = Color(0xFFF3E8FF);
  static const Color babyIce = Color(0xFFDBF8FE);
  static const Color polarGlow = Color(0xFBEEFFFF);
  static const Color skyFoam = Color(0xFFBFE7FE);
  static const Color pastelBloom = Color(0xFFEFFFFB);
  static const Color mintLight = Color(0xFFDBF9FE);
  static const Color azura = Color(0xFFEFFFFA);
  static const Color electricPurple = Color(0xFF7C3AED);
  static const Color orangeYellow = Color(0xFFFBBF24);
  static const Color teal = Color(0xFF14B8A6);
  static const Color pastelViolet = Color(0xFFF5F3FF);
  static const Color honeyDew = Color(0xFFECFDF5);
  static const Color ivory = Color(0xFFFFFBEB);
  static const Color softCoral = Color(0xFFF87171);
  static const Color violet = Color(0xFFA78BFA);
  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color whiteSmoke = Color(0xFFF9FAFB); //MAY be the default page bg aside white
  static const Color burntSienna = Color(0xFFB45309);
  static const Color royalViolet = Color(0xFF6D28D9);
  static const Color blushPink = Color(0xFFFECACA);
  static const Color periwinkle = Color(0xFFC7D2FE);
  static const Color softGold = Color(0xFFFDE68A);
  static const Color pastelPurple = Color(0xFFDDD6FE);
  static const Color paleJade = Color(0xFFA7F3D0);
  static const Color charcoalBlue = Color(0xFF111827);
  static const Color blueGray = Color(0xFF9CA3AF);
  static const Color lightAsh = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color defaultBlack = Color(0xFF1F2937);
  static const Color royalBlue = Color(0xFF1E3A8A);
  static const Color persianBlue = Color(0xFF1E40AF);
  static const Color deepTeel = Color(0xFF115E59);
  static const Color transparent = Colors.transparent;
  static const Color vividBlue = Color(0xFF3B82F6);
  static const Color aquaGreen = Color(0xFF2DD4BF);
  static const Color slateGray = Color(0xFFADAEBC);
  static const Color mintyAqua = Color(0xFFCCFBF1);
  static const Color mintGreen = Color(0xFF99F6E4);
  static const Color pastelBlue = Color(0xFFBFDBFE);
  static const Color lightGray = Color(0xFFE5E7EB);
  static const Color coolGray = Color(0xFFD1D5DB);
  static const Color darkSlateGray = Color(0xFF374151);
  static const Color strongBlue = Color(0xFF2563EB);
  static const Color iceBlue = Color(0xFFEFF6FF);
  static const Color paleBlue = Color(0xFFDBEAFE);
  static const Color whisperGrey = Color(0x4CEFEFEF);
  static const Color steelMist = Color(0xFF6B7280);
  static const Color jungleGreen = Color(0xFF059669);
  static const Color stormGray = Color(0xFF4B5563);
  static const Color electricIndigo = Color(0xFF1D4ED8);
  static const Color emeraldGreen = Color(0xFF047857);
  static const Color lightMintGreen = Color(0xFFD1FAE5);
  static const Color purple = Color(0xFFEDE9FE);
  static const Color yellow = Color(0xFFFEF3C7);
  static const Color softSkyBlue = Color(0xFF93C5FD);
  static const Color mintyGreen = Color(0xFF34D399);
  static const Color lavenderPurple = Color(0xFF8B5CF6);
  static const Color coralRed = Color(0xFFEF4444);
  static const Color amber = Color(0xFFF59E0B);
  static const Color dodgerBlue = Color(0xFF0075FF);
  static const Color gainsboro = Color(0xFFE5E5E5);
  static const Color vividRose = Color(0xFF00555A);
  static const Color abyssTeal = Color(0xFF1E788A);
  static const Color ivoryGlow = Color(0xFFFEFDF8);
  static const Color shadowBark = Color(0x193C2A1E);
  static const Color velvetCream = Color(0xCCF5F1E8);
  static const Color espressoShadow = Color(0xB23C2A1E);
  static const Color warmSand = Color(0xFFF5E6D3);
  static const Color espressoBrown = Color(0xFF4A3B32);
  static const Color burntLeather = Color(0xCC8B4513);
  static const Color fadedEmber = Color(0x4C3D1A00);
  static const Color burntClove = Color(0x662C1810);
  static const Color deepMoss = Color(0xFF355E3B);
  static const Color blazingCopper = Color(0xFFCC5500);
  static const Color moltenBrown = Color(0xFF1A0F08);
  static const Color walnutBronze = Color(0xFF8B7355);
  static const Color goldenSaffron = Color(0xFFC19B47);
  static const Color creamMist = Color(0xCCF4F1E8);
  static const Color rustWood = Color(0xFF8B5A2B);
  static const Color gumMetalBlue = Color(0xFF36454F);
  static const Color mossGreen = Color(0xFF4A7C59);
  static const Color sageMist = Color(0xFF9CAF88);
  static const Color dustyOlive = Color(0xFFB5C4A0);
  static const Color linen = Color(0xFFF9F7F4);
  static const Color lightSage = Color(0xFFF0F4E8);
  static const Color coffee = Color(0xFF6F4E37);
  static const Color darkMossGreen = Color(0xFF1B4332);
  static const Color lightSkyBlue = Color(0xFFE0F2FE);
  static const Color babyBlue = Color(0xFFBAE6FD);
  static const Color cerulean = Color(0xFF0369A1);
  static const Color deepPeach = Color(0x19FF8C42);
  static const Color lightRed = Color(0xFFFEE2E2);
  static const Color midGray = Color(0xFF8A8A8A);
  static const Color graniteGray = Color(0xFF4A4A4A);
  static const Color ghostWhite = Color(0xFFF5F5F5);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color snowGray = Color(0xFFFAFAFA);
  static const Color aliceBlue = Color(0xFFECF0F1);
  static const Color wetAsphalt = Color(0xFF2C3E50);
  static const Color steelBlue = Color(0xFF3498DB);
  static const Color asbestos = Color(0xFF7F8C8D);
  static const Color papayaWhip = Color(0xFFFFEDD5);
  static const Color burntOrange = Color(0xFFEA580C);
  static const Color silver = Color(0xFFBDC3C7);
  static const Color emerald = Color(0xFF22C55E);
  static const Color mediumOrchid = Color(0xFFA855F7);
  static const Color orange = Color(0xFFF97316);
  static const Color lightOrange = Color(0xFFFDBA74);
  static const Color almostWhite = Color(0xFFF8F9FA);
  static const Color yellowishOrange = Color(0x33E6B800);
  static const Color pearl = Color(0x7FFEF9E7);
  static const Color eggShell = Color(0x33F5F2E8);
  static const Color ivoryCream = Color(0xFFFAF7F0);
  static const Color almondCream = Color(0xFFF0EBE0);
  static const Color goldenTan = Color(0xFFBB8F59);
  static const Color sepiaBrown = Color(0xFF654321);
  static const Color jetCharcoal = Color(0xFF2F2F2F);
  static const Color lightBrown = Color(0xFFBC8F59);
  static const Color asparagus = Color(0x1987A96B);
  static const Color deepTealGreen = Color(0xFF065F46);
  // static const Color mediumOrchid = Color(0xFFFDBA74);
  // static const Color mediumOrchid = Color(0xFFFDBA74);

  static const String fontFamily = 'Inter';
  static const String fontPoppins = 'Poppins';
  static const String fontPlayfairDisplay = 'Playfair Display';
  static const String fontCrimsonPro = 'Crimson Pro';
  static const String fontCrimsonText = 'Crimson Text';
  static const String fontLibreBaskerville = 'Libre Baskerville';
  static const String fontEBGaramond = 'EB Garamond';
  static const String fontOpenSans = 'Open Sans'; //TODO bring in font

  static get text => TextStyle(
    color: defaultBlack,
    fontSize: 14.0,
    fontFamily: fontFamily,
    fontWeight: getFontWeight(400),
  );
}
