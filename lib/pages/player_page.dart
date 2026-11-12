// ============================================================
// pages/player_page.dart — 播放详情页
//
// HTML 原型对照：melostructure.html 里 #page-detail
// 包含：动画 2（Hero 封面目标）、动画 3（唱片旋转）、动画 4（频谱错峰）、
//       动画 5+6（播放按钮）、3 处补充交互（收藏爱心弹性弹跳 / 进度 seek / 歌词自动滚动）
// ============================================================

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../state/player_controller.dart';
import '../widgets/spinning_disc.dart';
import '../widgets/spectrum_bars.dart';
import '../widgets/play_button.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final ScrollController _lyricScrollController;

  @override
  void initState() {
    super.initState();
    _lyricScrollController = ScrollController();
  }

  @override
  void dispose() {
    _lyricScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = PlayerScope.of(context);
    final song = state.currentSong;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      // ===== AppBar：返回按钮 + 歌曲标题 =====
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFEF7FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B20)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          song.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1D1B20)),
        ),
      ),
      body: ListView(
        children: [
          // ===== 动画 2：Hero 封面目标（tag 必须与 SongCard 里一致）=====
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 唱片在底层（比封面小 40px，所以从 SongCard 48px → 封面 220px，唱片 180px 叠在封面之上）
                  SpinningDisc(playing: state.isPlaying),
                  // Hero 封面在顶层
                  Hero(
                    tag: 'cover-${song.id}',
                    // 注意：封面只在初始进入时参与 Hero 过渡，之后用 fadeIn 过渡
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(song.coverGradient[0]),
                              Color(song.coverGradient[1]),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.music_note, color: Colors.white, size: 64),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== 动画 4：频谱条错峰起伏 =====
          SpectrumBars(playing: state.isPlaying),
          const SizedBox(height: 8),

          // ===== 进度条（可点击 seek）=====
          _buildProgress(context),
          const SizedBox(height: 8),

          // ===== 播放控制行：上一首 / 播放暂停 / 下一首 / 收藏爱心 =====
          _buildControls(context),
          const SizedBox(height: 12),

          // ===== 歌词区（自动滚动 + 当前行高亮 + 点击 seek）=====
          _buildLyrics(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ============================================================
  // 进度条
  // ============================================================
  Widget _buildProgress(BuildContext context) {
    final state = PlayerScope.of(context);
    final song = state.currentSong;
    final total = song.duration.inSeconds.toDouble();
    final pct = total > 0 ? state.progressSeconds / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // ===== Slider：Flutter 内置组件 =====
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF4285F4),
              inactiveTrackColor: const Color(0xFFE6E0E9),
              thumbColor: const Color(0xFF4285F4),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            ),
            child: Slider(
              value: pct.clamp(0.0, 1.0),
              onChanged: (v) {
                state.seekTo(v * total);
              },
            ),
          ),
          // 时间：当前 / 总时长
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fmtDuration(Duration(seconds: state.progressSeconds.round())),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF79747E)),
                ),
                Text(
                  fmtDuration(song.duration),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF79747E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 播放控制行
  // ============================================================
  Widget _buildControls(BuildContext context) {
    final state = PlayerScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 上一首
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 36, color: Color(0xFF49454F)),
            onPressed: () => state.playPrev(),
          ),
          // ===== 动画 5 + 6：PlayButton =====
          PlayButton(
            isPlaying: state.isPlaying,
            onTap: () => state.togglePlay(),
          ),
          // 下一首
          IconButton(
            icon: const Icon(Icons.skip_next, size: 36, color: Color(0xFF49454F)),
            onPressed: () => state.playNext(),
          ),
          // ===== 动画 7（加分项）：收藏爱心弹性弹跳 =====
          _FavButton(
            isFavorite: state.isFavorite(state.currentSongIndex),
            onTap: () => state.toggleFavorite(state.currentSongIndex),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 收藏爱心按钮（弹性弹跳 AnimatedSwitcher）
  // ============================================================
  Widget _FavButton({required bool isFavorite, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44, height: 44,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          // ===== ScaleTransition + elasticOut 曲线 =====
          transitionBuilder: (child, anim) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: anim,
                curve: Curves.elasticOut,  // 课程第九章曲线 API
              ),
              child: child,
            );
          },
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey<bool>(isFavorite),
            size: 24,
            color: isFavorite
                ? const Color(0xFFBA1A1A)    // m3-error 语义色
                : const Color(0xFF49454F),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 歌词区：自动滚动 + 当前行高亮 + 点击 seek
  //
  // 对应 Flutter API：
  //   ScrollController.animateTo(offset, duration: 200ms, curve: Curves.easeInOut)
  //   ListView.builder 当前项用不同 TextStyle
  // ============================================================
  Widget _buildLyrics(BuildContext context) {
    final state = PlayerScope.of(context);
    final song = state.currentSong;
    final activeIdx = state.currentLyricIndex();

    // ===== 自动滚动让当前行居中 =====
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (activeIdx < 0) return;
      const lineHeight = 28.0;  // line-height 2.0 * 14px
      final targetOffset = activeIdx * lineHeight - 70;  // 容器高度 140 / 2
      if (targetOffset >= 0) {
        _lyricScrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });

    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // 歌词渐隐 fade（上半透明遮罩）
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00FEF7FF),  // 透明
            Color(0xFFFEF7FF),  // 不透明
            Color(0x00FEF7FF),  // 透明
          ],
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      child: ListView.builder(
        controller: _lyricScrollController,
        itemCount: song.lyrics.length,
        itemBuilder: (context, i) {
          final isActive = i == activeIdx;
          return GestureDetector(
            onTap: () => state.seekTo(song.lyrics[i].time),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1.0 : 0.7,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isActive ? 16 : 14,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                    color: isActive
                        ? const Color(0xFF4285F4)    // m3-primary（高亮）
                        : const Color(0xFF49454F),   // m3-on-surface-variant
                    height: 1.8,
                  ),
                  child: Text(song.lyrics[i].text),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
