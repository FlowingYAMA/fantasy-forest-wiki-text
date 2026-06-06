import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 仅根据 JSON 几何数据绘制法阵线（不使用游戏 PNG）。
class MagicCircleDiagram extends StatelessWidget {
  const MagicCircleDiagram({
    super.key,
    required this.diagram,
    this.graphIndex,
    this.height = 220,
    this.elementKey,
    this.compact = false,
    this.radiusScale = 0.42,
  });

  final Map<String, dynamic>? diagram;
  final int? graphIndex;
  final double height;
  final String? elementKey;
  final bool compact;
  final double radiusScale;

  static Color neonLineColor(String? key) {
    switch (key) {
      case 'water':
        return const Color(0xFF00E5FF);
      case 'fire':
        return const Color(0xFFFF5252);
      case 'wind':
        return const Color(0xFF69F0AE);
      case 'soil':
        return const Color(0xFFFFD740);
      default:
        return const Color(0xFF00E5FF);
    }
  }

  static Color pointBorderForElement(String? key) {
    switch (key) {
      case 'water':
        return const Color(0xFF01579B);
      case 'fire':
        return const Color(0xFFBF360C);
      case 'wind':
        return const Color(0xFF1B5E20);
      case 'soil':
        return const Color(0xFF9A7B12);
      default:
        return const Color(0xFF01579B);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (diagram == null) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('暂无法阵结构数据')),
      );
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _MagicCirclePainter(
          diagram: diagram!,
          graphIndex: graphIndex,
          elementKey: elementKey,
          compact: compact,
          radiusScale: radiusScale,
        ),
      ),
    );
  }
}

class _MagicCirclePainter extends CustomPainter {
  _MagicCirclePainter({
    required this.diagram,
    this.graphIndex,
    this.elementKey,
    this.compact = false,
    this.radiusScale = 0.42,
  });

  final Map<String, dynamic> diagram;
  final int? graphIndex;
  final String? elementKey;
  final bool compact;
  final double radiusScale;

  @override
  void paint(Canvas canvas, Size size) {
    final pointsRaw = diagram['points'] as List? ?? [];
    if (pointsRaw.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * radiusScale;
    final pointRadius = compact ? 2.0 : 5.5;
    final coreW = compact ? 1.1 : 3.2;
    final neon = MagicCircleDiagram.neonLineColor(elementKey);

    final points = <Offset>[];
    for (final p in pointsRaw) {
      final list = p as List;
      final x = (list[0] as num).toDouble();
      final y = (list[1] as num).toDouble();
      points.add(center + Offset(x * radius, -y * radius));
    }

    final graphs = diagram['graphs'] as List? ?? [];
    if (graphIndex != null) {
      if (graphIndex! >= 0 && graphIndex! < graphs.length) {
        _drawGraph(canvas, graphs[graphIndex!], points, neon, coreW, compact);
      }
    } else {
      for (final g in graphs) {
        _drawGraph(canvas, g, points, neon, coreW, compact);
      }
    }

    final pointPaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = MagicCircleDiagram.pointBorderForElement(elementKey)
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.55 : 1.5;
    for (final pt in points) {
      canvas.drawCircle(pt, pointRadius, pointPaint);
      canvas.drawCircle(pt, pointRadius, borderPaint);
    }
  }

  void _drawGraph(
    Canvas canvas,
    dynamic graph,
    List<Offset> points,
    Color neon,
    double coreW,
    bool compact,
  ) {
    final lines = (graph as Map)['lines'] as List? ?? [];
    for (final line in lines) {
      final pair = line as List;
      final a = (pair[0] as num).toInt();
      final b = (pair[1] as num).toInt();
      if (a < 0 || b < 0 || a >= points.length || b >= points.length) continue;
      _drawNeonLine(canvas, points[a], points[b], neon, coreW, compact);
    }
  }

  void _drawNeonLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Color neon,
    double coreW,
    bool compact,
  ) {
    final haloExtra = compact ? 2.6 : 5.5;
    final gradExtra = compact ? 0.65 : 1.8;
    final rect = Rect.fromPoints(a, b).inflate(coreW + (compact ? 4 : 6));

    final halo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = coreW + haloExtra
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: compact ? 0.7 : 0.78);
    canvas.drawLine(a, b, halo);

    final gradient = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = coreW + gradExtra
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.white,
          neon,
          neon,
          Colors.white,
        ],
        stops: const [0.0, 0.2, 0.8, 1.0],
      ).createShader(rect);
    canvas.drawLine(a, b, gradient);

    final core = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, coreW * 0.5)
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(neon, Colors.white, 0.35)!;
    canvas.drawLine(a, b, core);
  }

  @override
  bool shouldRepaint(covariant _MagicCirclePainter oldDelegate) {
    return oldDelegate.diagram != diagram ||
        oldDelegate.graphIndex != graphIndex ||
        oldDelegate.elementKey != elementKey ||
        oldDelegate.compact != compact ||
        oldDelegate.radiusScale != radiusScale;
  }
}
