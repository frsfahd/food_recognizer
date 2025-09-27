import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recognizer/controller/home_provider.dart';
import 'package:food_recognizer/controller/image_classification_provider.dart';
import 'package:food_recognizer/util/helper.dart';
import 'package:food_recognizer/widget/classification_item.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    final homeProvider = context.read<HomeProvider>();

    final imageProvider = context.read<ImageClassificationViewmodel>();

    Future.microtask(() {
      final image = homeProvider.imageFile;
      imageProvider.runClassificationFromImage(image!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Result")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 16),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Image.file(
                File(homeProvider.imagePath.toString()),
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            Consumer<ImageClassificationViewmodel>(
              builder: (context, value, _) {
                final classifications = value.classifications.entries;
                final isLoading = value.isLoading;

                if (isLoading) {
                  return const LinearProgressIndicator();
                }

                // return SizedBox.shrink();

                return SingleChildScrollView(
                  child: Column(
                    children: classifications
                        .map(
                          (classification) => ClassificationItem(
                            item: classification.key,
                            value: toPercentage(classification.value),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
