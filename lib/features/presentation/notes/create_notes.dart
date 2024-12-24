import 'package:flutter/material.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading.dart';
import 'package:liad/core/utils/snackbar_extension.dart';
import 'package:liad/features/data/notes/notes_provider.dart';
import 'package:liad/features/model/notes_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:liad/features/presentation/notes/notes_screen.dart';
import 'package:provider/provider.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({super.key});

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  ResponseNotes response = ResponseNotes();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading.value
          ? const UIDialogLoading(text: StringResources.loading)
          : _bodyData(context, size),
      floatingActionButton: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {
          if (titleController.text.isNotEmpty &&
              contentController.text.isNotEmpty) {
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
              'Simpan',
              style: whiteTextstyle.copyWith(
                fontSize: 22,
                fontWeight: medium,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
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
          ],
        ),
      ),
    );
  }

  void _save() async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    NotesModel push = NotesModel(
      title: titleController.text,
      content: contentController.text,
      isChecklist: 0,
      checklitsOn: DateTime.now(),
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
    response = await provider.createNotes(push);
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {
          Navigator.pushReplacement(
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
}
