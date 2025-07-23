import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

import '../models/classemodello.dart';
import '../utils/path_utils.dart';

import 'model_rotation_slider.dart';
import 'model_control_bar.dart';
import 'model_viewer_display.dart';
import 'oggetto_details_card.dart';

class ViewOggettoWidget extends StatefulWidget {
  final Oggetto3D oggetto;

  const ViewOggettoWidget({super.key, required this.oggetto});

  @override
  State<ViewOggettoWidget> createState() => _ViewOggettoWidgetState();
}

class _ViewOggettoWidgetState extends State<ViewOggettoWidget> {
  Key _modelViewerKey = UniqueKey();
  double _horizontalRotation = 0.0;
  final double _verticalAngle = 30.0;
  final String _cameraRadius = 'auto';

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void didUpdateWidget(covariant ViewOggettoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.oggetto != oldWidget.oggetto) {
      setState(() {
        _modelViewerKey = UniqueKey();
        _horizontalRotation = 0.0;
      });
    }
  }

  Future<void> _takeScreenshot() async {
    try {
      final image = await screenshotController.capture();
      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossibile catturare lo screenshot.')),
        );
        return;
      }

      if (kIsWeb) {
        final blob = html.Blob([image]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute(
            'download',
            'modello_${DateTime.now().millisecondsSinceEpoch}.png',
          )
          ..click();
        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronto per il download!')),
        );
      } else {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          final directory = await getTemporaryDirectory();
          final imagePath =
              '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
          final File file = File(imagePath);
          await file.writeAsBytes(image);

          final result = await ImageGallerySaver.saveFile(file.path);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Screenshot salvato nella galleria!')),
          );
          print('Screenshot salvato: $result');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Permesso di archiviazione negato. Non è possibile salvare lo screenshot.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Errore durante lo screenshot: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante lo screenshot: $e')),
      );
    }
  }

  void _applyOriginalFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtro "Originale" (non implementato)')),
    );
  }

  void _applyPixelArtFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtro "Pixel Art" (non implementato)')),
    );
  }

  void _applyGrayscaleFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtro "Bianco e Nero" (non implementato)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String modelSrc = fixAssetPath('assets/${widget.oggetto.path}');
    final double thetaRadians = _horizontalRotation * (3.1415926535 / 180);

    return Column(
      children: [
        ModelRotationSlider(
          currentRotation: _horizontalRotation,
          onChanged: (value) {
            setState(() {
              _horizontalRotation = value;
            });
          },
        ),

        ModelControlBar(
          onOriginalFilter: _applyOriginalFilter,
          onPixelArtFilter: _applyPixelArtFilter,
          onGrayscaleFilter: _applyGrayscaleFilter,
          onScreenshot: _takeScreenshot,
        ),

        Expanded(
          flex: 7,
          child: ModelViewerDisplay(
            modelViewerKey: _modelViewerKey,
            modelSrc: modelSrc,
            modelAlt: widget.oggetto.nome,
            cameraOrbit:
                '${thetaRadians}rad ${_verticalAngle}deg ${_cameraRadius}',
            screenshotController: screenshotController,
          ),
        ),

        Expanded(flex: 3, child: OggettoDetailsCard(oggetto: widget.oggetto)),
      ],
    );
  }
}
