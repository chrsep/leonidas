import 'package:flutter/cupertino.dart';

class Exercise extends ChangeNotifier {
Exercise(this.name, this.description, this.maxRep);

  final String name;
  final String description;
  // repetition x weight
  final Map<int, int> maxRep;
}
