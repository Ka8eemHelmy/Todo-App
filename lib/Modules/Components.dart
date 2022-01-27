import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/Shared/Cubit/Cubit.dart';

Widget TextForFieldCompo(
    {required TextEditingController controller,
    required TextInputType type,
    required String label,
    required IconData icon,
    Function? onTap,
    required String messageError}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: label,
      prefixIcon: Icon(icon),
    ),
    onTap: () {
      onTap;
    },
    validator: (value) {
      if (value!.isEmpty) {
        return messageError;
      }
      return null;
    },
  );
}

Widget buildTasksItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabase(model['id']);
    },
    direction: DismissDirection.endToStart,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 20.0, end: 20.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              "${model['time']}",
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['tittle']}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            icon: (Icon(
              Icons.done_outline_sharp,
              color: Colors.green,
            )),
            onPressed: () {
              AppCubit.get(context).updateDatabase('Done', model['id']);
            },
          ),
          IconButton(
            icon: (Icon(
              Icons.archive,
              color: Colors.red,
            )),
            onPressed: () {
              AppCubit.get(context).updateDatabase('Archived', model['id']);
            },
          ),
        ],
      ),
    ),
  );
}

Widget buildTasks(List<Map> tasks) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.builder(
        itemBuilder: (context, index) {
          return buildTasksItem(tasks[index], context);
        },
        itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 70.0,
            color: Colors.grey,
          ),
          Text(
            'Please, Add Some New Tasks',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
