import 'dart:async';
import 'dart:convert' as json;
import 'magento_api_provider.dart';
import 'magento_db_provider.dart';

class MagentoRepository {
  List<Source> sources = <Source>[
    magentoDbProvider,
    MagentoApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    magentoDbProvider,
  ];

  Future<Map<String, dynamic>> fetchHomeData() async {
    String homeConfig;
    var source;

    for(source in sources) {
      homeConfig = await source.fetchHomeConfig();
      if (homeConfig != null) {
        break;
      }
    }

    for(var cache in caches) {
      if (cache != source) {
        cache.addConfig('home', homeConfig);
      }
    }

    return json.jsonDecode(homeConfig);
  }

  Future<List<dynamic>> fetchStoreConfig() async {
    String config;
    var source;

    for(source in sources) {
      config = await source.fetchStoreConfig();
      if (config != null) {
        break;
      }
    }

    for(var cache in caches) {
      if (cache != source) {
        cache.addConfig('store', config);
      }
    }

    return json.jsonDecode(config);
  }

  getProducts(categoryId) {
    MagentoApiProvider().fetchProductsForCategory(categoryId: categoryId);
  }

  clearCache() async {
    for(var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<String> fetchStoreConfig();
  Future<String> fetchHomeConfig();
}

abstract class Cache {
  Future<int> addConfig(String name, String content);
  clear();
}
