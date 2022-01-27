import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/Modules/Components.dart';
import 'package:tasks_app/Shared/Cubit/Cubit.dart';
import 'package:tasks_app/Shared/Cubit/States.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return buildTasks(AppCubit.get(context).newTasks);
      },
    );
  }
}
