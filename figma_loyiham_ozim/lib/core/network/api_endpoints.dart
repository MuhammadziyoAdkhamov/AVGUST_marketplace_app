/// Keyinchalik backend ulanadi. Hozircha faqat shartnoma.
class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.avgust.local',
  );

  static const login = '/auth/login';
  static const register = '/auth/register';
  static const products = '/products';
  static const categories = '/categories';
  static const cart = '/cart';
  static const orders = '/orders';
}
