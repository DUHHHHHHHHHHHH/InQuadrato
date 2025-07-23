import 'package:flutter/material.dart';
import '../models/classemodello.dart'; // Assicurati che il percorso sia corretto

class OggettoDetailsCard extends StatelessWidget {
  final Oggetto3D oggetto;

  const OggettoDetailsCard({super.key, required this.oggetto});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nome: ${oggetto.nome}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text("Peso: ${oggetto.peso.toStringAsFixed(2)} KB"),
          Text("Categoria: ${oggetto.categoria}"),
          if (oggetto.materiale != null)
            Text("Materiale: ${oggetto.materiale}"),
          if (oggetto.descrizione != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Descrizione:\n${oggetto.descrizione}"),
            ),
          if (oggetto.source != null) Text("Origine: ${oggetto.source}"),
          if (oggetto.dataCreazione != null)
            Text(
              "Data di creazione: ${oggetto.dataCreazione!.toLocal().toString().split(' ')[0]}",
            ),
        ],
      ),
    );
  }
}
