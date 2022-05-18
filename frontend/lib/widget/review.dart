import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../scoped_models/main-model.dart';

class ReviewWidget extends StatefulWidget{
  late final MainModel model;
  late final int? reviewId;
  ReviewWidget(this.model,this.reviewId);
  @override
  State createState() => _ReviewWidgetState();
}


class _ReviewWidgetState extends State<ReviewWidget> {

  @override
  void initState() {
        print(widget.reviewId);
        widget.model.fetchReview(widget.reviewId as int);
  }

  Widget _buildReviewItem(BuildContext context, int index, MainModel model) {
    return
      Card(
      child: Container(
        child: Row(
          children: [
            Expanded(
                child: Text(model.review[index].question), flex: 6,),
            // SizedBox(width: 500),
            Expanded(child: Text(model.review[index].comment), flex: 3),
            // SizedBox(width: 300),
            Expanded(child: Text(model.review[index].rating.toString()), flex: 1),
            // SizedBox(width: 100),
          ],
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

  Widget _buildReviewList(MainModel model){
    return model.review.length == 0 ?
    Text(AppLocalizations.of(context).noReviewAdded)
        :ListView.builder(
        itemBuilder: (BuildContext context, int index)=>  _buildReviewItem(context,index,model),
        itemCount: model.review.length
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return model.isLoading ?
      Text(AppLocalizations.of(context).loading)
          : _buildReviewList(model)
      ;
    });
  }

}