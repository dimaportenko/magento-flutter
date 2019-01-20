import 'dart:async';
import 'dart:convert' as json;
import 'magento_api_provider.dart';
import 'magento_db_provider.dart';
import '../models/product_model.dart';

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

  Future<List<ProductModel>> getProducts(categoryId) async {
    final result = await MagentoApiProvider().fetchProductsForCategory(categoryId: categoryId);
    final decoded = json.jsonDecode(result);

    var products;
    if (decoded != null && decoded['items'] != null) {
       products = decoded['items'].map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    }

    print('products');
    print(products);

    return List<ProductModel>.from(products);
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
