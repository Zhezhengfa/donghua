// ============================================================
// state/player_controller.dart — 播放状态控制器
//
// 设计约束（严格对齐课程边界）：
//   - 纯 StatefulWidget + setState，不引入 Provider/Bloc/GetX
//   - 只用第九章已学 AnimationController / Tween / CurvedAnimation
//   - 收藏用 Set<int>，进度用 double，播放/暂停用 bool
//   - TickerProviderStateMixin 提供 vsync 做进度 tick
//   - 子 Widget 通过 PlayerScope.of(context) 拿 state，或直接 context.readState()
// ============================================================

import 'package:flutter/material.dart';
import '../models/song.dart';

/// 根节点 Widget：包裹整个 App，提供播放状态
class PlayerScope extends StatefulWidget {
  final Widget child;
  const PlayerScope({super.key, required this.child});

  static _PlayerScopeState of(BuildContext context) =>
      context.findAncestorStateOfType<_PlayerScopeState>()!;

  @override
  State<PlayerScope> createState() => _PlayerScopeState();
}

class _PlayerScopeState extends State<PlayerScope> with TickerProviderStateMixin {
  // -------- 播放相关 --------
  late final AnimationController _tickController;
  int currentSongIndex = 0;
  bool isPlaying = false;
  double progressSeconds = 0;

  // -------- 收藏 --------
  final Set<int> favorites = {};

  // -------- 播放状态 Widget 用 --------
  int get favoriteCount => favorites.length;
  bool isFavorite(int id) => favorites.contains(id);
  Song get currentSong => songs[currentSongIndex];
  int currentLyricIndex() {
    final lyrics = currentSong.lyrics;
    int idx = -1;
    for (int i = 0; i < lyrics.length; i++) {
      if (progressSeconds >= lyrics[i].time) idx = i;
      else break;
    }
    return idx;
  }

  @override
  void initState() {
    super.initState();
    // 每 16ms 重置一次（约 60fps），保证进度增量稳定
    _tickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    );
    _tickController.addListener(_onTick);
  }

  @override
  void dispose() {
    _tickController.removeListener(_onTick);
    _tickController.dispose();
    super.dispose();
  }

  void _onTick() {
    if (!isPlaying) return;
    // 约 60fps，每帧加 1/60 秒 ≈ 0.0167
    progressSeconds += 16.0 / 1000.0;
    final total = currentSong.duration.inSeconds;
    if (progressSeconds >= total) {
      progressSeconds = total.toDouble();
      playNext();
      return;  // playNext 内部 setState
    }
    setState(() {});  // 进度更新 → 重绘
    _tickController.forward(from: 0);  // 下一个 16ms
  }

  // ============================================================
  // 对外业务方法
  // ============================================================

  void togglePlay() {
    if (isPlaying) stopPlayback(); else startPlayback();
  }

  void startPlayback() {
    if (isPlaying) return;
    isPlaying = true;
    _tickController.forward(from: 0);
    setState(() {});
  }

  void stopPlayback() {
    isPlaying = false;
    _tickController.stop();
    setState(() {});
  }

  void seekTo(double seconds) {
    final total = currentSong.duration.inSeconds.toDouble();
    progressSeconds = seconds.clamp(0.0, total);
    setState(() {});
  }

  void playPrev() {
    currentSongIndex = (currentSongIndex + 7) % songs.length;
    progressSeconds = 0;
    setState(() {});
  }

  void playNext() {
    currentSongIndex = (currentSongIndex + 1) % songs.length;
    progressSeconds = 0;
    setState(() {});
  }

  void openSong(int index) {
    currentSongIndex = index;
    progressSeconds = 0;
    setState(() {});
  }

  void toggleFavorite(int id) {
    if (favorites.contains(id)) favorites.remove(id);
    else favorites.add(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;  // 只是一个状态提供者，UI 不变
  }
}

/// context 扩展语法糖：拿到 _PlayerScopeState
extension PlayerScopeExt on BuildContext {
  _PlayerScopeState get state => PlayerScope.of(this);
}
