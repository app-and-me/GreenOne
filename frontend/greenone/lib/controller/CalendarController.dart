import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenone/api/PostDate.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final User? _user = FirebaseAuth.instance.currentUser;

  var markedDays = <DateTime>{}.obs;
  var isLoading = true.obs;
  final _focusedDay = DateTime.now().obs;
  final _selectedDay = Rxn<DateTime>();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  Set<DateTime>? _cachedMarkedDays;
  String? _cachedUserId;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_cachedMarkedDays != null && _cachedUserId == _user?.uid) {
      markedDays.value = _cachedMarkedDays!;
      isLoading.value = false;
      return;
    }

    await _loadMarkedDays();
  }

  Future<void> _loadMarkedDays() async {
    try {
      final userData = await PostDateApi().getUserById(_user!.uid);
      if (userData['status'] == 200 && userData['data'] != null) {
        final newMarkedDays = (userData['data'] as Map<String, dynamic>)
            .entries
            .where((entry) => entry.value == true)
            .map((entry) => DateTime.parse(entry.key))
            .toSet();

        _cachedMarkedDays = newMarkedDays;
        _cachedUserId = _user.uid;

        markedDays.value = newMarkedDays;
      }
    } catch (e) {
      print('Error loading marked days: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    _cachedMarkedDays = null;
    _cachedUserId = null;
    await _loadMarkedDays();
  }

  bool isMarkedDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return markedDays.contains(dateKey);
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay.value = selectedDay;
    _focusedDay.value = focusedDay;
  }

  void changeFocusedDay(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
  }

  DateTime get focusedDay => _focusedDay.value;
  DateTime? get selectedDay => _selectedDay.value;
  CalendarFormat get calendarFormat => _calendarFormat;
}
