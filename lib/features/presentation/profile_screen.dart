import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading_page.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/model/prays_model.dart';
import 'package:liad/features/model/profile_model.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/model/weather_model.dart';
import 'package:liad/features/presentation/dashboard_screen.dart';
import 'package:liad/features/presentation/report_prays.dart';
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
  final weatherController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmFajr = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmDhuhr = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmAsr = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmMaghrib = ValueNotifier(false);
  final ValueNotifier<bool> isAlarmIsha = ValueNotifier(false);
  String myName = '';
  String selectedDates = '';
  bool isData = false;
  bool isDtWWork = false;
  bool isDtWHome = false;
  bool isPeriodeMens = false;
  bool isPaysData = false;
  DateTime? selectedDate;

  UpdateNameModel updateName = UpdateNameModel();
  UpdateNameModel updateConnect = UpdateNameModel();
  UpdateNameModel updateWeater = UpdateNameModel();
  UpdateNameModel updateAlarm = UpdateNameModel();
  ScheduleSholatModel schadulePray = ScheduleSholatModel();
  ProfileModel profile = ProfileModel();
  PraysModel prays = PraysModel();
  Cuaca homeWeater = Cuaca();
  Cuaca workWeater = Cuaca();

  @override
  void initState() {
    super.initState();
    getProfile();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading.value
        ? const UIDialogLoading(text: StringResources.loading)
        : Scaffold(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportPrays(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      MediaRes.calenderDays,
                      fit: BoxFit.contain,
                      width: 25,
                      // ignore: deprecated_member_use
                      color: AppColors.bgBlack,
                    ),
                  ),
                ),
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    selectedDates = await selectDate(context, selectedDate);
                    if (selectedDates != '') {
                      setDataAlarm(selectedDates, size);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      MediaRes.alarm,
                      fit: BoxFit.contain,
                      width: 25,
                      // ignore: deprecated_member_use
                      color: AppColors.bgBlack,
                    ),
                  ),
                ),
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
            body: bodyData(size, context),
          );
  }

  SafeArea bodyData(Size size, BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
            SizedBox(height: size.height * 0.03),
            _viewWeather(context, size),
            isData
                ? Column(
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Text(
                        'Your Connect Pray',
                        style: blackTextstyle.copyWith(
                          fontSize: 15,
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      !isPeriodeMens
                          ? isPaysData
                              ? _prays(size)
                              : noData('Tidak ada data Sholat')
                          : noData('Anda sedang libur sholat'),
                    ],
                  )
                : noData('Tidak ada data'),
          ],
        ),
      ),
    );
  }

  Padding noData(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        title,
        style: greyTextstyle.copyWith(
          fontSize: 12,
          fontWeight: bold,
        ),
      ),
    );
  }

  Center _viewWeather(BuildContext context, Size size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                inputWeather(
                  context,
                  size,
                  weatherController,
                  () {
                    updateWeather(1);
                  },
                );
              },
              child: isDtWWork && workWeater.image != null
                  ? viewDtWeather(size, workWeater, 'Tempat Kerja')
                  : viewWeather(size, 'Tempat Kerja'),
            ),
            SizedBox(width: size.width * 0.1),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                inputWeather(
                  context,
                  size,
                  weatherController,
                  () {
                    updateWeather(2);
                  },
                );
              },
              child: isDtWHome && homeWeater.image != null
                  ? viewDtWeather(size, homeWeater, 'Rumah')
                  : viewWeather(size, 'Rumah'),
            ),
          ],
        ),
      ),
    );
  }

  Column _prays(Size size) {
    return Column(
      children: [
        prays.isFajr!
            ? listPrays(size, 'Fajr', prays.onFajr, prays.finishFajr)
            : const SizedBox.shrink(),
        prays.isDhuhr!
            ? listPrays(size, 'Dhuhr', prays.onDhuhr, prays.finishDhuhr)
            : const SizedBox.shrink(),
        prays.isAsr!
            ? listPrays(size, 'Asr', prays.onAsr, prays.finishAsr)
            : const SizedBox.shrink(),
        prays.isMaghrib!
            ? listPrays(size, 'Maghrib', prays.onMaghrib, prays.finishMaghrib)
            : const SizedBox.shrink(),
        prays.isIsya!
            ? listPrays(size, 'Isha', prays.onIsya, prays.finishIsya)
            : const SizedBox.shrink(),
      ],
    );
  }

  String connect(String name) {
    String names = 'Connect Love';
    if (name != '') {
      names = 'Your Connect $name';
    }
    return names;
  }

  void getData() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    myName = await getName();
    prays = await provider.loadPrays();
    String work = await getTypeWeather(1);
    String home = await getTypeWeather(2);
    isPeriodeMens = await getPeriodeMens();
    if (prays.id != '') {
      isData = true;
    }
    if (work.isNotEmpty) {
      isDtWWork = true;
      workWeater = await provider.loadWeater(1);
    }
    if (home.isNotEmpty) {
      isDtWHome = true;
      homeWeater = await provider.loadWeater(2);
    }
    if (prays.isFajr! || prays.isDhuhr! || prays.isAsr! || prays.isMaghrib! || prays.isIsya!) {
      isPaysData = true;
    }
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
    if (profile.name != '') {
      myName = profile.name.toString();
    }
    setState(() {});
  }

  Future<void> updateConnects() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    updateConnect =
        await provider.updateConnect(profile.id!, loveController.text);
    if (!updateConnect.isError) {
      loveController.text = '';
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Connect Sukses', true);
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Gagal Connect', false);
    }
    isLoading.value = false;
    getProfile();
  }

  Future<void> updateWeather(int type) async {
    isLoading.value = true;
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    updateWeater =
        await provider.updateWeather(type, profile.id!, weatherController.text);
    if (!updateWeater.isError) {
      weatherController.text = '';
      workWeater = await provider.loadWeater(type);
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Gagal Update', false);
    }
    isLoading.value = false;
    getData();
  }

  void setDataAlarm(String selectedDates, Size size) async {
    isLoading.value = true;
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    schadulePray = await provider.loadPrayerSchedule(selectedDates);
    if (!schadulePray.isError) {
      await initAlarmProfile(schadulePray, selectedDates);
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Berhasil Menambahkan alarm', true);
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Gagal Update', false);
    }
    isLoading.value = false;
    setState(() {});
  }
}
