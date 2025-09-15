import 'package:flutter/material.dart';

class ScannerBorder extends StatelessWidget {
  const ScannerBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScannerBorderPainter(),
      size: const Size(300, 300), // adjust size
    );
  }
}

class _ScannerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF086494)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double cornerRadius = 40; // outside curve
    double cornerLength = 75; // straight length before curve

    // Path for rounded corners
    Path path = Path();

    // Top-left
    path.moveTo(0, cornerLength);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(cornerLength, 0);

    // Top-right
    path.moveTo(size.width - cornerLength, 0);
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(size.width, cornerLength);

    // Bottom-left
    path.moveTo(0, size.height - cornerLength);
    path.arcToPoint(
      Offset(cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.lineTo(cornerLength, size.height);

    // Bottom-right
    path.moveTo(size.width - cornerLength, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - cornerLength);

    // Draw everything
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
