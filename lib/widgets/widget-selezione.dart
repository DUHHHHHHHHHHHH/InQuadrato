import 'package:flutter/material.dart';
import '../models/classemodello.dart';
import '../utils/path_utils.dart';

class SelezioneWidget extends StatelessWidget {
  final List<Oggetto3D> oggetti;
  final Oggetto3D? oggettoSelezionato;
  final Function(Oggetto3D) onSelect;

  const SelezioneWidget({
    super.key,
    required this.oggetti,
    required this.onSelect,
    this.oggettoSelezionato,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: oggetti.length,
      itemBuilder: (context, index) {
        final obj = oggetti[index];
        final isSelected = obj == oggettoSelezionato;

        Widget anteprimaWidget;
        if (obj.anteprima != null && obj.anteprima!.isNotEmpty) {
          anteprimaWidget = Image.asset(
            fixAssetPath(obj.anteprima!),
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          );
        } else {
          anteprimaWidget = const Icon(Icons.image_not_supported, size: 40);
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          child: ListTile(
            leading: anteprimaWidget,
            title: Text(obj.nome),
            onTap: () => onSelect(obj),
          ),
        );
      },
    );
  }
}
