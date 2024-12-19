import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/model/profile_model.dart';
import 'package:liad/features/presentation/dashboard_screen.dart';
import 'package:liad/features/widgets/profile_widget.dart';
import 'package:liad/features/widgets/widget_dash.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final loveController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  String myName = '';

  UpdateNameModel updateName = UpdateNameModel();
  UpdateNameModel updateConnect = UpdateNameModel();
  ProfileModel profile = ProfileModel();

  @override
  void initState() {
    super.initState();
    getProfile();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgScreen,
      appBar: AppBar(
        backgroundColor: AppColors.bgScreen,
        centerTitle: true,
        title: Text(
          'Profile',
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
        actions: [
          InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () async {
              await Clipboard.setData(ClipboardData(
                text: profile.id.toString(),
              ));
              // ignore: use_build_context_synchronously
              showSnackbars(context, 'Berhasil salin ID kamu.', 3);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SvgPicture.asset(
                MediaRes.path,
                fit: BoxFit.contain,
                width: 25,
                // ignore: deprecated_member_use
                color: AppColors.bgBlack,
              ),
            ),
          )
        ],
      ),
      body: isLoading.value
          ? const UIDialogLoading(text: StringResources.loading)
          : bodyData(size, context),
    );
  }

  SafeArea bodyData(Size size, BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Center(
            child: ClipOval(
              child: Image.asset(
                MediaRes.alarmBackground,
                width: size.width * 0.25,
                height: size.width * 0.25,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                myName,
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  changeName(
                    context,
                    size,
                    nameController,
                    () {
                      Navigator.pop(context);
                      isLoading.value = true;
                      updateNames();
                    },
                  );
                },
                child: SvgPicture.asset(
                  MediaRes.pencils,
                  fit: BoxFit.contain,
                  width: 20,
                  // ignore: deprecated_member_use
                  color: AppColors.bgBlack,
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.05),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              connectPartner(
                context,
                size,
                loveController,
                () {
                  Navigator.pop(context);
                  isLoading.value = true;
                  updateConnects();
                },
              );
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.primary,
                ),
                child: Text(
                  connect(profile.connectName.toString()),
                  style: whiteTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String connect(String name) {
    String name = 'Connect Love';
    if (profile.connectName != '' && profile.connectName != null) {
      name = ' Your Connect ${profile.connectName}';
    }
    return name;
  }

  void getData() async {
    myName = await getName();
    setState(() {});
  }

  Future<void> updateNames() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    updateName = await provider.updateNames(profile.id!, nameController.text);
    if (!updateName.isError) {
      nameController.text = '';
    }
    isLoading.value = false;
    getData();
  }

  void getProfile() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    profile = await provider.getProfile();
    setState(() {});
  }

  Future<void> updateConnects() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    updateConnect =
        await provider.updateConnect(profile.id!, loveController.text);
    if (!updateConnect.isError) {
      loveController.text = '';
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Gagal Connect', false);
    }
    isLoading.value = false;
    getProfile();
  }
}
