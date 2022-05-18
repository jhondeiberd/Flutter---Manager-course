
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../scoped_models/main-model.dart';

class TeacherWidget extends StatefulWidget{
  final MainModel model;
  TeacherWidget(this.model);
  @override
  State createState() => _TeacherWidgetState();
}
class _TeacherWidgetState extends State<TeacherWidget> {

  Widget _buildTeacherItem(BuildContext context, int index, MainModel model) {
    return Card(
      child: Container(
        child: Row(
          children: [
            Text(model.teachers[index].name),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/teachers/${model.teachers[index].id}/courses')
                    , child: Text(AppLocalizations.of(context).viewCourses),
                    style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20)
                    )
                ),
                SizedBox(width: 10),
                OutlinedButton(
                    onPressed: () => _editTeacher(model.teachers[index].id), child: Text(AppLocalizations.of(context).edit),
                    style: OutlinedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(20)
                  )
          ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: ()=>_deleteTeacher(model, model.teachers[index].id), child: Text(AppLocalizations.of(context).delete),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20)
                    )
                ),
              ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
  _editTeacher(int id)async {
    dynamic isUpdated = await Navigator.pushNamed(context, "/teacher/${id}/edit");
    if(isUpdated!= null){
      if(isUpdated){
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
              content:Text(AppLocalizations.of(context).teacherUpdatedSuccessfully),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: AppLocalizations.of(context).okay,
                onPressed: (){},
              ),
            ));

      }
    }

  }
  _deleteTeacher(MainModel model,int teacherId) {
    {
      model.deleteTeacher(teacherId).then((value) =>
      {
        if(value){
          ScaffoldMessenger.of(context)
              .showSnackBar(
              SnackBar(
                content:Text(AppLocalizations.of(context).teacherDeletedSuccessfully),
                duration: Duration(seconds: 20),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: (){
                    model.unDeleteTeacher(teacherId).then((value){

                    });
                  },
                ),
              ))
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(
              SnackBar(
                content:Text(AppLocalizations.of(context).teacherCouldNotBeDeleted),
                duration: Duration(seconds: 20),
                action: SnackBarAction(
                  label: "OK",
                  onPressed: (){},
                ),
              ))

        }
      });
    }
  }
  @override
  void initState() {
    widget.model.fetchTeacher();
  }

  Widget _buildTeacherList(MainModel model){
    return model.teachers.length == 0 ?
          Text(AppLocalizations.of(context).noTeacherAdded)
          :ListView.builder(
        itemBuilder: (BuildContext context, int index)=>  _buildTeacherItem(context,index,model),
        itemCount: model.teachers.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return model.isLoading ?
      Text(AppLocalizations.of(context).loading)
          : _buildTeacherList(model)
      ;
    });
  }

}