// ============================================================
// widgets/spinning_disc.dart — 旋转黑胶唱片
//
// HTML 原型对照：melostructure.html .disc CSS @keyframes spinDisc 8s linear infinite
// Flutter 动画 3：AnimationController.repeat(duration: 8s) + RotationTransition
// 暂停时 _controller.stop() → 停在当前角度，不是重置
//
// 对应 Flutter API：
//   AnimationController(duration: Duration(seconds: 8))..repeat()
//   RotationTransition(turns: _controller, child: ...)
// ============================================================

import 'package:flutter/material.dart';

class SpinningDisc extends StatefulWidget {
  final bool playing;
  const SpinningDisc({super.key, required this.playing});

  @override
  State<SpinningDisc> createState() => _SpinningDiscState();
}

class _SpinningDiscState extends State<SpinningDisc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 8 秒一周（与 HTML 原型一致）
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    if (widget.playing) _controller.repeat();
  }

  @override
  void didUpdateWidget(SpinningDisc oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ===== 课程核心点：pause 时用 stop()，恢复时用 repeat() =====
    // stop() 停在当前角度 → 不重置
    // repeat() 从当前角度继续 → 不是 forward() 从头开始
    if (widget.playing && !oldWidget.playing) {
      _controller.repeat();  // 恢复旋转
    } else if (!widget.playing && oldWidget.playing) {
      _controller.stop();    // 冻结当前角度
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ===== RotationTransition 显式动画 =====
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // ===== 黑胶质感：多层 radial gradient =====
          gradient: const RadialGradient(
            colors: [
              Color(0xFF212121),  // 最内圈
              Color(0xFF424242),
              Color(0xFF1E1E1E),
              Color(0xFF3D3D3D),
              Color(0xFF151515),
              Color(0xFF4A4A4A),
              Color(0xFF0D0D0D),
              Color(0xFF2C2C2C),
            ],
            stops: [0.0, 0.08, 0.18, 0.32, 0.48, 0.64, 0.80, 0.95],
          ),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            // M3 elevation 4 shadow（与 HTML 原型 --e-4 一致）
            BoxShadow(
              color: Color(0x4D000000),
              blurRadius: 10,
              offset: Offset(0, 6),
              spreadRadius: 4,
            ),
          ],
        ),
        // 唱片中心主色小圆点
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4),  // m3-primary
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 3),
            ),
          ),
        ),
      ),
    );
  }
}
