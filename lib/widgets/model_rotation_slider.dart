import 'package:flutter/material.dart';

class ModelRotationSlider extends StatelessWidget {
  final double currentRotation;
  final ValueChanged<double> onChanged;

  const ModelRotationSlider({
    super.key,
    required this.currentRotation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: currentRotation,
      min: 0,
      max: 360,
      divisions: 360,
      label: currentRotation.round().toString(),
      onChanged: onChanged,
    );
  }
}
