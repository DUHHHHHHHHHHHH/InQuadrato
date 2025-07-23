import 'package:flutter/material.dart';

class ModelControlBar extends StatelessWidget {
  final VoidCallback onOriginalFilter;
  final VoidCallback onPixelArtFilter;
  final VoidCallback onGrayscaleFilter;
  final VoidCallback onScreenshot;

  const ModelControlBar({
    super.key,
    required this.onOriginalFilter,
    required this.onPixelArtFilter,
    required this.onGrayscaleFilter,
    required this.onScreenshot,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: onOriginalFilter,
            child: const Text('Originale'),
          ),
          ElevatedButton(
            onPressed: onPixelArtFilter,
            child: const Text('Pixel Art'),
          ),
          ElevatedButton(
            onPressed: onGrayscaleFilter,
            child: const Text(
              'B/N',
            ), // BIANCO E NERO (alcune volte mi scordo cosa significa)
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: onScreenshot,
            tooltip: 'Acquisisci Screenshot',
          ),
        ],
      ),
    );
  }
}
