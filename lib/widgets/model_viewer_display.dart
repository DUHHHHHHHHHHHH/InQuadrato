import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:screenshot/screenshot.dart';

class ModelViewerDisplay extends StatelessWidget {
  final Key modelViewerKey;
  final String modelSrc;
  final String modelAlt;
  final String cameraOrbit;
  final ScreenshotController screenshotController;

  const ModelViewerDisplay({
    super.key,
    required this.modelViewerKey,
    required this.modelSrc,
    required this.modelAlt,
    required this.cameraOrbit,
    required this.screenshotController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: const EdgeInsets.all(8),
      child: SizedBox.expand(
        child: Screenshot(
          controller: screenshotController,
          child: ModelViewer(
            key: modelViewerKey,
            src: modelSrc,
            alt: modelAlt,
            ar: false,
            autoRotate: false,
            cameraControls: true,
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            cameraOrbit: cameraOrbit,
          ),
        ),
      ),
    );
  }
}
