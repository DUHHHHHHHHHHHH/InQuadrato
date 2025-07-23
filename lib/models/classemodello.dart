class Oggetto3D {
  final String nome;
  final double peso; // in KB
  final String categoria;
  final String? materiale;
  final String? descrizione;
  final String? source;
  final String? anteprima;
  final String path;
  final Map<String, dynamic>? attributiExtra;
  final DateTime? dataCreazione;

  Oggetto3D({
    required this.nome,
    required this.peso,
    required this.categoria,
    this.materiale,
    this.descrizione,
    this.source,
    this.anteprima,
    required this.path,
    this.attributiExtra,
    this.dataCreazione,
  });

  factory Oggetto3D.fromJson(Map<String, dynamic> json) {
    return Oggetto3D(
      nome: json['nome'] ?? '',
      peso: (json['peso'] is int)
          ? (json['peso'] as int).toDouble()
          : (json['peso'] ?? 0.0),
      categoria: json['categoria'] ?? '',
      materiale: json['materiale'],
      descrizione: json['descrizione'],
      source: json['source'],
      anteprima: json['anteprima'],
      path: json['path'] ?? '',
      attributiExtra: json['attributiExtra'] != null
          ? Map<String, dynamic>.from(json['attributiExtra'])
          : null,
      dataCreazione: json['dataCreazione'] != null
          ? DateTime.tryParse(json['dataCreazione'])
          : null,
    );
  }
}
