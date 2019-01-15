import 'package:rxdart/rxdart.dart';
import '../resources/magento_repository.dart';
import '../config/config.dart';

class Bloc {
  final _repository = MagentoRepository();
  final _homeConfig = BehaviorSubject<Map<String, dynamic>>();
  final _storeConfig = BehaviorSubject<List<dynamic>>();

  Observable<Map<String, dynamic>> get homeConfig => _homeConfig.stream;
  Observable<List<dynamic>> get storeConfig => _storeConfig.stream;

  Bloc() {
    fetchStoreConfig();
    _storeConfig.stream.listen((data) {
      config.setStoreConfig(data[0]);
      fetchHomeConfig();
    });
  }

  fetchHomeConfig() async {
    final config = await _repository.fetchHomeData();
    _homeConfig.sink.add(config);
  }

  fetchStoreConfig() async {
    final config = await _repository.fetchStoreConfig();
    _storeConfig.sink.add(config);
  }

  clearCache() {
    return _repository.clearCache();
  }

  dispose() {
    _homeConfig.close();
    _storeConfig.close();
  }
}
