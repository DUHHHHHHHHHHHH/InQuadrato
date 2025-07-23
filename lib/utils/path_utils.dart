import 'package:flutter/foundation.dart';
import '../models/classemodello.dart';

// questo file l'ho fatto per correggere i percorsi degli asset, per qualche motivo
// assets mi si duplica senza motivo.

String fixAssetPath(String originalPath) {
  if (!kIsWeb) return originalPath;

  if (!originalPath.startsWith('assets/')) return originalPath;

  if (!originalPath.startsWith('assets/assets/')) {
    return 'assets/' + originalPath;
  }

  return originalPath;
}

List<Oggetto3D> correggiPercorsi(List<Oggetto3D> lista) {
  String normalizzaPath(String path) {
    var p = path.replaceAll(r"\\", "/");
    if (p.startsWith("web/")) p = p.substring(4);
    while (p.contains("assets/assets"))
      p = p.replaceAll("assets/assets", "assets");
    p = p.trimLeft().replaceFirst(RegExp(r"^/+"), "");
    return p;
  }

  return lista.map((oggetto) {
    return Oggetto3D(
      nome: oggetto.nome,
      peso: oggetto.peso,
      categoria: oggetto.categoria,
      materiale: oggetto.materiale,
      descrizione: oggetto.descrizione,
      source: oggetto.source,
      anteprima: oggetto.anteprima != null
          ? normalizzaPath(oggetto.anteprima!)
          : null,
      path: normalizzaPath(oggetto.path),
      attributiExtra: oggetto.attributiExtra,
      dataCreazione: oggetto.dataCreazione,
    );
  }).toList();
}
