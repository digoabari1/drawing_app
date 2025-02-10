import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Shape> shapes = []; // List of all shapes
  Shape? currentShape; // Current shape being drawn
  Offset? startPoint; // Starting point for drawing shapes
  Offset? endPoint; // Ending point for drawing shapes
  Shape? selectedShape; // Currently selected shape for moving
  Offset? dragOffset; // Offset for moving shapes

  String selectedShapeType = 'line'; // Selected shape type
  int selectedStrokeColorIndex = 0; // Index of selected stroke color
  int selectedFillColorIndex = 0; // Index of selected fill color

  // Dropdown options
  final List<String> shapeOptions = ['line', 'oval', 'circle', 'arc'];
  final List<Color> colorOptions = [
    Colors.black,
    Colors.brown,
    Colors.orange,
    Colors.pink,
    Colors.white
  ];

  void _onPanStart(DragStartDetails details) {
    setState(() {
      startPoint = details.localPosition;
      endPoint = details.localPosition;

      // Check if a shape is being tapped for moving
      selectedShape = _getShapeAtPosition(startPoint!);
      if (selectedShape != null) {
        dragOffset = startPoint! - selectedShape!.start;
        return;
      }

      // Create a new shape based on the selected type
      currentShape = Shape(
        type: selectedShapeType,
        start: startPoint!,
        end: endPoint!,
        strokeColor: colorOptions[selectedStrokeColorIndex],
        fillColor: colorOptions[selectedFillColorIndex],
        points: selectedShapeType == 'line' ? [startPoint!] : null, // Track points for freeform lines
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      endPoint = details.localPosition;

      if (selectedShape != null) {
        // Move the selected shape
        selectedShape!.start = endPoint! - dragOffset!;
        selectedShape!.end = selectedShape!.end + (endPoint! - startPoint!);
        startPoint = endPoint;
      } else if (currentShape != null) {
        if (currentShape!.type == 'line') {
          // Add points to the freeform line
          currentShape!.points!.add(endPoint!);
        } else {
          // Update the end point for other shapes
          currentShape!.end = endPoint!;
        }
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (currentShape != null) {
        shapes.add(currentShape!);
        currentShape = null;
      }
      selectedShape = null;
      dragOffset = null;
      startPoint = null;
      endPoint = null;
    });
  }

  Shape? _getShapeAtPosition(Offset position) {
    // Check if the position is within any shape's bounds
    for (var shape in shapes.reversed) {
      if (shape.type == 'line') {
        // Check if the position is near any point in the line
        for (var point in shape.points!) {
          if ((position - point).distance <= 10) {
            return shape;
          }
        }
      } else if (shape.type == 'oval') {
        final rect = Rect.fromPoints(shape.start, shape.end);
        if (rect.contains(position)) {
          return shape;
        }
      } else if (shape.type == 'circle') {
        final radius = (shape.end - shape.start).distance;
        if ((position - shape.start).distance <= radius) {
          return shape;
        }
      } else if (shape.type == 'arc') {
        final rect = Rect.fromPoints(shape.start, shape.end);
        if (rect.contains(position)) {
          return shape;
        }
      }
    }
    return null;
  }

  void _clearCanvas() {
    setState(() {
      shapes.clear();
    });
  }

  void _drawEmoji1() {
    _clearCanvas();
    setState(() {
      // Face circle
      shapes.add(Shape(
        type: 'circle',
        start: Offset(220, 200),
        end: Offset(250, 350),
        strokeColor: Colors.orange,
        fillColor: Colors.orange,
      ));

      // Eyes
      shapes.add(Shape(
        type: 'oval',
        start: Offset(120, 105),
        end: Offset(190, 195),
        strokeColor: Colors.brown,
        fillColor: Colors.brown,
      ));
      shapes.add(Shape(
        type: 'oval',
        start: Offset(250, 105),
        end: Offset(320, 195),
        strokeColor: Colors.brown,
        fillColor: Colors.brown,
      ));

      // Smile (arc with a dip)
      shapes.add(Shape(
        type: 'arc',
        start: Offset(140, 250),
        end: Offset(300, 370),
        strokeColor: Colors.brown,
        fillColor: Colors.brown,
      ));

      shapes.add(Shape(
        type: 'arc',
        start: Offset(140, 50),
        end: Offset(190, 60),
        strokeColor: Colors.purple,
        fillColor: Colors.purple
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(100, 50),
        end: Offset(105, 50),
        strokeColor: Colors.red,
        fillColor: Colors.red
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(350, 70),
        end: Offset(355, 70),
        strokeColor: Colors.pink,
        fillColor: Colors.pink
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(50, 150),
        end: Offset(55, 150),
        strokeColor: Colors.green,
        fillColor: Colors.green
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(60, 90),
        end: Offset(65, 90),
        strokeColor: Colors.purple,
        fillColor: Colors.purple
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(400, 190),
        end: Offset(405, 190),
        strokeColor: Colors.purple,
        fillColor: Colors.purple
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(370, 280),
        end: Offset(375, 280),
        strokeColor: Colors.red,
        fillColor: Colors.red
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(320, 360),
        end: Offset(325, 360),
        strokeColor: Colors.purple,
        fillColor: Colors.purple
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(220, 400),
        end: Offset(225, 400),
        strokeColor: Colors.green,
        fillColor: Colors.green
      ));
    });
  }

  void _drawEmoji2() {
    _clearCanvas();
    setState(() {
      shapes.add(Shape(
        type: 'circle',
        start: Offset(220, 200),
        end: Offset(250, 350),
        strokeColor: Colors.orange,
        fillColor: Colors.orange,
      ));
      
      shapes.add(Shape(
        type: 'oval',
        start: Offset(120, 105),
        end: Offset(190, 195),
        strokeColor: Colors.black,
        fillColor: Colors.white,
      ));
      shapes.add(Shape(
        type: 'oval',
        start: Offset(250, 105),
        end: Offset(320, 195),
        strokeColor: Colors.black,
        fillColor: Colors.white,
      ));

      shapes.add(Shape(
        type: 'circle',
        start: Offset(155, 150),
        end: Offset(160, 150),
        strokeColor: Colors.black,
        fillColor: Colors.black,
      ));
      shapes.add(Shape(
        type: 'circle',
        start: Offset(285, 150),
        end: Offset(290, 150),
        strokeColor: Colors.black,
        fillColor: Colors.black,
      ));

      shapes.add(Shape(
        type: 'arc',
        start: Offset(175, 250),
        end: Offset(275, 650),
        strokeColor: Colors.black,
        fillColor: Colors.pink
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: Column(
        children: [
          // Shape selection dropdown
          DropdownButton<String>(
            value: selectedShapeType,
            onChanged: (String? newValue) {
              setState(() {
                selectedShapeType = newValue!;
              });
            },
            items: shapeOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Stroke color selection dropdown (no transparent option)
          DropdownButton<int>(
            value: selectedStrokeColorIndex,
            onChanged: (int? newValue) {
              setState(() {
                selectedStrokeColorIndex = newValue!;
              });
            },
            items: colorOptions.asMap().entries.map<DropdownMenuItem<int>>((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Container(
                  width: 50,
                  height: 20,
                  color: entry.value,
                ),
              );
            }).toList(),
          ),

          // Fill color selection dropdown
          DropdownButton<int>(
            value: selectedFillColorIndex,
            onChanged: (int? newValue) {
              setState(() {
                selectedFillColorIndex = newValue!;
              });
            },
            items: colorOptions.asMap().entries.map<DropdownMenuItem<int>>((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Container(
                  width: 50,
                  height: 20,
                  color: entry.value,
                  child: entry.key == 0 ? Center(child: Text('No Fill')) : null,
                ),
              );
            }).toList(),
          ),

          // Emoji buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _drawEmoji1,
                child: Text('🥳'),
              ),
              ElevatedButton(
                onPressed: _drawEmoji2,
                child: Text('😜'),
              ),
            ],
          ),

          // Drawing canvas
          Expanded(
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(shapes, currentShape),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearCanvas,
        child: Icon(Icons.clear),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Shape> shapes;
  final Shape? currentShape;

  DrawingPainter(this.shapes, this.currentShape);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all shapes
    for (var shape in shapes) {
      _drawShape(canvas, shape);
    }

    // Draw the current shape being drawn
    if (currentShape != null) {
      _drawShape(canvas, currentShape!);
    }
  }

  void _drawShape(Canvas canvas, Shape shape) {
    Paint paint = Paint()
      ..color = shape.strokeColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    Paint fillPaint = Paint()
      ..color = shape.fillColor
      ..style = PaintingStyle.fill;

    switch (shape.type) {
      case 'line':
        if (shape.points != null) {
          for (int i = 0; i < shape.points!.length - 1; i++) {
            canvas.drawLine(shape.points![i], shape.points![i + 1], paint);
          }
        }
        break;
      case 'oval':
        final rect = Rect.fromPoints(shape.start, shape.end);
        canvas.drawOval(rect, paint);
        if (shape.fillColor != Colors.transparent) {
          canvas.drawOval(rect, fillPaint);
        }
        break;
      case 'circle':
        double radius = (shape.end - shape.start).distance;
        canvas.drawCircle(shape.start, radius, paint);
        if (shape.fillColor != Colors.transparent) {
          canvas.drawCircle(shape.start, radius, fillPaint);
        }
        break;
      case 'arc':
        final rect = Rect.fromPoints(shape.start, shape.end);
        final path = Path();
        final center = Offset(
          (shape.start.dx + shape.end.dx) / 2,
          (shape.start.dy + shape.end.dy) / 2,
        );
        final width = rect.width;
        final height = rect.height;

        // Draw a symmetrical arc with a small dip in the middle
        path.moveTo(shape.start.dx, shape.start.dy);
        path.quadraticBezierTo(
          center.dx,
          center.dy + height * 0.3, // Add a dip in the middle
          shape.end.dx,
          shape.start.dy,
        );

        canvas.drawPath(path, paint);
        if (shape.fillColor != Colors.transparent) {
          canvas.drawPath(path, fillPaint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Shape {
  final String type; // Shape type: line, oval, circle, arc
  Offset start; // Starting point
  Offset end; // Ending point
  final Color strokeColor; // Stroke color
  final Color fillColor; // Fill color
  List<Offset>? points; // Points for freeform lines

  Shape({
    required this.type,
    required this.start,
    required this.end,
    required this.strokeColor,
    required this.fillColor,
    this.points,
  });
}