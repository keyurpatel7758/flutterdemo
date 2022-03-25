import 'package:flutter/material.dart';
import 'package:tution_class/src/models/choice_chip_data.dart';

class ChoiceChips {
  static final all = <ChoiceChipData>[
    ChoiceChipData(
      label: 'Gujarati',
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
    ),
    ChoiceChipData(
      label: 'English',
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
    )
  ];
}
