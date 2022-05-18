import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../scoped_models/main-model.dart';

class CoursesWidget extends StatefulWidget {
  final MainModel model;
  final int? teacherId;

  CoursesWidget(this.model, this.teacherId);

  @override
  State createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  @override
  void initState() {
    int? userId = widget.model.authUser?.id;
    if (userId != null) {
      print(widget.teacherId);
      if (widget.teacherId != null)
        widget.model.fetchCourses(widget.teacherId as int);
      else
        widget.model.fetchCourses(userId);
    }
  }

  Widget _buildCourseItem(BuildContext context, int index, MainModel model) {
    return Card(
      child: Container(
        child: Row(
          children: [
            Text(model.courses[index].title),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context,
                        '/courses/${model.courses[index].id}/deadline'),
                    child: Text("Edit Deadline"),
                    style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20))),
                SizedBox(width: 10),
                OutlinedButton(
                    // onPressed: () => Navigator.pushNamed(context, '/courses/${4}/criteria'), child: Text("View Criteria")),
                    onPressed: () => Navigator.pushNamed(context,
                        '/courses/${model.courses[index].id}/criteria'),
                    child:
                        Text(AppLocalizations.of(context).evaluationCriteria),
                    style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20))),
                OutlinedButton(
                    onPressed: () => _onEdit(model.courses[index].id),
                    child: Text(AppLocalizations.of(context).edit),
                    style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20))),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () => _onDelete(model, model.courses[index].id),
                    child: Text(AppLocalizations.of(context).delete),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(20))),
              ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }

  _onEdit(int courseId) async {
    dynamic isUpdated =
        await Navigator.pushNamed(context, "/courses/${courseId}/edit");
    if (isUpdated != null) {
      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).courseUpdatedSuccessfully),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: AppLocalizations.of(context).okay,
            onPressed: () {},
          ),
        ));
      }
    }
  }

  _onDelete(MainModel model, int courseId) {
    {
      model.deleteCourse(courseId).then((value) => {
            if (value)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      AppLocalizations.of(context).courseDeletedSuccessfully),
                  duration: Duration(seconds: 20),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      model.unDeleteCourse(courseId).then((value) {});
                    },
                  ),
                ))
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      AppLocalizations.of(context).courseCouldNotBeDeleted),
                  duration: Duration(seconds: 20),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context).okay,
                    onPressed: () {},
                  ),
                ))
              }
          });
    }
  }

  _onEditDeadline(int courseId) async {
    dynamic isUpdated =
        await Navigator.pushNamed(context, "/courses/${courseId}/deadline");
    if (isUpdated != null) {
      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Deadline was updated successfully"),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {},
          ),
        ));
      }
    }
  }

  // @override
  // void initState() {
  //   int? userId = widget.model.authUser?.id;
  //   if (userId != null) widget.model.fetchCourses(userId);
  // }

  Widget _buildCourseList(MainModel model) {
    return model.courses.length == 0
        ? Text(AppLocalizations.of(context).noCourseAdded)
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _buildCourseItem(context, index, model),
            itemCount: model.courses.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget? child, MainModel model) {
      return model.isLoading
          ? Text(AppLocalizations.of(context).loading)
          : _buildCourseList(model);
    });
  }
}
