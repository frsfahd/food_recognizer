import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recognizer/controller/home_provider.dart';
import 'package:food_recognizer/controller/image_classification_provider.dart';

import 'package:food_recognizer/util/helper.dart';
import 'package:food_recognizer/util/widgets_extension.dart';
import 'package:food_recognizer/widget/classification_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Recognizer"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();

    final homeProvider = context.read<HomeProvider>();

    homeProvider.addListener(() {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final message = homeProvider.message;

      if (message != null) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 4,
            children: [
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, value, child) {
                    final imagePath = value.imagePath;
                    return imagePath == null
                        ? const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.image, size: 100),
                          )
                        : Image.file(
                            File(imagePath.toString()),
                            fit: BoxFit.contain,
                          );
                  },
                ),
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Consumer<ImageClassificationViewmodel>(
                    builder: (context, value, child) {
                      final classifications = value.classifications.entries;

                      if (classifications.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // return SizedBox.shrink();

                      return ClassificationItem(
                        item: value.classifications.keys.first,
                        value: toPercentage(value.classifications.values.first),
                      );
                    },
                  ),
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeProvider>().openGallery(),
                        child: const Text("Gallery"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeProvider>().openCamera(),
                        child: const Text("Camera"),
                      ),
                      // ElevatedButton(
                      //   onPressed: () => context
                      //       .read<HomeProvider>()
                      //       .openCustomCamera(context),
                      //   child: const Text(
                      //     "Custom Camera",
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                    ].expanded(),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      final homeProvider = context.read<HomeProvider>();
                      final imageProvider = context
                          .read<ImageClassificationViewmodel>();

                      final image = homeProvider.imageFile;

                      if (image != null) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ResultPage()),
                        // );
                        imageProvider.runClassificationFromImage(image);
                      } else {
                        homeProvider.message = "choose image to analyze !";
                      }
                    },
                    child: Consumer<ImageClassificationViewmodel>(
                      builder: (context, value, child) {
                        if (value.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return const Text("Analyze");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
