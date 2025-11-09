import 'package:flutter/material.dart';
class CategoryAddDialog extends StatefulWidget {
  const CategoryAddDialog({super.key});

  @override
  State<CategoryAddDialog> createState() => _CategoryAddDialogState();
}

class _CategoryAddDialogState extends State<CategoryAddDialog> {
  TextEditingController nameENController = TextEditingController();
  TextEditingController nameTRController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        ],
      ),
    );
  }
}
