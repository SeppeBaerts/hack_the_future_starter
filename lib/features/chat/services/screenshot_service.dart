import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

/// Service for capturing screenshots of widgets
class ScreenshotService {
  /// Captures a screenshot of a widget identified by its GlobalKey
  /// Returns the image as bytes (PNG format)
  Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      final RenderRepaintBoundary? boundary = key.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        debugPrint('Could not find RenderRepaintBoundary');
        return null;
      }

      // Capture the image
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) {
        debugPrint('Could not convert image to byte data');
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      return null;
    }
  }

  /// Saves screenshot bytes to a temporary file and returns the path
  /// This can be used for sharing
  Future<String?> saveScreenshot(Uint8List bytes, String filename) async {
    try {
      // For now, just return a message
      // In a real implementation, this would use path_provider to save the file
      debugPrint('Screenshot captured: ${bytes.length} bytes');
      debugPrint('To implement file saving, add path_provider package');
      return null;
    } catch (e) {
      debugPrint('Error saving screenshot: $e');
      return null;
    }
  }
}
