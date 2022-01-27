import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/Shared/Cubit/Cubit.dart';
import 'package:tasks_app/Shared/Cubit/States.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertIntoDatabase) {
            Navigator.pop(context);
            titleController.text = '';
            dateController.text = '';
            timeController.text = '';
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: const Icon(
                Icons.menu,
              ),
              title: Text(
                cubit.tittleAppBar[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! GetFromDatabaseLoading,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDatabase(
                      titleController.text,
                      dateController.text,
                      timeController.text,
                    )
                        .then((value) {
                      // Navigator.pop(context);
                      cubit.changeBottomSheetStatue(false, Icons.edit);
                    }).catchError((onError) {
                      print("Error here : $onError");
                    });
                  } else {
                    return null;
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              height: 250.0,
                              color: Colors.grey[100],
                              padding: EdgeInsets.all(10.0),
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: titleController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          label: Text(
                                            "Title",
                                          ),
                                          prefixIcon: Icon(Icons.title),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please, Enter Your Tittle';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: dateController,
                                        keyboardType: TextInputType.none,
                                        decoration: InputDecoration(
                                          label: Text("Date"),
                                          prefixIcon: Icon(Icons.date_range),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please, Enter Your Date';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          print("Date");
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2099-01-01'))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: timeController,
                                        keyboardType: TextInputType.none,
                                        decoration: InputDecoration(
                                          label: Text("Time"),
                                          prefixIcon:
                                              Icon(Icons.access_time_rounded),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please, Enter Your Time';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          print("Time");
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetStatue(false, Icons.edit);
                  });
                  cubit.changeBottomSheetStatue(true, Icons.add);
                }
              },
              child: Icon(cubit.floatingIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline_sharp),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: "Archived",
                ),
              ],
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.currentIndexChanged(index);
              },
            ),
          );
        },
      ),
    );
  }
}
