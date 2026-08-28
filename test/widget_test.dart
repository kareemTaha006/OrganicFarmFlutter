import 'package:flutter_test/flutter_test.dart';
import 'package:organic_farm/core/constants/api_constants.dart';

void main() {
  test('API base URL is configured', () {
    expect(ApiConstants.baseUrl, 'https://theorgaincfarm.com/api/');
  });
}
