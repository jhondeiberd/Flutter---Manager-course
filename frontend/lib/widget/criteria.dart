import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/criteria/edit.dart';
import '../scoped_models/main-model.dart';

class CriteriaWidget extends StatefulWidget{
  final int courseId;
  final MainModel model;

  CriteriaWidget(this.courseId, this.model);
  @override
  State createState() => _CriteriaWidgetState();
}
class _CriteriaWidgetState extends State<CriteriaWidget> {

  Widget _buildCourseItem(BuildContext context, int index, MainModel model) {
    return
      Card(
      child: Container(
        child: Row(
          children: [
             Text(model.criteria[index].question),
            Row(
              children: [
                SizedBox(width: 10),
                OutlinedButton(
                    onPressed: () => _onEdit(context,model.criteria[index].id,model), child: Text(AppLocalizations.of(context).edit),   style: OutlinedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(20)
                )),
                SizedBox(width: 10),
                ElevatedButton(onPressed: ()=>_onDelete(model, model.criteria[index].id), child: Text(AppLocalizations.of(context).delete),   style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(20)
                )),
               ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
  _onEdit(BuildContext context,int criteriaId, MainModel model)async {
    dynamic isUpdated = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context ) => EditCriteriaPage(criteriaId, model)));
    if(isUpdated!= null){
      if(isUpdated){
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
              content:Text(AppLocalizations.of(context).criteriaUpdatedSuccessfully),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: AppLocalizations.of(context).okay,
                onPressed: (){},
              ),
            ));

      }
    }

  }
  _onDelete(MainModel model,int criteriaId) {
    {
      model.deleteCriteria(criteriaId).then((value) =>
      {
        if(value){
          ScaffoldMessenger.of(context)
              .showSnackBar(
              SnackBar(
                content:Text(AppLocalizations.of(context).criteriaDeletedSuccessfully),
                duration: Duration(seconds: 20),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: (){
                    model.unDeleteCriteria(criteriaId).then((value){

                    });
                  },
                ),
              ))
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(
              SnackBar(
                content:Text(AppLocalizations.of(context).criteriaCouldNotBeDeleted),
                duration: Duration(seconds: 20),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).okay,
                  onPressed: (){},
                ),
              ))

        }
      });

    }
  }
  @override
  void initState() {
    widget.model.fetchCriteria(widget.courseId);
  }

  Widget _buildCritriaList(MainModel model){
    return widget.model.criteria.length == 0 ? Text(AppLocalizations.of(context).noCriteriaAdded) : ListView.builder(
        itemBuilder: (BuildContext context, int index)=>  _buildCourseItem(context,index,model),
        itemCount: model.criteria.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return model.isLoading ?
      Text(AppLocalizations.of(context).loading)
          : _buildCritriaList(model)
      ;
    });
  }

}