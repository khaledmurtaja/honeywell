import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:hex/hex.dart';

class ArabicTextZplConverter {
  ArabicTextZplConverter._internal({this.width = 560, this.height = 3000});

  static final ArabicTextZplConverter _instance = ArabicTextZplConverter._internal();

  factory ArabicTextZplConverter({int width = 560, int height = 3000}) {
    _instance.width = width;
    _instance.height = height;
    return _instance;
  }

  late  Widget _widget;
  int width;
  int height;
  final ScreenshotController _screenshotController = ScreenshotController();

  // Fixed font size
  static const double fixedFontSize = 32.0;

  Future<String> generateArabicTextAsZPL(String arabicText) async {
    final textPainter = TextPainter(
      text: TextSpan(
        text: arabicText,
        style: const TextStyle(fontFamily: 'Arial', fontSize: fixedFontSize, color: Colors.black),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: width - 20); // Max width for the text
    final contentHeight = textPainter.height;
    if (kDebugMode) {
      print(contentHeight);
    }
    // Check if content fits in a single page
    if (contentHeight <= height) {
      return await _generateSinglePageZPL(arabicText, contentHeight.toInt());
    } else {
      // Handle content overflow (multi-page scenario)
      return await _generateMultiPageZPL(arabicText, contentHeight.toInt());
    }
  }

  Future<String> _generateSinglePageZPL(String arabicText, int contentHeight) async {
    final textPainter = TextPainter(
      text: TextSpan(
        text: arabicText,
        style: const TextStyle(fontFamily: 'Arial', fontSize: fixedFontSize, color: Colors.black),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: width - 20);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), contentHeight.toDouble()),
    );

    textPainter.paint(canvas, const Offset(10, 0));
    final picture = recorder.endRecording();

    final image = await picture.toImage(width.toInt(), contentHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return await _convertImageToZPL(bytes, width.toInt(), contentHeight);
  }

  Future<String> _generateMultiPageZPL(String arabicText, int contentHeight) async {
    // Split the Arabic text into lines
    List<String> lines = arabicText.split('\n');
    if (kDebugMode) {
      print("Number of lines: ${lines.length}");
    }

    // Define the maximum number of lines per page
    const int maxLinesPerPage = 35;

    // Initialize a list to hold ZPL pages
    List<String> zplPages = [];

    // Process lines in chunks of maxLinesPerPage
    for (int i = 0; i < lines.length; i += maxLinesPerPage) {
      // Clamp the end index to the total number of lines
      int end = (i + maxLinesPerPage > lines.length) ? lines.length : i + maxLinesPerPage;

      // Extract the lines for the current page
      List<String> pageLines = lines.sublist(i, end);

      // Join the lines into a single string
      String pageText = pageLines.join('\n');

      // Calculate the height of the current page
      final textPainter = TextPainter(
        text: TextSpan(
          text: pageText,
          style: const TextStyle(fontFamily: 'Arial', fontSize: fixedFontSize, color: Colors.black),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      );

      // Layout the text to calculate its height
      textPainter.layout(maxWidth: contentHeight - 20);
      final textHeight = textPainter.height.toInt();

      // Generate ZPL for the current page
      String zplPage = await _generateSinglePageZPL(pageText, textHeight);
      zplPages.add(zplPage);

      if (kDebugMode) {
        debugPrint("Page ${zplPages.length} lines: ${pageLines.join('\n')}");
      }
    }

    // Combine all ZPL pages into a single string
    return zplPages.join("\n");
  }

  Future<String> _convertImageToZPL(Uint8List imageBytes, int width, int height) async {
    final img.Image image = img.decodeImage(imageBytes)!;
    final img.Image resizedImage = img.copyResize(image, width: width, height: height);
    final Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));

    _widget = SizedBox(
      height: height.toDouble(),
      width: width.toDouble(),
      child: Image.memory(resizedBytes),
    );

    return await _convert();
  }

  Future<String> _convert() async {
    final screenshot = await _screenshot();
    final greyScaleImage = _convertToGreyScale(screenshot);
    final resizedImage = _resizeImage(greyScaleImage);
    final pixelBits = _binarizeImage(resizedImage);
    final pixelBytes = _byteRepresentation(pixelBits);
    final hexBody = _hexRepresentation(pixelBytes);

    final bytesPerRow = (width / 8).ceil();
    final totalBytes = bytesPerRow * height;

    return _generateZpl(totalBytes, bytesPerRow, resizedImage.height, hexBody);
  }

  Future<Uint8List> _screenshot() async {
    final screenshot = await _screenshotController.captureFromWidget(_widget);
    return screenshot.buffer.asUint8List();
  }

  img.Image _convertToGreyScale(Uint8List image) {
    final decodedImage = img.decodeImage(image);
    return img.grayscale(decodedImage!);
  }

  img.Image _resizeImage(img.Image image) {
    width = _findNearestEightMultiple(width);
    height = 0;
    return img.copyResize(image, width: width, height: height);
  }

  List<int> _binarizeImage(img.Image image) {
    final List<int> pixelBits = [];
    for (int h = 0; h < image.height; h++) {
      for (int w = 0; w < image.width; w++) {
        final rgb = image.getPixelSafe(w, h);
        Uint32List list = Uint32List.fromList([rgb]);
        Uint8List byteData = list.buffer.asUint8List();
        int bit = 0;
        if (byteData.first < 128 && byteData.last > 128) {
          bit = 1;
        }
        pixelBits.add(bit);
      }
    }
    return pixelBits;
  }

  List<int> _byteRepresentation(List<int> bits) {
    final List<int> pixelBytes = [];
    for (int i = 0; i < bits.length; i += 8) {
      if (i + 8 > bits.length) {
        final remaining = 8 - (bits.length - i);
        final lastByte = List.filled(remaining, 0);
        final int val = int.parse(lastByte.join(""), radix: 2);
        pixelBytes.add(val);
        break;
      }

      final byte = bits.sublist(i, i + 8);
      final int val = int.parse(byte.join(""), radix: 2);
      pixelBytes.add(val);
    }
    return pixelBytes;
  }

  String _hexRepresentation(List<int> bytes) {
    return const HexEncoder().convert(bytes);
  }

  String _generateZpl(int totalBytes, int byteWidth, int graphicHeight, String hexBody) {
    final labelLength = graphicHeight+50;
    final zplCommand = '''
  ^XA
  ^LL$labelLength
  ^FO0,0^GFA,$totalBytes,$totalBytes,$byteWidth,$hexBody
  ^XZ
  ''';
    return zplCommand;
  }

  int _findNearestEightMultiple(int value) {
    final remainder = value % 8;
    if (remainder != 0) {
      value += (8 - remainder);
    }
    return value;
  }
}
