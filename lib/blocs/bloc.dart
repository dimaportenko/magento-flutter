import 'package:rxdart/rxdart.dart';
import '../resources/magento_repository.dart';

class Bloc {
  final _repository = MagentoRepository();
  final _homeConfig = BehaviorSubject<Map<String, dynamic>>();

  Observable<Map<String, dynamic>> get homeConfig => _homeConfig.stream;

  fetchHomeConfig() async {
    final config = await _repository.fetchHomeData();
    print(config);
    _homeConfig.sink.add(config);
  }

  clearCache() {
    return _repository.clearCache();
  }

  dispose() {
    _homeConfig.close();
  }
}
