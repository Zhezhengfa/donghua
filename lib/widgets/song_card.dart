// ============================================================
// widgets/song_card.dart — 列表卡片（Hero 来源 Widget）
//
// HTML 原型对照：.song-card
// Flutter：Hero(tag: 'cover-N') + ClipRRect + Material 3 Card 风格
// 每个独立卡片有 Hero tag，点击后 Navigator.push 触发 Hero 飞行
// ============================================================

import 'package:flutter/material.dart';
import '../models/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final bool isPlayingHere;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavTap;

  const SongCard({
    super.key,
    required this.song,
    required this.isPlayingHere,
    required this.isFavorite,
    required this.onTap,
    this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // M3 Card 风格：surfaceContainerLow 背景 + 12px 圆角 + 8px margin
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isPlayingHere
              ? const Color(0xFFECE6F0)    // surfaceContainerHigh（播放中高亮）
              : const Color(0xFFF7F2FA),   // surfaceContainerLow（默认）
          borderRadius: BorderRadius.circular(12),
          border: isPlayingHere
              ? Border.all(color: const Color(0xFF4285F4), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // ===== Hero tag 必须与详情页一致 =====
            // 动画 2：Hero 封面飞行，tag = 'cover-${song.id}'
            Hero(
              tag: 'cover-${song.id}',
              // ClipRRect 让封面圆角，Hero 过渡时圆角也参与动画
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(song.coverGradient[0]),
                        Color(song.coverGradient[1]),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B20),
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${song.artist} · ${song.album}',
                    style: const TextStyle(
                      fontSize: 12, color: Color(0xFF49454F),
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              fmtDuration(song.duration),
              style: const TextStyle(fontSize: 12, color: Color(0xFF79747E)),
            ),
            const SizedBox(width: 4),
            // 右侧小收藏图标
            if (onFavTap != null)
              GestureDetector(
                onTap: onFavTap,
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isFavorite
                      ? const Color(0xFFBA1A1A)
                      : const Color(0xFF49454F),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
