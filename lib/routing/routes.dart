abstract final class Routes {
  static const home = '/';
  static const dashboard = '/dashboard';
  static const create = '/$createRelative';
  static const login = '/$loginRelative';

  static const data = '/$dataRelative';
  static const transactions = '$data/$transactionsRelative';
  static const products = '$data/$productsRelative';
  static const transactionPartners = '$data/$transactionPartnersRelative';
  static const companies = '$data/$companiesRelative';

  static const createRelative = 'create';
  static const dataRelative = 'data';
  static const loginRelative = 'login';
  static const transactionsRelative = 'transactions';
  static const productsRelative = 'products';
  static const transactionPartnersRelative = 'transaction-partners';
  static const companiesRelative = 'companies';
}
