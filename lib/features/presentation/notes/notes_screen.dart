import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading_page.dart';
import 'package:liad/core/utils/snackbar_extension.dart';
import 'package:liad/features/data/notes/notes_provider.dart';
import 'package:liad/features/model/notes_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:liad/features/presentation/dashboard_screen.dart';
import 'package:liad/features/presentation/notes/create_notes.dart';
import 'package:liad/features/presentation/notes/view_notes.dart';
import 'package:liad/features/widgets/list_notes.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  final searchController = TextEditingController();
  List<NotesModel> allNotes = [];
  List<NotesModel> viewNotes = [];
  ResponseNotes response = ResponseNotes();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading.value
        ? const UIDialogLoading(text: StringResources.loading)
        : Scaffold(
            backgroundColor: AppColors.bgGreySecond,
            appBar: AppBar(
              backgroundColor: AppColors.bgGreySecond,
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
                      builder: (context) => const DashboardScreen(),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateNotes(),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              child: SvgPicture.asset(
                MediaRes.editNotes,
                fit: BoxFit.contain,
                width: 30,
                // ignore: deprecated_member_use
                color: AppColors.bgColor,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                cursorColor: AppColors.bgBlack,
                decoration: InputDecoration(
                  hintText: 'Search Note...',
                  hintStyle: greyTextstyle.copyWith(
                    fontSize: 16,
                    fontWeight: light,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.bgGrey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: AppColors.bgColor,
                  // Menambahkan ikon di kiri
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      MediaRes.searchNotes,
                      // ignore: deprecated_member_use
                      color: AppColors.bgGrey,
                      width: 20, // Sesuaikan ukuran ikon
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        searchController.text = '';
                        search('');
                      },
                      child: SvgPicture.asset(
                        MediaRes.close,
                        // ignore: deprecated_member_use
                        color: AppColors.bgGrey,
                        width: 20, // Sesuaikan ukuran ikon
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 14.0),
                ),
                onChanged: (value) {
                  search(value);
                },
                maxLines: 1,
                style: blackTextstyle.copyWith(
                  fontSize: 16,
                  fontWeight: light,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Wrap(
                spacing: 10, // Jarak horizontal antar item
                runSpacing: 10, // Jarak vertikal antar baris
                children: viewNotes.map((e) {
                  final ValueNotifier<bool> check = ValueNotifier(e.checklist!);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewNotes(id: e.id.toString()),
                        ),
                      );
                    },
                    child: ListNotes(
                      size: size,
                      dt: e,
                      checkBox: check,
                      onTapCheckBox: () {
                        isLoading.value = true;
                        updateChecklist(e.id!, check.value);
                      },
                      onTapDelete: () {
                        confirmDelete(context, size, e.title.toString(), () {
                          isLoading.value = true;
                          _deleteId(e.id.toString());
                        });
                      },
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadData() async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    allNotes = await provider.getNotes();
    viewNotes = allNotes;
    isLoading.value = false;
    setState(() {});
  }

  void _deleteId(String id) async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    response = await provider.deleteNotes(id);
    isLoading.value = false;
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {
          _loadData();
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

  void search(String value) {
    final lowerCaseQuery = value.toLowerCase();
    setState(() {
      viewNotes = allNotes.where((e) {
        final title = e.title!.toLowerCase();
        bool matchesQuery = title.contains(lowerCaseQuery);
        return matchesQuery;
      }).toList();
    });
  }

  void updateChecklist(String id, bool check) async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    response = await provider.updateChecklist(id, check);
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {}, // bottom close
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        response.message,
        onNavigate: () {}, // bottom close
      );
    }
    isLoading.value = false;
  }

  Future<dynamic> confirmDelete(
    BuildContext context,
    Size size,
    String title,
    VoidCallback onTap,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgScreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: size.height * 0.23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Delete Notes?',
                  style: blackTextstyle.copyWith(
                    fontSize: 20,
                    fontWeight: bold,
                  ),
                ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: size.width * 0.45,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: Text(
                            'Batal',
                            style: whiteTextstyle.copyWith(
                              fontSize: 19,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                        onTap();
                      },
                      child: Container(
                        width: size.width * 0.45,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: Text(
                            'Iya',
                            style: whiteTextstyle.copyWith(
                              fontSize: 19,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
