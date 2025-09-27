import 'package:flutter/material.dart';
import 'package:food_recognizer/ui/details_page.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
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
                MaterialPageRoute(
                  builder: (context) => DetailsPage(mealName: item),
                ),
              );
            },
            label: Text("Details..."),
          ),
        ],
      ),
    );
  }
}
