import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading_page.dart';
import 'package:liad/core/utils/snackbar_extension.dart';
import 'package:liad/features/data/notes/notes_provider.dart';
import 'package:liad/features/model/notes_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:liad/features/presentation/notes/notes_screen.dart';
import 'package:liad/features/widgets/images_preview.dart';
import 'package:provider/provider.dart';

class ViewNotes extends StatefulWidget {
  final String id;
  const ViewNotes({super.key, required this.id});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  DateTime dates = DateTime.now();
  String finish = 'Belum Selesai';
  String idNote = '';
  bool isFinish = false;
  bool isSubmit = false;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  ResponseNotes response = ResponseNotes();
  NotesModel notes = NotesModel();
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading.value
        ? const UIDialogLoading(text: StringResources.loading)
        : Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
              backgroundColor: AppColors.bgColor,
              centerTitle: true,
              title: Text(
                'Notes',
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              leading: InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotesScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SvgPicture.asset(
                    MediaRes.back,
                    // ignore: deprecated_member_use
                    color: AppColors.bgBlack,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            body: _bodyData(context, size),
            floatingActionButton: isSubmit
                ? InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (isSubmit) {
                        isLoading.value = true;
                        _save();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Update',
                          style: whiteTextstyle.copyWith(
                            fontSize: 22,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: titleFocus,
                autofocus: true,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(contentFocus);
                },
                onChanged: (value) {
                  // markTitleAsDirty(value);
                },
                textInputAction: TextInputAction.next,
                style: blackTextstyle.copyWith(
                  fontSize: 25,
                  fontWeight: bold,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter a title',
                  hintStyle: greyTextstyle.copyWith(
                    fontSize: 25,
                    fontWeight: bold,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(dates),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: greyTextstyle.copyWith(
                      fontSize: 12,
                      fontWeight: light,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        MediaRes.checklistNote,
                        fit: BoxFit.cover,
                        // ignore: deprecated_member_use
                        color: isFinish ? AppColors.primary : Colors.grey,
                        width: 21,
                        height: 21,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        finish,
                        maxLines: 1,
                        style: greyTextstyle.copyWith(
                          fontSize: 12,
                          fontWeight: light,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: contentFocus,
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    // markContentAsDirty(value);
                  },
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: light,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Start typing...',
                    hintStyle: greyTextstyle.copyWith(
                      fontSize: 15,
                      fontWeight: light,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            imagePreview(size),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }

  void _save() async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    NotesModel push = NotesModel(
      id: idNote,
      title: titleController.text,
      content: contentController.text,
      isChecklist: 0,
      checklitsOn: DateTime.now(),
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
    response = await provider.updateNotes(push);
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const NotesScreen(),
            ),
          );
        }, // bottom close
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        response.message,
        onNavigate: () {}, // bottom close
      );
    }
  }

  String formatDate(DateTime dateTime) {
    // Setel locale ke 'id_ID' untuk bahasa Indonesia
    // Intl.defaultLocale = 'id_ID';
    // Format tanggal sesuai yang diinginkan
    String formattedDate =
        DateFormat('EEEE, MMMM dd, yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  void initData() async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    notes = await provider.getNotesId(widget.id);
    if (notes.id != '') {
      idNote = notes.id ?? '';
      titleController.text = notes.title ?? '';
      contentController.text = notes.content ?? '';
      images = notes.images ?? [];
      dates = notes.createdOn!;
      if (notes.checklist!) {
        finish = 'Selesai';
        isFinish = true;
      }
      isLoading.value = false;
    }
    setState(() {});
  }

  Widget imagePreview(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.map((image) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ImagePreviewFullScreen(imageBase64: image),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                base64Decode(image),
                width: size.width * 0.15,
                height: size.width * 0.15,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
