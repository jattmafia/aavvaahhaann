import 'package:flutter/foundation.dart';

import 'core/enums/app.dart';

enum Env { dev, prod }

class Config {
  static Env env = Env.dev;

  static void setProd() {
    env = Env.prod;
  }

  static String get supabaseProjectUrl =>
      env == Env.prod ? supabaseProjectUrlProd : supabaseProjectUrlDev;

  static String get supabaseAnonKey =>
      env == Env.prod ? supabaseAnonKeyProd : supabaseAnonKeyDev;

  static const String supabaseProjectUrlProd =
      "https://hjwmlcxlxihwgyvjzjak.supabase.co";

  static const String supabaseProjectUrlDev =
      "https://mkbvsgqlqljqnfvqtrku.supabase.co";

  static const String supabaseAnonKeyDev =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rYnZzZ3FscWxqcW5mdnF0cmt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE5NDk1NzMsImV4cCI6MjAxNzUyNTU3M30.BYZmTpsg39zkvK2RO-2L8CpAUhydud2BOMp-GSUZyzM";

  static const String supabaseAnonKeyProd =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhqd21sY3hseGlod2d5dmp6amFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY4NTc2OTQsImV4cCI6MjAyMjQzMzY5NH0.JJ--wYJvwr7Fh7DiBDmMmMZPAvhbD46ljiRXalbGZJk";

  static const String packageIdDev = "com.avahan.dev";
  static const String packageIdProd = "com.avahan";

  static const String _pageLinkDev = "avahandev.page.link";
  static const String _pageLinkProd = "avahan.page.link";

  static String get packageId => defaultTargetPlatform == TargetPlatform.iOS? "com.avahan.ios" : (env == Env.prod ? packageIdProd : packageIdDev);
  static String get pageLink => env == Env.prod ? _pageLinkProd : _pageLinkDev;

  static const String _serverClientIdDev =
      "804158452023-nosujudd3d9ape5pcohrvte5bb3dnf4m.apps.googleusercontent.com";
  static const String _serverClientProd =
      "906533537374-9kg15vocrggt9bet4gvbhp11vs80veso.apps.googleusercontent.com";

  static String get serverClientId =>
      env == Env.prod ? _serverClientProd : _serverClientIdDev;

  static App app = App.main;

  static String appLinkIos = "https://apps.apple.com/app/avahan-bhajan-katha-puja/id6449548456";

  static String get appLink =>
      defaultTargetPlatform == TargetPlatform.iOS ? appLinkIos : appLinkAndroid;

  static String appLinkAndroid =
      "https://play.google.com/store/apps/details?id=$packageIdProd";

  static String appSubscriptionsLink =
      "https://play.google.com/store/account/subscriptions?package=$packageIdProd";

  static bool get isAdmin => app == App.admin;

  static int version = 54;
  static int versionIos = 22;
  static bool force = false;
  static bool forceIos = false;

  static const String cscApiKey =
      "SE1DYzBVVTNzS2pHMGpoRTNEckM0ZTV2ZVVXaEJub0RxQlpRcFc5Vw==";

  static const String androidPurchaseApiKey =
      'goog_DVKFELVuwWDvHoCvueSGXQdQWda';


  static const String iosPurchaseApiKey =
      'appl_GBjggjonGPfCvRTKFsmuFwZChrv';
  static void setApp(App value) {
    app = value;
  }
}
