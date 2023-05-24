class Images {
  static const String intro1 = "assets/images/intro_1.png";
  static const String intro2 = "assets/images/intro_2.png";
  static const String intro3 = "assets/images/intro_3.png";
  static const String splashImage = "assets/images/splashImage.png";
  static const String splashLogo = "assets/images/splashLogo.png";
  // static const String splashVideo = "assets/images/splash video.mp4";
  static const String walkthrouLogo = "assets/images/wallkthroulogo.png";
  static const String logo = "assets/images/logo.png";
  static const String slide = "assets/images/slide.png";
  static const String whatsapp = "assets/images/whatsapp.png";
  static const String telegram = "assets/images/telegram.png";
  static const String viber = "assets/images/viber.png";
  static const String facebook = "assets/images/facebook.png";
  static const String flickr = "assets/images/flickr.png";
  static const String google = "assets/images/google.png";
  static const String linkedin = "assets/images/linkedin.png";
  static const String pinterest = "assets/images/pinterest.png";
  static const String youtube = "assets/images/youtube.png";
  static const String twitter = "assets/images/twitter.png";
  static const String tumblr = "assets/images/tumblr.png";
  static const String instagram = "assets/images/instagram.png";
  static const String menuIcon = "assets/images/menu icon.png";
  static const String aerro = "assets/images/arrow-svgrepo-com.png";
  static const String videoLink = "https://app.starinnsuitesandretreat.com/custom/videos/splash.mp4";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
