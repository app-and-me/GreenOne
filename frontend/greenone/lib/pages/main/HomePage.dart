import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenone/api/ChatGpt.dart';
import 'package:greenone/api/Pet.dart';
import 'package:greenone/api/PostDate.dart';
import 'package:greenone/api/User.dart';
import 'package:greenone/pages/notification/NotificationPage.dart';
import 'package:greenone/pages/post/CreatePostPage.dart';
import 'package:greenone/widgets/MessageCard.dart';
import 'package:greenone/widgets/MyAppBar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  
  late List<DateTime> _weekDates;
  late DateTime _selectedDate;
  late Future<Map<String, dynamic>> _petDataFuture;
  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<Object> _answerFuture;
  late Future<Map<String, dynamic>> _postDateFuture;
  final User? _user = FirebaseAuth.instance.currentUser;
  int age = 0;
  int percent = 0;
  String cachedAnswer = "";
  bool isPosted = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeWeekDates();
    _userDataFuture = _loadUserData();
    _petDataFuture = _loadPetData().then((data) {
      age = data['data']['age'];
      percent = data['data']['percent'];
      return data;
    });
    _postDateFuture = _loadPostDate().then((data) {
      isPosted = (data['data'][DateFormat('yyyy-MM-dd').format(DateTime.now())] ?? false);
      return data;
    });
    _answerFuture = _initializeAnswer();
  }

  void _initializeWeekDates() {
    final startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday % 7)
    );
    _weekDates = List.generate(7, (index) => 
      startOfWeek.add(Duration(days: index))
    );
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    return await UserApi().getUserById(_user!.uid);
  }

  Future<Map<String, dynamic>> _loadPostDate() async {
    return await PostDateApi().getUserById(_user!.uid);
  }

  Future<Map<String, dynamic>> _loadPetData() async {
    return await PetApi().getPetById(_user!.uid);
  }

  Future<Object> _initializeAnswer() async {
    if (isPosted) {
      return cachedAnswer;
    } else {
      final response = await ChatGptApi().createMessage();
      cachedAnswer = response as String;
      return response;
    }
  }

  void _onDateSelected(DateTime date) {
    if (mounted) {
      setState(() => _selectedDate = date);
    }
  }

  void _navigateToNotification() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationPage()),
      );
    }
  }

  String _getDayName(int weekday) => _days[weekday % 7];

  bool _isSelectedDate(DateTime date) => 
    date.day == _selectedDate.day &&
    date.month == _selectedDate.month &&
    date.year == _selectedDate.year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(onNotificationPressed: _navigateToNotification),
      ),
      backgroundColor: const Color(0xFFF8FAED),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildWeekCalendar(),
          const SizedBox(height: 28.94),
          _buildUmbrageSection(),
          const SizedBox(height: 10.55),
          _buildPetSection(),
          const SizedBox(height: 62),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => CreatePostPage(taskTitle: cachedAnswer));
                },
                child: _buildMessageCard()
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return FutureBuilder<Object>(
      future: _answerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01C674)),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading answer',
              style: GoogleFonts.roboto(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final answer = (snapshot.data! as String).split(':')[2].trim();
          return GestureDetector(
            onTap: () {
              !isPosted ? Get.to(() => CreatePostPage(taskTitle: answer)) : null;
            },
            child: MessageCard(
              title: answer,
              date: DateFormat("yyyy.MM.dd").format(DateTime.now()),
              iconColor: isPosted ? const Color(0xFFC8D0C7) : null,
              titleColor: isPosted ? const Color(0xFFC7C7C7) : null,
            ),
          );
        } else {
          return Center(
            child: Text(
              'No answer available',
              style: GoogleFonts.roboto(color: Colors.grey),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01C674)),
          ),
          SizedBox(height: 16),
          Text('Loading pet data...'),
        ],
      ),
    );
  }

  Widget _buildPetSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _petDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: _buildLoadingIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Expanded(
            child: Center(
              child: Text(
                'Error loading pet data',
                style: GoogleFonts.roboto(color: Colors.red),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: Text(
                'No pet data available',
                style: GoogleFonts.roboto(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: [
            Center(
              child: Image.asset(
                'assets/characters/$age.png',
                width: 180,
                height: 180,
              ),
            ),
            const SizedBox(height: 20),
            _buildLevelProgressSection(),
          ],
        );
      },
    );
  }

  Widget _buildWeekCalendar() {
    return SizedBox(
      width: 362,
      height: 83,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var date in _weekDates) ...[
            _buildDayColumn(
              _getDayName(date.weekday), 
              date,
              isSelected: _isSelectedDate(date)
            ),
            if (_weekDates.indexOf(date) < _weekDates.length - 1)
              const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }

  Widget _buildUmbrageSection() {
    return Padding(
      padding: const EdgeInsets.only(right: 31.33),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(
            'assets/icons/leaf.svg',
            width: 29,
            height: 29,
          ),
          const SizedBox(width: 4),
          FutureBuilder<Map<String, dynamic>>(
            future: _userDataFuture,
            builder: _buildUmbrageWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildUmbrageWidget(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF898A8D)),
        ),
      );
    }

    if (snapshot.hasError) {
      return _buildText("Error", color: Colors.red);
    }

    if (!snapshot.hasData) {
      return _buildText("N/A");
    }

    final int umbrage = snapshot.data!['data']['umbrage'];
    return _buildText(umbrage.toString());
  }

  Widget _buildText(String text, {Color? color}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        color: color ?? const Color(0xFF898A8D),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildLevelProgressSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LV.$age',
            style: GoogleFonts.roboto(
              color: const Color(0xFFA9BFA6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.3),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    const totalWidth = 252.2;
    final progressWidth = (totalWidth * percent / 100).clamp(0.0, totalWidth);

    return Container(
      width: 264.74,
      height: 21.88,
      decoration: ShapeDecoration(
        color: const Color(0xFFF1F2E7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.94),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 6.27,
            right: 6.27,
            top: 7.46,
            child: Container(
              height: 6.96,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.94),
                ),
              ),
            ),
          ),
          Positioned(
            left: 7.56,
            top: 7.46,
            child: Container(
              width: progressWidth,
              height: 6.96,
              decoration: ShapeDecoration(
                color: const Color(0xFF01C674),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.94),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String day, DateTime date, {bool isSelected = false}) {
    return SizedBox(
      width: 45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: const Color(0xFFB9BBB9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildDateButton(date, isSelected),
        ],
      ),
    );
  }

  Widget _buildDateButton(DateTime date, bool isSelected) {
    return GestureDetector(
      onTap: () => _onDateSelected(date),
      child: Container(
        width: double.infinity,
        height: 55,
        padding: const EdgeInsets.all(2),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF333333) : const Color(0xFFEEF2DC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(46.12),
          ),
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: GoogleFonts.roboto(
              color: isSelected ? Colors.white : const Color(0xFF898A8D),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}