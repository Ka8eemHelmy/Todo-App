
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app/ArchivedScreen.dart';
import 'package:tasks_app/DoneScreen.dart';
import 'package:tasks_app/Shared/Cubit/States.dart';
import 'package:tasks_app/TasksScreen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];

  List<String> tittleAppBar = ["Tasks", "Done", "Archived"];

  var currentIndex = 0;

  Database? database;

  bool isBottomShown = false;

  IconData floatingIcon = Icons.edit;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void currentIndexChanged(int index) {
    currentIndex = index;
    emit(CurrentIndexChanged());
  }

  void changeBottomSheetStatue(bool isBottomShown, IconData icon) {
    this.isBottomShown = isBottomShown;
    floatingIcon = icon;
    emit(ChangeBottomSheetStatue());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        await database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, tittle TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError(
          (error) {
            print('Error when creating table : ${error.toString()}');
          },
        );
      },
      onOpen: (database) {
        print('Database is Opened');
        getFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDatabase());
    });
  }

  insertToDatabase(String tittle, String date, String time) {
    database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(tittle, date, time, status) VALUES("$tittle", "$date", "$time", "New")')
          .then((value) {
        print('Row $value Inserted');
        emit(InsertIntoDatabase());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error when creating table : ${error.toString()}');
      });
      return null;
    });
  }

  void getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetFromDatabaseLoading());
    database?.rawQuery('SELECT * FROM Tasks').then((value) {
      print(value);
      value.forEach((element) {
        if (element['status'] == 'New' || element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetFromDatabase());
    }).catchError((error) {
      print('getFromDatabase Error $error');
    });
  }

  void updateDatabase(String status, int id) {
    database?.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getFromDatabase(database);
      emit(UpdateDatabase());
    });
  }

  void deleteDatabase(int id) {
    database?.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(DeleteDatabase());
    });
  }
}
