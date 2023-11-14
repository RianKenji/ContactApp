import 'package:contact/models/contact.dart';
import 'package:contact/util/database_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Contact List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  late DatabaseHelper _dbHelper;

  void initState(){
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();
  }

  _refreshContactList() async{
  List<Contact> x = await _dbHelper.fetchContacts();
  setState(() {
    _contacts = x;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title, style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  _form() => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            validator: (val) => (val?.length == 0 ? 'This field is mandatory' : null),
            onSaved: (val) => setState(() => _contact.name = val!),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Mobile Number'),
            validator: (val) => (val!.length < 10 ? '10 characters required' : null),
            onSaved: (val) => setState(() => _contact.mobile = val!),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () => _onSubmit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Submit'),
            ),
          )
        ],
      ),
    ),
  );

  _onSubmit() async{
    var form = _formKey.currentState;
    if(form!.validate()){
      form.save();
      await _dbHelper.insertContact(_contact);
      /*print("Full Name : ${_contact.name}"
      'Mobile: ${_contact.mobile}');
      _contacts.add(Contact(id: null, name: _contact.name, mobile: _contact.mobile));*/
      form.reset();
      await _refreshContactList();
    }
  }


  _list() => Expanded(
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
              itemBuilder: (context, index){
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle, color: Colors.blueAccent, size: 40.0,
                    ),
                    title: Text(
                      _contacts[index].name.toUpperCase(),
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_contacts[index].mobile),
                  ),
                  Divider(height: 5.0,),
                ],
              );
              }, itemCount: _contacts.length,
              ),
        ),
      )
  );
}
