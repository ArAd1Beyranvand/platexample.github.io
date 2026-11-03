import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/newdesign/embed/embed_host.dart';
import 'package:plate_number_holder/newdesign/embed/handover.dart';

class _Probe extends StatefulWidget {
  const _Probe(this.name, this.log, {super.key});
  final String name;
  final List<String> log;
  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  void initState() {
    super.initState();
    widget.log.add('init ${widget.name}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.log.add(
      '${widget.name} leaving=${EmbedLeaving.of(context)} held=${EmbedHeld.of(context)}',
    );
  }

  @override
  void dispose() {
    widget.log.add('dispose ${widget.name}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(widget.name);
}

void main() {
  testWidgets('the outgoing embed leaves in place; the next mounts after', (t) async {
    final List<String> log = <String>[];
    Widget app(String name) => MaterialApp(
      home: EmbedHandover(
        embed: true,
        child: _Probe(name, log, key: ValueKey<String>(name)),
      ),
    );
    await t.pumpWidget(app('a'));
    log.clear();
    await t.pumpWidget(app('b'));
    expect(log, contains('a leaving=true held=false'));
    expect(log.where((e) => e.startsWith('dispose')), isEmpty);
    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsNothing);
    await t.pump(const Duration(milliseconds: 1750));
    expect(find.text('a'), findsNothing);
    expect(find.text('b'), findsOneWidget);
    expect(log.where((e) => e.startsWith('init')), <String>['init b']);
  });
}
