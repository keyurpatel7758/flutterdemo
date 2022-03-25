import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/standard.dart';
import 'package:tution_class/src/providers/profile_provider.dart';

class StandardSelection extends StatefulWidget {
  final String selectedStandards;

  StandardSelection({required this.selectedStandards});

  @override
  _StandardSelectionState createState() => _StandardSelectionState();
}

class _StandardSelectionState extends State<StandardSelection> {
  List<Standard> standards = [
    Standard(stdValue: '5', stdText: 'std 5', isSelected: false),
    Standard(stdValue: '6', stdText: 'std 6', isSelected: false),
    Standard(stdValue: '7', stdText: 'std 7', isSelected: false),
    Standard(stdValue: '8', stdText: 'std 8', isSelected: false),
    Standard(stdValue: '9', stdText: 'std 9', isSelected: false),
  ];

  @override
  void initState() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    var selectedStd = profileProvider.standards;

    standards.forEach((element) {
      if (selectedStd.indexOf(element.stdValue) > -1) {
        element.isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Container(
      child: Column(
        children: [
          ...standards
              .map((b) => buildSingleCheckbox(b, profileProvider))
              .toList(),
        ],
      ),
    );
  }

  Widget buildSingleCheckbox(
          Standard standard, ProfileProvider profileProvider) =>
      buildCheckbox(
        standard: standard,
        onClicked: () {
          setState(() {
            final newValue = !standard.isSelected;
            standard.isSelected = newValue;
            if (newValue) {
              profileProvider.addStandard = standard.stdValue;
            } else {
              profileProvider.removeStandard = standard.stdValue;
            }
          });
        },
      );

  Widget buildCheckbox({
    required Standard standard,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: standard.isSelected,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          standard.stdText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}
