import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks_manager/DatabseHelper.dart';

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
  // convert dari  map ke model
  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(id: json["id"], nama: json["nama"], umur: json["umur"]);
  }
  // convert dari model ke map
  Map<String, dynamic> tojson() {
    return {'id': id, 'nama': nama, 'umur': umur};
  }
}

class ListTaskScreen extends StatefulWidget {
  const ListTaskScreen({super.key});

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  List<UserModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() async {
    var user = await DatabseHelper.getData();
    setState(() {
      tasks = user;
    });
  }

  void _form(int? id) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController umurCtrl = TextEditingController();
    if (id != null) {
      final data = tasks.firstWhere((e) => e.id == id);

      nameCtrl.text = data.nama;
      umurCtrl.text = data.umur.toString();
    } else {
      nameCtrl.clear();
      umurCtrl.clear();
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
              controller: nameCtrl,
              decoration: InputDecoration(hintText: "Nama"),
            ),
            TextField(
              controller: umurCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "umur"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isEmpty || umurCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Semua field harus diisi")),
                  );
                }
                int? umur = int.tryParse(umurCtrl.text);

                if (umur == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Umur harus angka")));
                  return;
                }
                _save(id, nameCtrl.text, int.parse(umurCtrl.text));
                nameCtrl.clear();
                umurCtrl.clear();
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
      context: context,
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
            onPressed: () async {
              await DatabseHelper.deleteData(id);
              Navigator.pop(context);
              _reloadData();
            },

            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  //  Save function
  void _save(int? id, String nama, int umur) async {
    var newUser = UserModel(id: id, nama: nama, umur: umur);

    if (id != null) {
      await DatabseHelper.updateData(id, newUser);
    } else {
      await DatabseHelper.insertData(newUser);
    }
    _reloadData();
  }

  @override
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
