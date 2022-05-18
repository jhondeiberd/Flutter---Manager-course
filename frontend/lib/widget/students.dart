import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../scoped_models/main-model.dart';

class StudentsWidget extends StatefulWidget{
  final MainModel model;
  final int? courseId;
  StudentsWidget(this.model,this.courseId);
  @override
  State createState() => _StudentsWidgetState();
}


class _StudentsWidgetState extends State<StudentsWidget> {

  @override
  void initState() {
        print(widget.courseId);
        widget.model.fetchStudents(widget.courseId as int);
  }

  Widget _buildStudentsItem(BuildContext context, int index, MainModel model) {
    return Card(
      child: Container(
        child: Row(
          children: [
            Text(model.students[index].email),
            Row(
              children: [
                OutlinedButton(
                  // onPressed: () => Navigator.pushNamed(context, '/courses/${4}/criteria'), child: Text("View Criteria")),
                    onPressed: () => Navigator.pushNamed(context, '/review/${model.students[index].id}'),
                    child: Text(AppLocalizations.of(context).viewReview),
                    style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20)
                    )),
                SizedBox(width: 10),
              ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
  // _onEdit(int courseId)async {
  //   dynamic isUpdated = await Navigator.pushNamed(context, "/courses/${courseId}/edit");
  //   if(isUpdated!= null){
  //     if(isUpdated){
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(
  //           SnackBar(
  //             content:Text("Course was updated successfully"),
  //             duration: Duration(seconds: 5),
  //             action: SnackBarAction(
  //               label: "OK",
  //               onPressed: (){},
  //             ),
  //           ));
  //
  //     }
  //   }
  //
  // }
  // _onDelete(MainModel model,int courseId) {
  //   {
  //     model.deleteCourse(courseId).then((value) =>
  //     {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(
  //           SnackBar(
  //             content:Text((value?"Course deleted Successfully":"Course couldn't be deleted")),
  //             duration: Duration(seconds: 5),
  //             action: SnackBarAction(
  //               label: "OK",
  //               onPressed: (){},
  //             ),
  //           ))
  //     });
  //   }
  // }

  Widget _buildStudentsList(MainModel model){
    return model.students.length == 0 ?
    Text(AppLocalizations.of(context).noStudentsAdded)
        :ListView.builder(
        itemBuilder: (BuildContext context, int index)=>  _buildStudentsItem(context,index,model),
        itemCount: model.students.length
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return model.isLoading ?
      Text(AppLocalizations.of(context).loading)
          : _buildStudentsList(model)
      ;
    });
  }

}