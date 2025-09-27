import 'package:flutter/material.dart';
import 'package:food_recognizer/ui/result_page.dart';

class ClassificationItem extends StatelessWidget {
  final String item;
  final String value;

  const ClassificationItem({
    super.key,
    required this.item,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Text(item),
          const Spacer(),
          Text(value),
          const Spacer(),

          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultPage()),
              );
            },
            label: Text("Details..."),
          ),
        ],
      ),
    );
  }
}
