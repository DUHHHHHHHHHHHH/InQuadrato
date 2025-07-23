import 'package:flutter/material.dart';
import '../models/ClasseModello.dart';
import '../services/file.dart';
import '../widgets/widget-inquadra-oggetto.dart';
import '../widgets/widget-selezione.dart';

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
    final importFiles = await FileService.listaModelliImportati();

    final importati = importFiles
        .map(
          (f) => Oggetto3D(
            nome: f.uri.pathSegments.last,
            peso: f.lengthSync() / 1024, // peso in KB
            categoria: 'Importato',
            path: f.path,
          ),
        )
        .toList();

    // Lista personaggi Deltarune (sostituisce demo macchine)
    final listaDeltarune = [
      Oggetto3D(
        nome: "Kris",
        peso: 4500,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Protagonista silenzioso rivoluzionario di Deltarune.",
        source: "https://deltarune.com",
        anteprima: "assets/deltarune/modello1/preview.jpeg",
        path: "assets/deltarune/modello1/model.glb",
        attributiExtra: {"ruolo": "Protagonista", "coloreVestito": "Verde"},
      ),
      Oggetto3D(
        nome: "Susie",
        peso: 5200,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Compagna d'avventura combattiva e volitiva.",
        source: "https://deltarune.com",
        anteprima: "assets/deltarune/modello2/preview.jpeg",
        path: "assets/deltarune/modello2/model.glb",
        attributiExtra: {"coloreCapelli": "Viola scuro", "ruolo": "Alleata"},
      ),
      Oggetto3D(
        nome: "Ralsei",
        peso: 4100,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Guaritore gentile e guida del gruppo.",
        source: "https://deltarune.com",
        anteprima: "assets/deltarune/modello3/preview.jpeg",
        path: "assets/deltarune/modello3/model.glb",
        attributiExtra: {"coloreMantello": "Verde", "ruolo": "Guaritore"},
      ),
      Oggetto3D(
        nome: "Noelle",
        peso: 3900,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Amica di Kris e Susie con poteri di ghiaccio.",
        source: "https://deltarune.com",
        anteprima: "assets/deltarune/modello4/preview.jpeg",
        path: "assets/deltarune/modello4/model.glb",
        attributiExtra: {"coloreCapelli": "Biondo", "ruolo": "Alleata"},
      ),
      Oggetto3D(
        nome: "Spamton",
        peso: 3600,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Miniboss e venditore ambiguo.",
        source: "https://deltarune.com",
        anteprima: "assets/deltarune/modello5/preview.jpeg",
        path: "assets/deltarune/modello5/model.glb",
        attributiExtra: {"ruolo": "Antagonista Minore"},
      ),
      Oggetto3D(
        nome: "Jevil",
        peso: 4800,
        categoria: "Personaggio",
        materiale: "Poligoni 3D",
        descrizione: "Boss opzionale e folle giullare.",
        source: "https://deltarune.com",
        anteprima: "assets/deltarune/modello6/preview.jpeg",
        path: "assets/deltarune/modello6/model.glb",
        attributiExtra: {"ruolo": "Boss"},
      ),
    ];

    setState(() {
      listaOggetti = [...listaDeltarune, ...importati];

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
      appBar: AppBar(title: const Text("Inquadra3D - Visualizzatore")),
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
