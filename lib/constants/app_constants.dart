class AppConstants {
  static const String appName = 'Demo App';
  static const double appVersion = 1.0;

  // Shared Preference Key
  static const String token = 'token';
  static const String user = 'user';
  static const String isLogin = 'is_login';

  // API BASE URLS
  static const String apiBaseUrl = 'http://157.245.109.105:5555/';
  static const String mediaBaseUrl = 'http://157.245.109.105:5555';

  // // API BASE URLS
  // static const String apiBaseUrl = 'http://192.168.1.25:8000/';
  // static const String mediaBaseUrl = 'http://192.168.1.25:8000';
  // // API BASE URLS
  // static const String apiBaseUrl = 'http://192.168.34.68:8000/';
  // static const String mediaBaseUrl = 'http://192.168.34.68:8000';
//API URLS
  static const String registerUrl = 'user-management/register-user';
  static const String loginUrl = 'user-management/login-user';
  static const String fetchUsersUrl = 'user-management/user-information/all/';

  static const String createPermit = 'service-management/request-get-permit';
  static const String fetchPermits = 'service-management/get-all-permit';
  static const String changeStatus = 'service-management/change-permit-status';

  // static List<LanguageModel> languages = [
  //   LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
  //   LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA',flutter  languageCode: 'ar'),
  // ];

  static List<String> regions = [
    "Arusha",
    "Dar es Salaam",
    "Dodoma",
    "Geita",
    "Iringa",
    "Kagera",
    "Katavi",
    "Kigoma",
    "Kilimanjaro",
    "Lindi",
    "Manyara",
    "Mara",
    "Mbeya",
    "Morogoro",
    "Mtwara",
    "Mwanza",
    "Njombe",
    "Pemba North",
    "Pemba South",
    "Pwani",
    "Rukwa",
    "Ruvuma",
    "Shinyanga",
    "Simiyu",
    "Singida",
    "Tabora",
    "Tanga",
    "Zanzibar Central/South",
    "Zanzibar North",
    "Zanzibar Urban/West"
  ];
  static List<String> permits = ["TRANSFER", "SELLING"];
  static List<String> animals = ["Goats", "Cows", "Sheep", "Pig"];

  static String getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
