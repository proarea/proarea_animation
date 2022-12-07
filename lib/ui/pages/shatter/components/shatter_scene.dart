import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class ShatterScene extends StatefulWidget {
  final Widget Function(BuildContext context, void Function() startScatter)
      builder;

  const ShatterScene({
    super.key,
    required this.builder,
  });

  @override
  State<ShatterScene> createState() => _ShatterSceneState();
}

class _ShatterSceneState extends State<ShatterScene> {
  final _key = GlobalKey();
  MemoryImage? _memoryImage;
  late List<List<Offset>> _parts;
  bool _showAnimation = false;
  bool _useFallback = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordImage());
  }

  void _recordImage() async {
    try {
      var boundary =
          _key.currentContext?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var imageBytes = byteData?.buffer.asUint8List();
      if (imageBytes == null) return;

      setState(() {
        _parts = PolygonStripGenerator().generate();
        _memoryImage = MemoryImage(imageBytes);
      });
    } catch (e) {
      setState(() {
        _parts = PolygonStripGenerator().generate(complexity: 1);
        _useFallback = true;
      });
    }
  }

  void _startShatter() {
    setState(() {
      _showAnimation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showAnimation) {
      return Stack(
        children: [
          if (_memoryImage != null)
            Positioned.fill(
              child: Opacity(opacity: 0.0, child: Image(image: _memoryImage!)),
            ),
          Positioned.fill(
            child: RepaintBoundary(
              key: _key,
              child: widget.builder(context, _startShatter),
            ),
          ),
        ],
      );
    }

    return PlayAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: 1200.milliseconds,
      curve: Curves.easeInSine,
      builder: (context, value, child) {
        return Stack(
          children: _parts
              .map(
                (part) => Positioned.fill(
                  child: AnimatedShatter(
                    points: part,
                    progress: value,
                    child: !_useFallback
                        ? Image(image: _memoryImage!)
                        : widget.builder(context, () {}),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class AnimatedShatter extends StatelessWidget {
  final double progress;
  final List<Offset> points;
  final Widget child;

  const AnimatedShatter({
    super.key,
    this.progress = 0,
    this.points = const [],
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var center = Offset(
      (points[0].dx + points[1].dx + points[2].dx) / 3.0,
      (points[0].dy + points[1].dy + points[2].dy) / 3.0,
    );

    return LayoutBuilder(builder: (context, constraints) {
      var alignment = Alignment(-1 + center.dx * 2, -1 + center.dy * 2);
      return Transform.translate(
        offset: Offset(0, progress * constraints.maxHeight * 1.2),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)
            ..rotateZ((alignment.x < 0 ? -1 : 1) * 0.4 * progress)
            ..rotateX((alignment.x < 0 ? -1 : 1) * 0.3 * progress)
            ..rotateY((alignment.x < 0 ? -1 : 1) * 0.2 * progress),
          alignment: alignment,
          child: Transform.scale(
            scale: 1 - 0.7 * progress,
            alignment: alignment,
            child: ClipPath(
              clipper: PolygonClipper(points: points),
              child: child,
            ),
          ),
        ),
      );
    });
  }
}

class PolygonClipper extends CustomClipper<Path> {
  final List<Offset> points;

  const PolygonClipper({this.points = const []});

  @override
  Path getClip(Size size) {
    return Path()
      ..addPolygon(
        points
            .map((relativeOffset) => Offset(
                  relativeOffset.dx * size.width,
                  relativeOffset.dy * size.height,
                ))
            .toList(),
        true,
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class PolygonStripGenerator {
  List<List<Offset>> generate({int seed = 2, int complexity = 2}) {
    var random = Random(2);

    var triangles = [
      Triangle(const Offset(0, 0), const Offset(0, 1), const Offset(1, 0)),
      Triangle(const Offset(1, 1), const Offset(0, 1), const Offset(1, 0)),
    ];

    0.until(complexity).forEach((_) {
      triangles = triangles.expand((t) => t.shatter(random)).toList();
    });

    return triangles.map((t) => [t.p1, t.p2, t.p3]).toList();
  }
}

class Triangle {
  final Offset p1;
  final Offset p2;
  final Offset p3;

  Triangle(this.p1, this.p2, this.p3);

  List<Triangle> shatter(Random random) {
    var m12 = _average2(p1, p2, 0.4 + 0.2 * random.nextDouble());
    var m23 = _average2(p2, p3, 0.4 + 0.2 * random.nextDouble());
    var m13 = _average2(p1, p3, 0.4 + 0.2 * random.nextDouble());
    var center = _average3(
      p1,
      p2,
      p3,
      0.3 * random.nextDouble(),
      0.3 * random.nextDouble(),
      0.3 * random.nextDouble(),
    );

    return [
      Triangle(p1, m12, center),
      Triangle(m12, p2, center),
      Triangle(p2, m23, center),
      Triangle(m23, p3, center),
      Triangle(p3, m13, center),
      Triangle(m13, p1, center),
    ];
  }

  Offset _average2(Offset p1, Offset p2, double weight) {
    var vec = Offset(
      p2.dx - p1.dx,
      p2.dy - p1.dy,
    );

    return Offset(
      p1.dx + vec.dx * weight,
      p1.dy + vec.dy * weight,
    );
  }

  Offset _average3(
      Offset p1, Offset p2, Offset p3, double w1, double w2, double w3) {
    var center = Offset(
      (p1.dx + p2.dx + p3.dx) / 3.0,
      (p1.dy + p2.dy + p3.dy) / 3.0,
    );

    var vec1 = Offset(p1.dx - center.dx, p1.dy - center.dy);
    var vec2 = Offset(p2.dx - center.dx, p2.dy - center.dy);
    var vec3 = Offset(p3.dx - center.dx, p3.dy - center.dy);

    return Offset(
      center.dx + vec1.dx * w1 + vec2.dx * w2 + vec3.dx * w3,
      center.dy + vec1.dy * w1 + vec2.dy * w2 + vec3.dy * w3,
    );
  }
}