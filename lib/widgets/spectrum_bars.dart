// ============================================================
// widgets/spectrum_bars.dart — 错峰起伏频谱条（8 条）
//
// HTML 原型对照：CSS @keyframes spectScale + 每条独立 animation-duration/delay
// Flutter 动画 4：TweenSequence + Interval + AnimatedBuilder（交织动画）
//
// 对应 Flutter API：
//   AnimationController.period = 1500~2200ms，每条不同
//   AnimatedBuilder + Transform.scale(alignment: Alignment.bottomCenter)
//   Interval(begin, end) 控制每条错峰
// ============================================================

import 'package:flutter/material.dart';

class SpectrumBars extends StatefulWidget {
  final bool playing;
  const SpectrumBars({super.key, required this.playing});

  @override
  State<SpectrumBars> createState() => _SpectrumBarsState();
}

class _SpectrumBarsState extends State<SpectrumBars>
    with TickerProviderStateMixin {
  // 8 条独立 controller（每条 duration 1.3~2.0s 循环，错峰）
  late final List<AnimationController> _controllers;
  late final List<double> _durations;  // 每条时长（毫秒）
  late final List<double> _delays;      // 每条延迟（0~0.49，对应 Interval begin）

  @override
  void initState() {
    super.initState();
    _durations = [1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];  // 错峰时长
    _delays =    [0.0, 0.07, 0.14, 0.21, 0.28, 0.35, 0.42, 0.49];  // 错峰起点
    _controllers = List.generate(8, (i) => AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_durations[i] * 1000).toInt()),
    ));
    if (widget.playing) _startAll();
  }

  void _startAll() {
    for (var c in _controllers) {
      c.repeat(reverse: true);  // 交替 scaleY 0.15 → 1.0
    }
  }

  void _stopAll() {
    for (var c in _controllers) c.stop(canceled: false);
  }

  @override
  void didUpdateWidget(SpectrumBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playing && !oldWidget.playing) _startAll();
    if (!widget.playing && oldWidget.playing) _stopAll();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }

  // ===== 交织动画：TweenSequence（scaleY 0.15→1.0→0.15）+ Interval =====
  Animation<double> _barAnim(int i) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.15, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.15), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controllers[i],
      curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    const heights = [12.0, 24.0, 8.0, 32.0, 18.0, 26.0, 10.0, 30.0];
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(8, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            // ===== AnimatedBuilder：交织动画常用写法 =====
            child: AnimatedBuilder(
              animation: _barAnim(i),
              builder: (context, child) {
                return Transform.scale(
                  scaleY: _barAnim(i).value,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 4,
                    height: heights[i],
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4),  // m3-primary
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
