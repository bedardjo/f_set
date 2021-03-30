import 'package:flutter/material.dart';

enum ShapeType { diamond, squiggly, pill }
enum TextureType { outline, banded, filled }
enum ColorType { red, green, blue }

class SetCard {
  final TextureType texture;
  final ShapeType shape;
  final ColorType color;
  final int count;

  SetCard(this.texture, this.shape, this.color, this.count);
}

class SetCardView extends StatelessWidget {
  final SetCard card;

  const SetCardView({Key key, this.card}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2.25 / 3.5,
        child: Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        card.count,
                        (index) => ShapeView(
                            texture: card.texture,
                            shape: card.shape,
                            color: card.color)).toList()))));
  }
}

class ShapeView extends StatelessWidget {
  final TextureType texture;
  final ShapeType shape;
  final ColorType color;

  const ShapeView({Key key, this.texture, this.shape, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2.5,
        child: CustomPaint(painter: ShapePainter(texture, shape, color)));
  }
}

Map<ColorType, Color> COLOR_MAP = {
  ColorType.red: Colors.red,
  ColorType.blue: Colors.blue,
  ColorType.green: Colors.green,
};

class ShapePainter extends CustomPainter {
  final TextureType texture;
  final ShapeType shape;
  final ColorType color;

  ShapePainter(this.texture, this.shape, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint interiorPaint = getInteriorPaint(size);
    Paint borderPaint = Paint()
      ..color = COLOR_MAP[color]
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    Path shape = getPath(size);
    canvas.drawPath(shape, interiorPaint);
    canvas.drawPath(shape, borderPaint);
  }

  Path getPath(Size size) {
    switch (shape) {
      case ShapeType.diamond:
        return Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width / 2, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case ShapeType.pill:
        double r = size.height / 2;
        return Path()
          ..moveTo(r, 0)
          ..lineTo(size.width - r, 0)
          ..arcToPoint(Offset(size.width - r, size.height),
              radius: Radius.circular(r))
          ..lineTo(r, size.height)
          ..arcToPoint(Offset(r, 0), radius: Radius.circular(r));
      case ShapeType.squiggly:
        Offset p0 = Offset(0, size.height * .6);
        Offset p1 = Offset(size.width * .55, size.height * .15);
        Offset p2 = Offset(size.width, size.height * .4);
        Offset p3 = Offset(size.width * .45, size.height * .85);

        Offset slant = Offset.fromDirection(.6);

        Offset cp0 = p0 - Offset(0, size.height * .6);
        Offset cp1 = p1 - slant * size.height * .8;
        Offset cp2 = p1 + slant * size.height * .5;
        Offset cp3 = p2 - Offset(0, size.height * 1.1);
        Offset cp4 = p2 + Offset(0, size.height * .6);
        Offset cp5 = p3 + slant * size.height * .8;
        Offset cp6 = p3 - slant * size.height * .5;
        Offset cp7 = p0 + Offset(0, size.height * 1.1);

        return Path()
          ..moveTo(p0.dx, p0.dy)
          ..cubicTo(cp0.dx, cp0.dy, cp1.dx, cp1.dy, p1.dx, p1.dy)
          ..cubicTo(cp2.dx, cp2.dy, cp3.dx, cp3.dy, p2.dx, p2.dy)
          ..cubicTo(cp4.dx, cp4.dy, cp5.dx, cp5.dy, p3.dx, p3.dy)
          ..cubicTo(cp6.dx, cp6.dy, cp7.dx, cp7.dy, p0.dx, p0.dy);
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) {
    return oldDelegate.texture != texture ||
        oldDelegate.shape != shape ||
        oldDelegate.color != color;
  }

  Paint getInteriorPaint(Size size) {
    switch (texture) {
      case TextureType.filled:
        return Paint()..color = COLOR_MAP[color];
      case TextureType.outline:
        return Paint()..color = Colors.transparent;
      case TextureType.banded:
        return Paint()
          ..color = COLOR_MAP[color]
          ..shader = LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: getColors(20),
                  stops: getStops(20))
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }
  }

  List<Color> getColors(int numberOfBands) {
    return List.generate(
            numberOfBands,
            (index) => [
                  Colors.transparent,
                  Colors.transparent,
                  COLOR_MAP[color],
                  COLOR_MAP[color]
                ]).expand((e) => e).toList() +
        [Colors.transparent, Colors.transparent];
  }

  List<double> getStops(int numberOfBands) {
    return List.generate(numberOfBands, (index) {
          double start = index / (numberOfBands + .5);
          double end = (index + 1) / (numberOfBands + .5);
          double half = start + (end - start) / 2;
          return [start, half, half, end];
        }).expand((e) => e).toList() +
        [numberOfBands / (numberOfBands + .5), 1.0];
  }
}

void main() {
  runApp(SetApp());
}

class SetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SET!!!',
      home: SetHome(),
    );
  }
}

class SetHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SetHomeState();
}

class SetHomeState extends State<SetHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.shade50,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SetCardView(
                        card: SetCard(TextureType.banded, ShapeType.pill,
                            ColorType.green, 3))),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SetCardView(
                        card: SetCard(TextureType.outline, ShapeType.diamond,
                            ColorType.red, 3))),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SetCardView(
                        card: SetCard(TextureType.filled, ShapeType.diamond,
                            ColorType.blue, 1))),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SetCardView(
                        card: SetCard(TextureType.banded, ShapeType.squiggly,
                            ColorType.blue, 1))),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SetCardView(
                        card: SetCard(TextureType.filled, ShapeType.squiggly,
                            ColorType.blue, 2))),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SetCardView(
                        card: SetCard(TextureType.outline, ShapeType.squiggly,
                            ColorType.green, 1))),
              ),
            ],
          )
        ]));
  }
}
