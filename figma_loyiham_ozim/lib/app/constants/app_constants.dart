class AppConstants {
  AppConstants._();

  static const appName = 'Avgust';
  static const countryCode = '+998';
  static const minPasswordLength = 8;
}

class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const register = '/register';
  static const role = '/role';

  static const home = '/home';
  static const wholesale = '/home/wholesale';
  static const allCategories = '/home/categories';

  static const catalog = '/catalog';
  static String product(String id) => '/catalog/product/$id';
  static String productVideo(String id) => '/catalog/product/$id/video';

  static const cart = '/cart';
  static const orders = '/orders';

  static const profile = '/profile';
  static const favorites = '/profile/favorites';
  static const promotions = '/promotions';
  static const settings = '/settings';
  static const help = '/help';
  static const about = '/about';
  static const notifications = '/notifications';
  static const chat = '/chat';
}
