import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/events.dart';
import '../models/event.dart';

class EventCalendarPage extends StatefulWidget {
  const EventCalendarPage({super.key});

  @override
  State<EventCalendarPage> createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<TourismEvent> _getEventsForDay(DateTime day) {
    return events.where((e) =>
      e.date.year == day.year && e.date.month == day.month && e.date.day == day.day).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay == null ? const <TourismEvent>[] : _getEventsForDay(_selectedDay!);

    return Scaffold(
      appBar: AppBar(title: const Text('Tourism Events')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: selectedEvents.length,
              itemBuilder: (_, i) {
                final e = selectedEvents[i];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text('${e.location} • ${e.description}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
