import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/focus_mask.dart';

void main() {
  runApp(QRScanner());
}

class QRScanner extends StatelessWidget {
  QRScanner({super.key});

  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                for (final barcode in barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
                }
              },
            ),
            maskWidget(),
          ],
        ),
      ),
    );
  }

  Widget maskWidget() {
    return CustomPaint(
      size: Size.infinite,
      painter: FocusMask(),
    );
  }
}
