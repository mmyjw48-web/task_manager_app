import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'as p;
import 'package:tasks_manager/main.dart';
class DatabseHelper {
  static Database? _database ;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;

}
static Future<Database?>_initDB() async {
  String path = p.join(await getDatabasesPath(),"user_dp.dp");
  return await openDatabase(path,
    version: 1,
  onCreate: (dp,version ){
    return dp.execute("CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT , umur INTEGER)",);

  });
}
// create 
static Future<int> insertData(UserModel UserModel )async{
  final dp = await   database;
  Map<String ,dynamic> user= UserModel.tojson();
return await dp.insert("users", user,conflictAlgorithm: ConflictAlgorithm.replace);

}

// read 
static Future<List<UserModel>> getData() async{
  final dp=await database;
  List <Map<String,Object?>> result= await dp.query('users');
  List<UserModel> users= result.map((userMap){
    return UserModel.fromjson(userMap);
  }).toList();
return users;
}


//  update 
static Future<int> updateData(int id , UserModel UserModel)async {
  final dp = await database;
  var user = UserModel.tojson();
  return await dp.update('users', user,where: "id=?",whereArgs: [id]);

}



// delete
static Future<int> deleteData(int ?id )async{
  final dp = await database;
  return await dp.delete('users',where: 'id=?' ,whereArgs: [id]);
}


}