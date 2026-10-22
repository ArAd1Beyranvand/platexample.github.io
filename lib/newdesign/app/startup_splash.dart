import 'package:flutter/material.dart';

/// Flutter port of the web loading screen (`web/index.html` #splash), shown
/// over [child] on mobile for one fill cycle and then faded out. Web has its
/// own HTML copy that runs while the engine loads, so this is not used there.
class PdStartupSplash extends StatefulWidget {
  const PdStartupSplash({super.key, required this.child});

  final Widget child;

  @override
  State<PdStartupSplash> createState() => _PdStartupSplashState();
}

/// Length of one loop of the web animation; every keyframe below is a
/// fraction of it.
const Duration _cycle = Duration(milliseconds: 3200);

/// The splash leaves once the progress bar is full (85% of the cycle).
const double _end = 0.85;

class _PdStartupSplashState extends State<PdStartupSplash> with TickerProviderStateMixin {
  late final AnimationController _play = AnimationController(vsync: this, duration: _cycle);
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  bool _gone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_play.isAnimating || _play.value > 0) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _play.value = 0.5;
      Future<void>.delayed(const Duration(milliseconds: 800), _leave);
    } else {
      _play.animateTo(_end).then((_) => _leave());
    }
  }

  void _leave() {
    if (!mounted) return;
    _fade.forward().then((_) {
      if (mounted) setState(() => _gone = true);
    });
  }

  @override
  void dispose() {
    _play.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gone) return widget.child;
    return Stack(
      children: <Widget>[
        widget.child,
        Positioned.fill(
          child: FadeTransition(
            opacity: ReverseAnimation(_fade),
            child: AnimatedBuilder(
              animation: _play,
              builder: (BuildContext context, _) => _SplashView(t: _play.value),
            ),
          ),
        ),
      ],
    );
  }
}

const Color _bg = Color(0xFF050607);
const Color _ink = Color(0xFF0B0D10);
const Color _teal = Color(0xFF2DD4C4);
const Color _light = Color(0xFFE8EAEE);

class _SplashView extends StatelessWidget {
  const _SplashView({required this.t});

  /// Position in the cycle, 0..1.
  final double t;

  @override
  Widget build(BuildContext context) {
    final double seconds = t * _cycle.inMilliseconds / 1000;
    final bool caretOn = seconds % 1 < 0.5;
    return ColoredBox(
      color: _bg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints c) {
                final double w = c.maxWidth * 0.86 < 560 ? c.maxWidth * 0.86 : 560;
                return _Plate(width: w, t: t);
              },
            ),
            const SizedBox(height: 28),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                width: 160,
                height: 2,
                color: const Color(0xFF14181C),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (t / _end).clamp(0.0, 1.0),
                  child: const ColoredBox(color: _teal),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 26,
                  height: 12,
                  decoration: BoxDecoration(
                    border: Border.all(color: _light, width: 2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const FractionallySizedBox(
                    widthFactor: 0.3,
                    heightFactor: 1,
                    child: ColoredBox(color: _teal),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'platexample',
                  style: TextStyle(
                    color: _light,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 10),
                Opacity(
                  opacity: caretOn ? 1 : 0,
                  child: const SizedBox(width: 2, height: 15, child: ColoredBox(color: _teal)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Plate extends StatelessWidget {
  const _Plate({required this.width, required this.t});

  final double width;
  final double t;

  @override
  Widget build(BuildContext context) {
    // Sizes are taken from the 560px-wide web plate and scaled with it.
    final double k = width / 560;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: width,
        height: width / 4.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0xFF1C2126), spreadRadius: 5),
            BoxShadow(color: Color(0xFF0D1013), spreadRadius: 4),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: width * 0.13,
              color: const Color(0xFF1F3FA8),
              padding: EdgeInsets.symmetric(vertical: width * 0.06, horizontal: width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: width / 4.6 * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xFF239F40),
                          Color(0xFF239F40),
                          Colors.white,
                          Colors.white,
                          Color(0xFFDA0000),
                          Color(0xFFDA0000),
                        ],
                        stops: <double>[0, 0.33, 0.33, 0.66, 0.66, 1],
                      ),
                    ),
                  ),
                  Text(
                    'I.R.\nIRAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15 * k,
                      height: 1,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: _ink, width: 3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _Slot('?', '۱۲', 2.2, 56 * k, t, 0),
                    _Slot('؟', 'ب', 1.1, 56 * k, t, 0.25),
                    _Slot('?', '۳۴۵', 3, 56 * k, t, 0.5),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ایران',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: _ink,
                      fontSize: 22 * k,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  _Slot('?', '۶۷', 1.8, 42 * k, t, 0.75),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One plate group: a grey "?" that gives way to the real characters.
class _Slot extends StatelessWidget {
  const _Slot(this.q, this.value, this.underlineEm, this.size, this.t, this.delaySeconds);

  final String q;
  final String value;
  final double underlineEm;
  final double size;
  final double t;
  final double delaySeconds;

  @override
  Widget build(BuildContext context) {
    final double delay = delaySeconds * 1000 / _cycle.inMilliseconds;
    // Before its delay a group sits at the start of its own cycle.
    final double p = t < delay ? 0 : (t - delay) % 1;
    final double fill;
    if (p < 0.12) {
      fill = 0;
    } else if (p < 0.20) {
      fill = (p - 0.12) / 0.08;
    } else if (p < 0.85) {
      fill = 1;
    } else {
      fill = 1 - (p - 0.85) / 0.15;
    }
    final double q0 = p < 0.12
        ? 1
        : p < 0.20
        ? 1 - (p - 0.12) / 0.08
        : p < 0.85
        ? 0
        : (p - 0.85) / 0.15;
    final double rise = p < 0.12
        ? 6
        : p < 0.20
        ? 6 * (1 - fill)
        : 0;
    final TextStyle style = TextStyle(
      fontFamily: 'Vazirmatn',
      fontWeight: FontWeight.w500,
      fontSize: size,
      height: 1.1,
      decoration: TextDecoration.none,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Opacity(
              opacity: q0,
              child: Text(q, style: style.copyWith(color: const Color(0xFFC9CCD3))),
            ),
            Transform.translate(
              offset: Offset(0, rise),
              child: Opacity(
                opacity: fill,
                child: Text(value, style: style.copyWith(color: _ink)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(width: underlineEm * size, height: 2, color: const Color(0xFFD9DCE2)),
      ],
    );
  }
}
