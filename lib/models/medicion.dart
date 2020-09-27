class Medicion{
  static const tblMedicion = 'mediciones';
  static const colId = 'id';
  static const colDomicilio = 'domicilio';
  static const colMedidor = 'medidor';
  static const colMedicion = 'medicion';

  Medicion({this.id,this.medidor,this.medicion, this.domicilio});

  Medicion.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    medidor = map[colMedidor];
    medicion = map[colMedicion];
    domicilio = map[colDomicilio];
  }

  int id;
  String medidor;
  int medicion;
  String domicilio;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colMedidor: medidor, colMedicion: medicion, colDomicilio: domicilio};
    if (id != null) map[colId] = id;
    return map;
  }
}