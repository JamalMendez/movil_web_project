import 'package:flutter/material.dart';
import 'package:web_proyect/views/sidebar_screens/widgets/table_widget.dart';

class VendorsScreen extends StatefulWidget {
  VendorsScreen({super.key});

  static const String id = "\VendorsScreen";

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  int length = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Manage Vendors',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
              ),
              TableWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
