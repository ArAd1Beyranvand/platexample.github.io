import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/app/app.dart';

void main() {
  testWidgets('showcase renders its poster chrome', (tester) async {
    await tester.pumpWidget(const PlateNumberShowcaseApp());
    await tester.pump();

    expect(find.text('ARAD BIRANVAND'), findsOneWidget);
    expect(find.text('PLATE'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 601));
  });

  testWidgets('showcase fits each responsive tier without render errors', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const sizes = <Size>[
      Size(1920, 1080),
      Size(1440, 900),
      Size(1024, 768),
      Size(800, 600),
      Size(400, 880),
    ];

    for (final size in sizes) {
      await tester.binding.setSurfaceSize(size);
      final errors = <FlutterErrorDetails>[];
      final previousOnError = FlutterError.onError;
      FlutterError.onError = errors.add;
      try {
        await tester.pumpWidget(const PlateNumberShowcaseApp());
        await tester.pump();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 601));
      } finally {
        FlutterError.onError = previousOnError;
      }

      expect(
        errors,
        isEmpty,
        reason: 'responsive showcase failed at ${size.width}x${size.height}',
      );
    }
  });

  testWidgets('showcase completes a device cycle without render errors', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final errors = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      await tester.pumpWidget(const PlateNumberShowcaseApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 2));
    } finally {
      FlutterError.onError = previousOnError;
    }

    expect(errors, isEmpty);
  });
}
