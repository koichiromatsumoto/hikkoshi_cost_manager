import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Border listBorder(int index) {
  switch (index) {
    case 0:
      return Border(
        bottom: const BorderSide(
          color: Colors.grey,
        ),
        top: const BorderSide(
          color: Colors.grey,
        ),
      );
    default:
      return Border(
        bottom: const BorderSide(
          color: Colors.grey,
        ),
      );
  }
}