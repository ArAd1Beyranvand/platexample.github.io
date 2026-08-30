import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/showcase/device_cycle.dart';
import 'package:plate_number/model/plate_spec.dart';
import 'package:plate_number_holder/device_preview/device_config.dart';

void main() {
  test('specFor returns correct PlateSpec for each device', () {
    expect(specFor(DeviceType.mobile), PlateSpecs.irBicycle);
    expect(specFor(DeviceType.tablet), PlateSpecs.deCar);
    expect(specFor(DeviceType.desktop), PlateSpecs.irCar);
  });
}
