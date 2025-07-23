import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/classemodello.dart';

class ImportFormDialog extends StatefulWidget {
  @override
  _ImportFormDialogState createState() => _ImportFormDialogState();
}

class _ImportFormDialogState extends State<ImportFormDialog> {
  final _formKey = GlobalKey<FormState>();

  String nome = '';
  String categoria = '';
  String? materiale;
  String? descrizione;
  String? source;
  String? anteprimaPath;
  String? modelPath;

  bool _loading = false;

  Future<void> _pickAnteprima() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        anteprimaPath = result.files.single.path;
      });
    }
  }

  Future<void> _pickModel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['obj', 'fbx', 'glb'],
    );
    if (result != null) {
      setState(() {
        modelPath = result.files.single.path;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (modelPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Devi selezionare un file 3D.')),
      );
      return;
    }
    if (anteprimaPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devi selezionare un\'immagine di anteprima.'),
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _loading = true;
    });

    final file = File(modelPath!);
    final pesoKb = await file.length() / 1024;

    final nuovoOggetto = Oggetto3D(
      nome: nome,
      peso: pesoKb,
      categoria: categoria,
      materiale: materiale,
      descrizione: descrizione,
      source: source,
      anteprima: anteprimaPath,
      path: modelPath!,
      dataCreazione: DateTime.now(),
    );

    setState(() {
      _loading = false;
    });

    Navigator.of(context).pop(nuovoOggetto);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importa nuovo modello'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Inserisci un nome' : null,
                onSaved: (v) => nome = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Categoria'),
                onSaved: (v) => categoria = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Materiale'),
                onSaved: (v) => materiale = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrizione'),
                maxLines: 3,
                onSaved: (v) => descrizione = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Source (URL)'),
                onSaved: (v) => source = v,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickAnteprima,
                    child: const Text('Scegli immagine anteprima'),
                  ),
                  const SizedBox(width: 10),
                  if (anteprimaPath != null)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickModel,
                    child: const Text('Scegli file 3D'),
                  ),
                  const SizedBox(width: 10),
                  if (modelPath != null)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Importa'),
        ),
      ],
    );
  }
}
