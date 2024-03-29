import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/medicion.dart';
import 'package:flutter_sqlite/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comuna Alvear - Mediciones',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Comuna Alvear - Lecturas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Medicion _medicion = Medicion();
  List<Medicion> _mediciones =[];
  DatabaseHelper _dbHelper ;
  final _formKey = GlobalKey<FormState>();
  final _ctrlMedidor = TextEditingController();
  final _ctrlLectura = TextEditingController();
  final _ctrlDomicilio = TextEditingController();

  @override
  void initState(){
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refrescarMedicionesList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Center(
          child: Text(widget.title,
            style: TextStyle(color: Colors.green[400]),),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _form(), _list()
          ],
        ),
      ),
    );
  }

  _form() => Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical:15, horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ctrlDomicilio,
                decoration: InputDecoration(labelText: 'Domicilio'),
                onSaved: (val) => setState(()=>_medicion.domicilio = val),
                validator: (val)=>(val.length == 0 ? 'Debe cargar el domicilio':null),
              ),
              TextFormField(
                controller: _ctrlMedidor,
                decoration: InputDecoration(labelText: 'N° Medidor'),
                onSaved: (val) => setState(()=>_medicion.medidor = val),
                validator: (val)=>(val.length == 0 ? 'Debe cargar el medidor':null),
              ),
              TextFormField(
                controller: _ctrlLectura,
                decoration: InputDecoration(labelText: 'Lectura'),
                onSaved: (val) => setState(()=>_medicion.lectura = int.parse(val)),
                validator: (val)=>(val.length>6 ?'Cuuidado, muy alto!':null),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: ()=> _onSumbit(),
                  child: Text('Grabar Lectura'),
                ),
              )
            ],
        ),
      )
    );

    _refrescarMedicionesList() async{
      List<Medicion> x = await _dbHelper.mostrarMediciones();
      setState(() {
        _mediciones = x;
      });
    }

  _onSumbit() async{
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_medicion.id==null) await _dbHelper.insertMedicion(_medicion);
      else await _dbHelper.updateMedicion(_medicion);
      _refrescarMedicionesList();
      _resetForm();
      print(_medicion.lectura);
    }
  }

  _resetForm() {
      setState(() {
        _formKey.currentState.reset();
        _ctrlDomicilio.clear();
        _ctrlLectura.clear();
        _ctrlMedidor.clear();
        _medicion.id = null;
      });
  }

  _list() => Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ListView.builder(
        padding: EdgeInsets.all(7),
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(_mediciones[index].domicilio+' - ('+_mediciones[index].medidor+') - '+_mediciones[index].lectura.toString()),
                onTap: () {
                  setState(() {
                    _medicion = _mediciones[index];
                    _ctrlMedidor.text = _mediciones[index].medidor;
                    _ctrlLectura.text = _mediciones[index].lectura.toString();
                    _ctrlDomicilio.text = _mediciones[index].domicilio;
                  });
                },
              ),
              Divider(
                height: 5.0,
              )
            ],
          );
        },
        itemCount: _mediciones.length,
      ),
    ),
  );
}
