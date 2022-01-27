import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Modules/Components.dart';
import 'Shared/Cubit/Cubit.dart';
import 'Shared/Cubit/States.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return buildTasks(AppCubit.get(context).archivedTasks);
      },
    );
  }
}
