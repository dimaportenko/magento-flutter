import 'dart:convert' as json;
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'magento_repository.dart';
import '../config/config.dart';

class MagentoApiProvider implements Source {
  Client client = Client();

  Future<String> fetchHomeConfig() async {
    print('fetchHomeConfig');
    await config.initialized;
    final response = await client.get(
      '${config.apiPath}/V1/cmsBlock/${config.homeCmsBlockId}',
      headers: config.headers,
    );
    final cmsData = json.jsonDecode(response.body);

    return cmsData['content'] as String;
  }

  Future<String> fetchStoreConfig() async {
    print('fetchStoreConfig');
    await config.initialized;
    final response = await client.get(
      '${config.apiPath}/V1/store/storeConfigs',
      headers: config.headers,
    );

    return response.body.toString();
  }

  Future<String> fetchProductsForCategory({int categoryId, int pageSize = 1, int offset = 0}) async {
    final currentPage = (offset / pageSize + 1).toInt();
    final params = <String, dynamic>{
      'searchCriteria[filterGroups][0][filters][0][field]': 'category_id',
      'searchCriteria[filterGroups][0][filters][0][value]': categoryId,
      'searchCriteria[filterGroups][0][filters][0][conditionType]': 'eq',
      'searchCriteria[filterGroups][1][filters][0][field]': 'visibility',
      'searchCriteria[filterGroups][1][filters][0][value]': '4',
      'searchCriteria[filterGroups][1][filters][0][conditionType]': 'eq',
      'searchCriteria[pageSize]': pageSize,
      'searchCriteria[currentPage]': currentPage
    };

    String paramsString = '';
    String separator = '?';
    params.forEach((key, value) {
      paramsString = '$paramsString$separator$key=$value';
      separator = '&';
    });

    final response = await client.get(
      '${config.apiPath}/V1/products$paramsString',
      headers: config.headers,
    );

    final body = response.body;
    print(body);

    return response.body.toString();
  }
}
