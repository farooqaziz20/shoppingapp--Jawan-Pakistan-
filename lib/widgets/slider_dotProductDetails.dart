import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/colors.dart';

class SliderDotProductDetail2 extends StatelessWidget {
  const SliderDotProductDetail2({
    Key? key,
    required int current,
    required List<String> imageUrl,
  })  : _current = current,
        _imageUrl = imageUrl,
        super(key: key);

  final int _current;
  final List<String> _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _imageUrl.map((url) {
        int index = _imageUrl.indexOf(url);
        return Container(
          width: 12.0,
          height: 3.0,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
            color: _current == index ? mainColorPrimary : Color(0xFFEEEEF3),
          ),
        );
      }).toList(),
    );
  }
}
