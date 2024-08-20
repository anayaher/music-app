import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';

import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<UploadSongPage> {
  final artistController = TextEditingController();
  final songNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  final formKey = GlobalKey<FormState>();
  File? selectedImage;
  File? selectedAudio;

  void selectAudio() async {
    final pikcedAudio = await pickAudio();
    if (pikcedAudio != null) {
      setState(() {
        selectedAudio = pikcedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    songNameController.dispose();
    artistController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      selectedAudio != null &&
                      selectedImage != null) {
                    ref.read(homeViewmodelProvider.notifier).uploadSongs(
                        selectedAudio: selectedAudio!,
                        selectedImage: selectedImage!,
                        artistName: artistController.text,
                        songName: songNameController.text,
                        selectedColor: selectedColor);
                  }
                },
                icon: const Icon(Icons.check))
          ],
          title: const Text("Upload songs"),
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: selectImage,
                          child: selectedImage != null
                              ? SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : DottedBorder(
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: const [10, 6],
                                  color: Pallete.borderColor,
                                  child: const SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Select The thumbnail for your song",
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        selectedAudio != null
                            ? AudioWave(path: selectedAudio!.path)
                            : CustomField(
                                onTap: selectAudio,
                                readOnly: true,
                                hintText: "Pick Song",
                                controller: null,
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomField(
                          hintText: "Artist",
                          controller: artistController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomField(
                          hintText: "Song name",
                          controller: songNameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ColorPicker(
                          pickersEnabled: const {ColorPickerType.wheel: true},
                          color: selectedColor,
                          onColorChanged: (value) {
                            setState(() {
                              selectedColor = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
