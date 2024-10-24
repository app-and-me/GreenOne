import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:greenone/pages/post/PostPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:greenone/api/Post.dart';
import 'package:greenone/controller/CalendarController.dart';
import 'package:greenone/widgets/MessageCard.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<Map<String, dynamic>> postDataFuture;
  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.refreshData();
      setState(() {});
    });
    postDataFuture = _loadPostData();
  }

  Future<Map<String, dynamic>> _loadPostData() async {
    return await PostApi().getPostByUserId(user!.uid);
  }
  
  final CalendarController _controller = Get.put(CalendarController());

  static const _defaultPadding = EdgeInsets.symmetric(horizontal: 19.5);
  static const _headerPadding = EdgeInsets.only(bottom: 28, top: 28);
  static const _chevronPadding = 90.0;

  static const TextStyle _defaultTextStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _headerTextStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _weekdayStyle = TextStyle(
    color: Color(0xFF9F9F9F),
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  DateTime parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) return DateTime.now();
    
    if (createdAt is Map) {
      final seconds = (createdAt['_seconds'] as num).toInt();
      (createdAt['_nanoseconds'] as num).toInt();
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    } else if (createdAt is Timestamp) {
      return createdAt.toDate();
    } else if (createdAt is String) {
      return DateTime.parse(createdAt);
    }
    
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: _defaultPadding,
            child: Column(
              children: [
                Padding(
                  padding: _headerPadding,
                  child: _buildHeader(),
                ),
                Stack(
                  children: [
                    Obx(() => TableCalendar(
                      locale: 'ko_KR',
                      daysOfWeekHeight: 43,
                      firstDay: DateTime.now().subtract(const Duration(days: 365)),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _controller.focusedDay,
                      calendarFormat: _controller.calendarFormat,
                      selectedDayPredicate: (day) => isSameDay(_controller.selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) async {
                        _controller.changeFocusedDay(focusedDay);
                      },
                      onPageChanged: (focusedDay) async {
                        _controller.changeFocusedDay(focusedDay);
                        await _controller.refreshData(); 
                      },
                      calendarBuilders: _createCalendarBuilders(),
                      headerVisible: false,
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: _weekdayStyle,
                        weekendStyle: _weekdayStyle,
                      ),
                    )),
                    Obx(() {
                      if (_controller.isLoading.value) {
                        return Positioned.fill(
                          child: Container(
                            color: Colors.white.withOpacity(0.7),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF01C674),
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.5),
            Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: postDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data!['status'] == 404) {
                        return Container();
                      } else {
                        List<dynamic> posts = snapshot.data!['data'];
                        return Column(
                          children: posts.map<Widget>((post) {
                            return GestureDetector(
                              onTap: () async {
                                String imageUrl = await convertUrl(post['imageUrl']);
                                Get.to(() => PostPage(
                                  title: post['title'], 
                                  imageUrl: imageUrl, 
                                    date: DateFormat('yyyy.MM.dd a hh:mm', 'ko_KR').format(parseCreatedAt(post['createdAt'])), 
                                  content: post['content']));
                              },
                              child: MessageCard(
                              title: post['title'],
                              date: DateFormat('yyyy.MM.dd').format(parseCreatedAt(post['createdAt'])),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  )
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String> convertUrl(String original) async {
    try {
      String url =  await FirebaseStorage.instance.ref().child(original.split('/').last).getDownloadURL();
      return url;
    } catch (error) {
      return 'Error: $error';
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _controller.changeFocusedDay(
              DateTime(_controller.focusedDay.year, _controller.focusedDay.month - 1));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: _chevronPadding),
            child: SvgPicture.asset('assets/icons/arrow-back.svg'),
          ),
        ),
        Obx(() => Text(
          '${_controller.focusedDay.month}월',
          style: _headerTextStyle,
        )),
        GestureDetector(
          onTap: () {
            _controller.changeFocusedDay(
              DateTime(_controller.focusedDay.year, _controller.focusedDay.month + 1));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: _chevronPadding),
            child: SvgPicture.asset('assets/icons/arrow-forward.svg'),
          ),
        ),
      ],
    );
  }

  CalendarBuilders _createCalendarBuilders() {
    return CalendarBuilders(
      defaultBuilder: (context, day, focusedDay) =>
          _buildConnectedCell(context, day, focusedDay),
      todayBuilder: (context, day, focusedDay) =>
          _buildConnectedCell(context, day, focusedDay),
      selectedBuilder: (context, day, focusedDay) =>
          _buildConnectedCell(context, day, focusedDay),
      outsideBuilder: (context, day, focusedDay) =>
          _buildConnectedCell(context, day, focusedDay),
      disabledBuilder: (context, day, focusedDay) =>
          _buildConnectedCell(context, day, focusedDay),
    );
  }

  Widget _buildConnectedCell(BuildContext context, DateTime day, DateTime focusedDay) {
    final bool isWeekend = day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    final bool isSaturday = day.weekday == DateTime.saturday;
    final bool isSunday = day.weekday == DateTime.sunday;
    final bool isDifferentMonth = day.month != _controller.focusedDay.month;
    final Color initialTextColor = !isDifferentMonth 
        ? isWeekend
            ? const Color(0xFFA9BFA7)
            : const Color(0xFFCCCCCC)
        : const Color(0xFFE5EAE8);
          
    final bool isMarked = _controller.isMarkedDay(day);
    final bool isPreviousMarked = _controller.isMarkedDay(day.subtract(const Duration(days: 1)));
    final bool isNextMarked = _controller.isMarkedDay(day.add(const Duration(days: 1)));

    final bool isSingleMarked = isMarked && !isPreviousMarked && !isNextMarked;
    
    final bool isFirstOfMarked = isMarked && !isPreviousMarked && !isWeekend && isNextMarked;
    final bool isLastOfMarked = isMarked && !isNextMarked && !isWeekend && isPreviousMarked;

    final EdgeInsets margin = EdgeInsets.only(
      bottom: 3.0,
      top: 3.0,
      left: (isFirstOfMarked || isSunday || isSingleMarked) ? 3 : 0,
      right: (isLastOfMarked || isSaturday || isSingleMarked) ? 3 : 0
    );

    BorderRadius borderRadius;
    if (isSingleMarked) {
      borderRadius = BorderRadius.circular(30.0);
    } else {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular((isFirstOfMarked || isSunday) ? 30.0 : 0.0),
        bottomLeft: Radius.circular((isFirstOfMarked || isSunday) ? 30.0 : 0.0),
        topRight: Radius.circular((isLastOfMarked || isSaturday) ? 30.0 : 0.0),
        bottomRight: Radius.circular((isLastOfMarked || isSaturday) ? 30.0 : 0.0),
      );
    }

    return Container(
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMarked ? const Color.fromRGBO(1, 198, 116, 0.08) : Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: Text(
        '${day.day}',
        style: _defaultTextStyle.copyWith(
          color: isMarked ? const Color(0xFF01C674) : initialTextColor,
        ),
      ),
    );
  }
}