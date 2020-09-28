class Medicion {
  static const tblMedicion = 'mediciones';
  static const colId = 'id';
  static const colDomicilio = 'domicilio';
  static const colMedidor = 'medidor';
  static const colLectura = 'lectura';

  Medicion({this.id, this.medidor, this.lectura, this.domicilio});

  Medicion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lectura = json['lectura'],
        medidor = json['medidor'],
        domicilio = json['domicilio'];

  Medicion.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    medidor = map[colMedidor];
    lectura = map[colLectura];
    domicilio = map[colDomicilio];
  }

  int id;
  String medidor;
  int lectura;
  String domicilio;

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'medidor': medidor,
        'lectura': lectura,
        'domicilio': domicilio,
      };

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colMedidor: medidor, colLectura: lectura, colDomicilio: domicilio};
    if (id != null) map[colId] = id;
    return map;
  }
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
      };
}
