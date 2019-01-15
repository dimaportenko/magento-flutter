import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as json;

class Config {
  String baseUrl;
  String accessToken;
  String homeCmsBlockId;
  String apiPath;
  Map<String, String> headers = Map<String, String>();
  Future initialized;

  Config() {
    initialized = init();
  }

  init() async {
    final configJson = await loadAsset();
    final config = json.jsonDecode(configJson);
    baseUrl = config['base_url'];
    accessToken = config['access_token'];
    homeCmsBlockId = config['home_cms_block_id'];
    apiPath = '${baseUrl}rest/default';
    headers['Authorization'] = 'Bearer ${this.accessToken}';
    headers['User-Agent'] = 'Dmytro Portenko Magento Library';
    headers['Content-Type'] = 'application/json';
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }
}

Config config = Config();