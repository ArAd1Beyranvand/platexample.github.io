import 'package:flutter/material.dart';

enum CalloutKind { heroIr, heroDe, steel, dark }

enum CalloutSide { left, right }

class CalloutSpec {
  const CalloutSpec({
    required this.index,
    required this.kind,
    required this.side,
    required this.textDirection,
    required this.anchorFx,
    required this.anchorFy,
    required this.widthFx,
    required this.eyebrow,
    required this.title,
    this.body,
    required this.titleSizeDesignPx,
    required this.bodySizeDesignPx,
    this.hasIrFlag = false,
    this.hasFadedFlag = false,
    this.hasEuBadge = false,
    this.hasFlareTag = false,
    this.hasDivider = false,
    this.hasFooter = false,
    this.hasDeBranding = false,
    this.hasDashedRule = true,
    this.hasLRule = false,
    this.isCentered = false,
  });

  final int index;
  final CalloutKind kind;
  final CalloutSide side;
  final TextDirection textDirection;
  final double anchorFx;
  final double anchorFy;
  final double widthFx;
  final String eyebrow;
  final String title;
  final String? body;
  final double titleSizeDesignPx;
  final double bodySizeDesignPx;
  final bool hasIrFlag;
  final bool hasFadedFlag;
  final bool hasEuBadge;
  final bool hasFlareTag;
  final bool hasDivider;
  final bool hasFooter;
  final bool hasDeBranding;
  final bool hasDashedRule;

  /// Wraps the title in an L-shaped dashed rule — down its right edge and
  /// along its bottom — with the body set to the right of the vertical leg.
  final bool hasLRule;
  final bool isCentered;
}

const Map<DeviceType, List<CalloutSpec>> calloutSets = {
  DeviceType.desktop: [
    CalloutSpec(
      index: 1,
      kind: CalloutKind.heroIr,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.402,
      anchorFy: 0.122,
      widthFx: 0.279,
      eyebrow: 'COUNTRIES',
      title: '3 countries\none widget',
      body: 'Iranian, Palestinian and Yemeni plates all ship — same widget, one const swapped.',
      titleSizeDesignPx: 62,
      bodySizeDesignPx: 24,
      hasIrFlag: true,
    ),
    CalloutSpec(
      index: 3,
      kind: CalloutKind.steel,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.862,
      anchorFy: 0.122,
      widthFx: 0.182,
      eyebrow: 'VARIANTS',
      title: 'Cars and motorbikes',
      body: null,
      titleSizeDesignPx: 36,
      bodySizeDesignPx: 20,
      hasDashedRule: false,
    ),
    CalloutSpec(
      index: 4,
      kind: CalloutKind.dark,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.560,
      anchorFy: 0.760,
      widthFx: 0.197,
      eyebrow: 'OPEN SOURCE',
      title: 'Iran Made\nOpen Source',
      body: null,
      titleSizeDesignPx: 34,
      bodySizeDesignPx: 0,
      hasDashedRule: false,
      isCentered: true,
    ),
  ],
  DeviceType.mobile: [
    CalloutSpec(
      index: 5,
      kind: CalloutKind.heroIr,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.505,
      anchorFy: 0.420,
      widthFx: 0.201,
      eyebrow: 'SETTINGS',
      title: 'Every part of the plate\nis customizable',
      body: 'Color, size, flag, and keyboard behavior are all in your hands.',
      titleSizeDesignPx: 50,
      bodySizeDesignPx: 23,
      hasDivider: true,
      hasFooter: true,
    ),
    CalloutSpec(
      index: 6,
      kind: CalloutKind.steel,
      side: CalloutSide.right,
      textDirection: TextDirection.ltr,
      anchorFx: 0.863,
      anchorFy: 0.320,
      widthFx: 0.127,
      eyebrow: 'VALIDATION',
      title: 'Checks as\nyou type',
      body: 'Plate rules are verified field by field.',
      titleSizeDesignPx: 34,
      bodySizeDesignPx: 19,
    ),
    CalloutSpec(
      index: 7,
      kind: CalloutKind.dark,
      side: CalloutSide.right,
      textDirection: TextDirection.ltr,
      anchorFx: 0.521,
      anchorFy: 0.150,
      widthFx: 0.159,
      eyebrow: 'SPECIAL CASES',
      title: 'Special Cases Handled',
      body: 'Those commonly overlooked.',
      titleSizeDesignPx: 34,
      bodySizeDesignPx: 19,
    ),
  ],
  DeviceType.tablet: [
    CalloutSpec(
      index: 9,
      kind: CalloutKind.heroDe,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.26,
      anchorFy: 0.18,
      widthFx: 0.37,
      eyebrow: 'RULES',
      title: 'Live\nvalidation',
      body: 'Forbidden district and serial combinations flare red as you type: before submit, not after.',
      titleSizeDesignPx: 64,
      bodySizeDesignPx: 30,
      hasEuBadge: true,
      hasFlareTag: true,
    ),
    CalloutSpec(
      index: 11,
      kind: CalloutKind.dark,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.660,
      anchorFy: 0.070,
      widthFx: 0.191,
      eyebrow: 'FEATURE',
      title: 'Both plate input\nand its display',
      body: null,
      titleSizeDesignPx: 34,
      bodySizeDesignPx: 0,
      hasDashedRule: false,
      isCentered: true,
    ),
    CalloutSpec(
      index: 12,
      kind: CalloutKind.dark,
      side: CalloutSide.left,
      textDirection: TextDirection.ltr,
      anchorFx: 0.560,
      anchorFy: 0.830,
      widthFx: 0.191,
      eyebrow: 'SCALE',
      title: 'Everything is customizable',
      body: null,
      titleSizeDesignPx: 34,
      bodySizeDesignPx: 0,
      hasDashedRule: false,
      isCentered: true,
    ),
  ],
};

enum DeviceType { desktop, mobile, tablet }
