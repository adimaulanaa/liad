import 'package:flutter/material.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/loading_page.dart';
// import 'package:liad/core/utils/loading.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/model/report_prays_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ReportPrays extends StatefulWidget {
  const ReportPrays({super.key});

  @override
  State<ReportPrays> createState() => _ReportPraysState();
}

class _ReportPraysState extends State<ReportPrays> {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  List<ReportPraysModel> events = [];

  @override
  void initState() {
    super.initState();
    init();
    _selectedDate = _focusedDay;
  }

  List<ReportPraysModel> getEventsForDay(DateTime day) {
    return events.where((event) => isSameDay(event.timestamp, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading.value
        ? const UIDialogLoading(text: StringResources.loading)
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Report Your Prays'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime(2022, 1, 1),
                    lastDay: DateTime(2065, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDate, selectedDay)) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        final dayEvents = getEventsForDay(day);
                        if (dayEvents.isNotEmpty) {
                          return blockColorsDate(day, AppColors.primary);
                        }
                        return null;
                      },
                    ),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronIcon: SizedBox.shrink(),
                      rightChevronIcon: SizedBox.shrink(),
                    ),
                    availableGestures: AvailableGestures.none,
                  ),
                  if (_selectedDate != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...getEventsForDay(_selectedDate!).map((e) {
                          return Container(
                            width: size.width,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name.toString(),
                                  style: blackTextstyle.copyWith(
                                    fontSize: 20,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Jadwal : ',
                                          style: blackTextstyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: medium,
                                          ),
                                        ),
                                        Text(
                                          e.ontTime.toString(),
                                          style: blackTextstyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: size.width * 0.1),
                                    Row(
                                      children: [
                                        Text(
                                          'Sholat : ',
                                          style: blackTextstyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: medium,
                                          ),
                                        ),
                                        Text(
                                          e.finishTime.toString(),
                                          style: blackTextstyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          );
  }

  void init() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    events = await provider.loadListPrays();
    isLoading.value = false;
    setState(() {});
  }

  Container? blockColorsDate(DateTime day, Color colors) {
    if (isSameDay(day, DateTime.now())) {
      // Jika hari ini, tidak menampilkan kotak
      return null;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Border radius kotak
        border: Border.all(
          color: isSameDay(_selectedDate, day) ? Colors.transparent : colors,
          width: 2,
        ),
      ),
    );
  }
}
