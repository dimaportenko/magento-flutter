import 'dart:convert' as json;
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'magento_repository.dart';
import '../config/config.dart';

class MagentoApiProvider implements Source {
  Client client = Client();

  Future<String> fetchHomeConfig() async {
    final response = await client.get(
      '${config.apiPath}/V1/cmsBlock/${config.homeCmsBlockId}',
      headers: config.headers,
    );
    final cmsData = json.jsonDecode(response.body);

    return cmsData['content'] as String;
  }
}
