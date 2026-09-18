import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/app/app_routes.dart';

void main() {
  test('root and /showcase are the same page', () {
    expect(AppTab.fromUri(Uri.parse('/')), AppTab.showcase);
    expect(AppTab.fromUri(Uri.parse('/showcase')), AppTab.showcase);
    expect(AppTab.fromUri(Uri.parse('https://platexample.ir/')), AppTab.showcase);
  });

  test('each tab answers to its own path, trailing slash included', () {
    expect(AppTab.fromUri(Uri.parse('/discover')), AppTab.discover);
    expect(AppTab.fromUri(Uri.parse('/discover/')), AppTab.discover);
    expect(AppTab.fromUri(Uri.parse('/about')), AppTab.about);
  });

  test('an unknown path falls back to the front page', () {
    expect(AppTab.fromUri(Uri.parse('/nope')), AppTab.showcase);
  });
}
