import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/poster/poster_tokens.dart';

Future<void> loadArchivo() async {
  final loader = FontLoader('Archivo');
  loader.addFont(rootBundle.load('assets/fonts/Archivo-latin.ttf'));
  loader.addFont(rootBundle.load('assets/fonts/Archivo-latin-ext.ttf'));
  await loader.load();
}

void main() {
  testWidgets('measure ROAD glyph boxes', (WidgetTester tester) async {
    await loadArchivo();
    final TextPainter tp = TextPainter(
      text: TextSpan(text: 'ROAD', style: PosterType.wordmark(1.0)),
      textDirection: TextDirection.ltr,
    )..layout();
    debugPrint('width=${tp.width} height=${tp.height}');
    debugPrint('baseline=${tp.computeDistanceToActualBaseline(TextBaseline.alphabetic)}');
    for (final m in tp.computeLineMetrics()) {
      debugPrint('line ascent=${m.ascent} descent=${m.descent} '
          'baseline=${m.baseline} height=${m.height}');
    }
    for (int i = 0; i < 4; i++) {
      final boxes = tp.getBoxesForSelection(
        TextSelection(baseOffset: i, extentOffset: i + 1),
      );
      for (final b in boxes) {
        debugPrint('[$i] ${b.left} .. ${b.right}  '
            'frac ${b.left / tp.width} .. ${b.right / tp.width}');
      }
    }
  });
}
