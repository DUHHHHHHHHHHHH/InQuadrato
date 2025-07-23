import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/classemodello.dart';
import '../services/file.dart';
import '../widgets/widget-inquadra-oggetto.dart';
import '../widgets/widget-selezione.dart';
import '../utils/path_utils.dart';

class VisualizzatorePage extends StatefulWidget {
  const VisualizzatorePage({super.key});

  @override
  State<VisualizzatorePage> createState() => _VisualizzatorePageState();
}

class _VisualizzatorePageState extends State<VisualizzatorePage> {
  List<Oggetto3D> listaOggetti = [];
  Oggetto3D? oggettoSelezionato;

  @override
  void initState() {
    super.initState();
    caricaOggetti();
  }

  Future<void> caricaOggetti() async {
    // TODO: gestire gli import esterni. Assets interni funzionano.
    List<Oggetto3D> importati = [];
    if (!kIsWeb) {
      final importFiles = await FileService.listaModelliImportati();
      importati = importFiles
          .map(
            (f) => Oggetto3D(
              nome: f.uri.pathSegments.last,
              peso: f.lengthSync() / 1024,
              categoria: 'Importato',
              path: f.path,
            ),
          )
          .toList();
    }

    final listaDeltarune = [
      Oggetto3D(
        nome: "Kris",
        peso: 4500,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Protagonista silenzioso rivoluzionario di Deltarune.",
        source:
            "https://sketchfab.com/3d-models/kris-lightner-form-deltarune-fb0ce072a0c7413cac526834cb31189b",
        anteprima: "deltarune/kris/preview.jpeg",
        path: "deltarune/kris/kris.glb",
        attributiExtra: {"ruolo": "Protagonista", "coloreVestito": "Verde"},
      ),
      Oggetto3D(
        nome: "Susie",
        peso: 5200,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Compagna d'avventura combattiva e volitiva.",
        source:
            "https://sketchfab.com/3d-models/susie-lightner-form-deltarune-624afc3bae8043d1832698f0f8f0f9b5",
        anteprima: "deltarune/susie/preview.jpeg",
        path: "deltarune/susie/susie.glb",
        attributiExtra: {"coloreCapelli": "Viola scuro", "ruolo": "Alleata"},
      ),
      Oggetto3D(
        nome: "Ralsei",
        peso: 4100,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Guaritore gentile e guida del gruppo.",
        source:
            "https://sketchfab.com/3d-models/ralsei-deltarune-70e432c910044487ba9c717b176116a6",
        anteprima: "deltarune/ralsei/preview.jpeg",
        path: "deltarune/ralsei/ralsei.glb",
        attributiExtra: {"coloreMantello": "Verde", "ruolo": "Guaritore"},
      ),
    ];

    final listaCorretta = correggiPercorsi([...listaDeltarune, ...importati]);

    setState(() {
      listaOggetti = listaCorretta;
      print('Oggetti caricati: ${listaOggetti.length}');
      if (listaOggetti.isNotEmpty) {
        oggettoSelezionato = listaOggetti[0];
      }
    });
  }

  void selezionaOggetto(Oggetto3D obj) {
    setState(() {
      oggettoSelezionato = obj;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("InQuadrato!")),
      body: Row(
        children: [
          Container(
            width: width * 0.3,
            color: Colors.grey.shade200,
            child: SelezioneWidget(
              oggetti: listaOggetti,
              oggettoSelezionato: oggettoSelezionato,
              onSelect: selezionaOggetto,
            ),
          ),
          Container(
            width: width * 0.7,
            color: Colors.white,
            child: oggettoSelezionato != null
                ? ViewOggettoWidget(oggetto: oggettoSelezionato!)
                : const Center(child: Text("Seleziona un oggetto")),
          ),
        ],
      ),
    );
  }
}
