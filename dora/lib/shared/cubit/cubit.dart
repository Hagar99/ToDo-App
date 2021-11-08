
import 'package:dora/modules/archivedTasks/archived_tasks_screen.dart';
import 'package:dora/modules/doneTasks/done_tasks_screen.dart';
import 'package:dora/modules/newTasks/new_tasks_screen.dart';
import 'package:dora/shared/constants/constantd.dart';
import 'package:dora/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit <AppStates>{

  AppCubit() : super(AppInitialState());


  static AppCubit get (context) => BlocProvider.of(context);


  int current_index = 0;

  List<String> screen_title =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List <Widget> screens =
  [
    new_tasks(),
    done_tasks(),
    archived_tasks(),
  ];

  Database? database;


  List<Map> newTasksList = [];
  List<Map> doneTasksList = [];
  List<Map> archivedTasksList = [];


  void changeIndex (int index) {
     current_index = index;
     emit(AppBottomNavChange());
  }

  void createDatabase() {
    openDatabase (
        'ToDoDatabase.db',
        version: 1,
        onCreate: (database, version){
           database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
          }).catchError((error){
            print('when created ${error.toString()}');
          }
          );
        },
        onOpen: (database) {
           getDataFromDatabase(database);
        }
     ).then((value) async {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future insertIntoDatabase(String title, String date, String time) async{
    return await database!.transaction((txn) async{
      txn.rawInsert
        ('INSERT INTO tasks(title , date, time, status) VALUES( "$title"," $date", "$time", "NEW")')
          .then((value) {
            emit(InsertToDatabaseState());

            getDataFromDatabase(database);
      }).catchError((error) {
        print('${error.toString()} on inserting');
      });
    });
  }

  void getDataFromDatabase(database) async {

    newTasksList = [];
    doneTasksList = [];
   archivedTasksList = [];

    database.rawQuery('SELECT * FROM tasks')
        .then((value) {
    tasks = value;

     for (var element in tasks) {
       if(element['status'] == 'NEW') {
         newTasksList.add(element);
       }
       else if(element['status'] == 'DONE') {
         doneTasksList.add(element);
       }
       else {
         archivedTasksList.add(element);
       }
     }


      // database.rawQuery('SELECT * FROM tasks')
      //     .then((value) {
      // tasks = value;
      //
      //  for (var element in tasks) {
      //    if(element['status'] == 'NEW') {
      //      newTasksList.add(element);
      //    }
      //    else if(element['status'] == 'DONE') {
      //      doneTasksList.add(element);
      //    }
      //    else {
      //      archivedTasksList.add(element);
      //    }
      //  }
      emit(GetFromDatabaseState());
    });
  }

  IconData flot = Icons.edit;

  bool isBottomSheetShown = false;

  void changeIsBottomShown(bool val, IconData icon){
    isBottomSheetShown = val;
    flot = icon;
    emit(IsBottomShownState());
  }

  void updateDatabase(String status, int id) async
  {
   database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id])
       .then((value) {

     getDataFromDatabase(database);

         emit(UpdateDataState());
   });
  }

  void DeleteData (int id)
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {

      getDataFromDatabase(database);

      emit(DeleteDataState());

    });
  }
}