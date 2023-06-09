import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/focus_mask.dart';
import 'package:qr_scanner/widget_size.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const QRScannerWidget());
}

class QRScannerWidget extends StatefulWidget {
  const QRScannerWidget({super.key});

  @override
  State createState() {
    return QRScannerState();
  }
}

class QRScannerState extends State<QRScannerWidget> {
  String _content = "";
  bool _isUri = false;
  Rect _detectionArea = Rect.zero;

  QRScannerState();

  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: WidgetSize(
              onChange: (Size size) {
                setState(() {
                  var focusSize = min(size.width, size.height) * 0.7;
                  _detectionArea = Rect.fromLTWH(
                    (size.width / 2) - (focusSize / 2.0),
                    (size.height / 2) - (focusSize / 2.0),
                    focusSize,
                    focusSize,
                  );
                });
              },
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    scanWindow: _detectionArea,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        Uri? uri = Uri.tryParse(barcodes.first.rawValue ?? "");
                        _isUri = uri?.scheme.isNotEmpty == true;
                        _content = barcodes.first.rawValue ?? "";
                      } else {
                        _isUri = false;
                        _content = "";
                      }
                      setState(() {});
                    },
                  ),
                  CustomPaint(
                    size: Size.infinite,
                    painter: FocusMask(_detectionArea),
                  ),
                  _targetWidget(context, _content),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _targetWidget(BuildContext context, String content) {
    if (content.isEmpty) {
      return Container();
    }
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_detectedWidget(context)],
            )
          ],
        ));
  }

  Widget _detectedWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(120, 0, 0, 0),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (_isUri) {
              _launchURL(context, _content);
            } else {
              _copy(context, _content);
            }
          },
          child: Row(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: Text(
                  _content,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const SizedBox(width: 8),
              _buildActionIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon() {
    if (_isUri) {
      return const Icon(Icons.open_in_new, color: Colors.white);
    } else {
      return const Icon(Icons.copy, color: Colors.white);
    }
  }

  _launchURL(BuildContext context, String url) {
    canLaunchUrl(Uri.parse(url)).then((value) {
      if (value) {
        launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        _copy(context, url);
      }
    });
  }

  _copy(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Copied!')));
    });
  }
}
