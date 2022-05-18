import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/main-model.dart';
import '../../widget/courses.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';
import '../../widget/review.dart';
import '../../widget/students.dart';

class ReviewsPage extends StatelessWidget{
  late final int? reviewID;
  ReviewsPage(this.reviewID);
  // }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
          appBar: Header(),
          bottomNavigationBar: Footer(),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child:ReviewWidget(model,this.reviewID),
        ),
      );
    });

  }

}