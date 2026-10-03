import 'package:flutter/material.dart';

import 'deck_device_sync.dart';
import 'feature_deck.dart';
import 'mobile_tokens.dart';
import 'section_header.dart';

/// "What it does", trailed by the frame's device, over the feature deck.
class MobileDeckSection extends StatelessWidget {
  const MobileDeckSection({super.key, required this.sync});

  final DeckDeviceSync sync;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: MobileTokens.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListenableBuilder(
              listenable: sync,
              builder: (BuildContext context, Widget? _) => SectionHeader(
                leading: 'What it does',
                trailing: '${sync.frame.name} preview',
                trailingColor: MobileTokens.accent300,
              ),
            ),
            const SizedBox(height: 12),
            FeatureDeck(controller: sync.deck),
          ],
        ),
      ),
    );
  }
}
