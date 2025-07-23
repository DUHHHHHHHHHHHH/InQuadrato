import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
// import 'dart:math';
// import 'package:vector_math/vector_math_64.dart' as vmath;
import '../models/classemodello.dart';

class ViewOggettoWidget extends StatefulWidget {
  final Oggetto3D oggetto;

  const ViewOggettoWidget({super.key, required this.oggetto});

  @override
  State<ViewOggettoWidget> createState() => _ViewOggettoWidgetState();
}

class _ViewOggettoWidgetState extends State<ViewOggettoWidget> {
  double rotazioneY = 0;
  late Object object3D;

  @override
  void initState() {
    super.initState();
    object3D = Object(fileName: widget.oggetto.path);
  }

  @override
  void didUpdateWidget(ViewOggettoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.oggetto.path != widget.oggetto.path) {
      object3D = Object(fileName: widget.oggetto.path);
      rotazioneY = 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            color: Colors.black12,
            padding: const EdgeInsets.all(8),
            child: Cube(
              interactive: false,
              onSceneCreated: (Scene scene) {
                scene.world.add(object3D);
                scene.camera.zoom = 10;
                object3D.rotation.setValues(0, rotazioneY, 0);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            min: 0,
            max: 360,
            value: rotazioneY,
            onChanged: (val) {
              setState(() {
                rotazioneY = val;
                object3D.rotation.setValues(0, rotazioneY, 0);
              });
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nome: ${widget.oggetto.nome}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text("Peso: ${widget.oggetto.peso.toStringAsFixed(2)} KB"),
                Text("Categoria: ${widget.oggetto.categoria}"),
                if (widget.oggetto.materiale != null)
                  Text("Materiale: ${widget.oggetto.materiale}"),
                if (widget.oggetto.descrizione != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Descrizione:\n${widget.oggetto.descrizione}"),
                  ),
                if (widget.oggetto.source != null)
                  Text("Origine: ${widget.oggetto.source}"),
                if (widget.oggetto.dataCreazione != null)
                  Text(
                    "Data di creazione: ${widget.oggetto.dataCreazione!.toLocal().toString().split(' ')[0]}",
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
