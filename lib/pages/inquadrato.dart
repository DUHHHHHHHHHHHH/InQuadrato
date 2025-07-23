import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/classemodello.dart';
import '../services/file.dart';
import '../widgets/widget-inquadra-oggetto.dart';
import '../widgets/widget-selezione.dart';
import '../utils/path_utils.dart';
import '../forms/import.dart'; // <--- importa il nuovo dialog

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
        descrizione:
            "Kris Dreemurr è un Lightner umano e il protagonista principale di Deltarune. È presumibilmente l'Eroe umano della Luce nella Profezia. In un Mondo Oscuro, funge da leader del gruppo. Kris è controllato dal giocatore per la maggior parte del gioco. Le poche eccezioni sono rappresentate da brevi cutscene o da quando si strappa l'ANIMA dal corpo.",
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
        descrizione:
            "Susie è una Lightner di Hometown e uno dei deuteragonisti di Deltarune. È il mostro Eroe della Luce della Leggenda di Deltarune. Impugna un'ascia mentre si trova in un Mondo Oscuro. Grazie ai suoi alti HP e all'attacco, svolge il ruolo di tank e di demolitore del gruppo durante gli incontri.",
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
        descrizione:
            "Ralsei è un Darkner e uno dei deuteragonisti (insieme a Susie) di Deltarune. Sostiene di essere il “Principe dell'Oscurità”, menzionato nella Profezia. Con un attacco più debole e una salute massima inferiore, ma con la capacità di lanciare incantesimi di guarigione, Ralsei funge da guaritore del gruppo. In combattimento brandisce una sciarpa.",
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

  void _apriDialogImport() async {
    final nuovoOggetto = await showDialog<Oggetto3D>(
      context: context,
      builder: (context) => ImportFormDialog(),
    );
    if (nuovoOggetto != null) {
      setState(() {
        listaOggetti.add(nuovoOggetto);
        oggettoSelezionato = nuovoOggetto;
      });

      // Qui puoi aggiungere il salvataggio su disco o database
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("InQuadrato!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Importa nuovo modello',
            onPressed: _apriDialogImport,
          ),
        ],
      ),
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
