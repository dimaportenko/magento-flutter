import '../resources/magento_repository.dart';

class Bloc {
  final _repository = MagentoRepository();

  test() {
    _repository.fetchHomeData();
  }
}
