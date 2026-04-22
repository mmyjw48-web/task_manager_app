import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: ListTaskScreen(),
    );
  }
}

class UserModel {
  int? id;
  String nama = '';
  int umur = 0;
  UserModel({this.id, required this.nama, required this.umur});
}

class ListTaskScreen extends StatefulWidget {
  const ListTaskScreen({super.key});

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  @override
  final List<UserModel> tasks = [
    UserModel(id: 1, nama: 'satu', umur: 10),
    UserModel(id: 2, nama: 'Dua', umur: 20),
    UserModel(id: 3, nama: 'Tiga', umur: 30),
    UserModel(id: 4, nama: 'Empat', umur: 40),
  ];
  void _form(int? id) {
    final TextEditingController _nameCtrl = TextEditingController();
    final TextEditingController _umurCtrl = TextEditingController();
    if (id != null) {
      final data = tasks.firstWhere((e) => e.id == id);

      _nameCtrl.text = data.nama;
      _umurCtrl.text = data.umur.toString();
    } else {
      _nameCtrl.clear();
      _umurCtrl.clear();
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: (context),
      builder: (context) => Padding(
        padding: EdgeInsetsGeometry.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(hintText: "Nama"),
            ),
            TextField(
              controller: _umurCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "umur"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isEmpty || _umurCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Semua field harus diisi")),
                  );
                }
                int? umur = int.tryParse(_umurCtrl.text);

                if (umur == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Umur harus angka")));
                  return;
                }
                _save(id, _nameCtrl.text, int.parse(_umurCtrl.text));
                _nameCtrl.clear();
                _umurCtrl.clear();
                Navigator.pop(context);
              },
              child: id != null ? Text('Perubarui') : Text('Tampah'),
            ),
          ],
        ),
      ),
    );
  }

  void _delete(int? id) {
    showDialog(
      context: (context),
      builder: (context) => AlertDialog(
        title: Text("Pasti !!"),
        content: Text('Apkah Kamu yaqin ingin menhaous tugas ini ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Batatl'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks.removeWhere((data) => data.id == id);
              });
              Navigator.pop(context);
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  //  Save function
  void _save(int? id, String nama, int umur) {
    if (id != null) {
      final index = tasks.indexWhere((data) => data.id == id);
      setState(() {
        tasks[index].nama = nama;
        tasks[index].umur = umur;
      });
    } else {
      var nextUser = tasks.length + 1;
      var newUser = UserModel(id: id, nama: nama, umur: umur);
      setState(() {
        tasks.add(newUser);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text('Tasks Manager')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (ctx, index) {
          // return Text('Hello World');
          return ListTile(
            tileColor: const Color.fromARGB(255, 241, 176, 122),
            title: Text(tasks[index].nama.toString()),
            subtitle: Text("Umur : ${tasks[index].umur.toString()} Tahun "),
            trailing: SizedBox(
              width: 130,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => _form(tasks[index].id),
                    child: Icon(Icons.edit),
                  ),
                  TextButton(
                    onPressed: () {
                      _delete(tasks[index].id);
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _form(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
