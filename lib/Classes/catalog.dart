class Catalog {
  final int id;
  final String name;
  final int company;
  final String pdf_url;

  Catalog({this.id, this.name, this.company, this.pdf_url});

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      pdf_url: json['pdf_file'],
    );
  }
}
