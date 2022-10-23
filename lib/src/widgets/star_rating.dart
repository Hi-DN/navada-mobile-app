import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';

import 'colors.dart';

class StarRating extends StatelessWidget {
  const StarRating({Key? key, required this.rating}): super(key: key);

  final double rating;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return SizedBox(
      width: size.getSize(120),
      child: Row(
        children: [
          _star(rating - 0),
          _star(rating - 1),
          _star(rating - 2),
          _star(rating - 3),
          _star(rating - 4),
        ],
      ),
    );
  }

  Widget _star(double score) {
    ScreenSize size = ScreenSize();
    if(score == 0.0) {
      return Icon(Icons.star_border_outlined, color: green, size: size.getSize(22));
    } else if(score < 1.0) {
      return Icon(Icons.star_half, color: green, size: size.getSize(22));
    } else {
      return Icon(Icons.star, color: green, size: size.getSize(22));
    }
  }
}