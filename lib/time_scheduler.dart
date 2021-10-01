import 'dart:async';

import 'package:flutter/material.dart';

class TimeScheduler extends StatefulWidget {
  @override
  _TimeSchedulerState createState() => _TimeSchedulerState();
}

class _TimeSchedulerState extends State<TimeScheduler> {
  Map<int, ModelTime> _selectedDates = {0: ModelTime()};

  StreamController<bool> _dateController = StreamController.broadcast();

  @override
  void dispose() {
    _dateController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getHeader(),
          Expanded(
            child: StreamBuilder(
              stream: _dateController.stream,
              builder: (ctx, snapshot) => ListView.builder(
                itemBuilder: (ctx, i) => _getRow(i),
                itemCount: _selectedDates.length,
              ),
            ),
          ),
          ElevatedButton(onPressed: _addNew, child: Text('Add'))
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Start',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'End',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _getTimePicker(int index, {bool isFirst = true}) {
    ModelTime modelTime = _selectedDates[index];

    TimeOfDay timeOfDay;
    String lable = 'Select First Time';
    if (!isFirst) {
      lable = "Select Second Time";
    }

    if (modelTime != null) {
      timeOfDay = modelTime.firstTime;
      if (!isFirst) {
        timeOfDay = modelTime.secondTime;
      }
    }

    return Container(
      height: 50,
      width: 150,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
      child: timeOfDay != null
          ? Center(child: Text(timeOfDay.format(context)))
          : TextButton(
              child: Text(lable),
              onPressed: () => _selectTime(index, isFirst),
            ),
    );
  }

  Widget _getRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _getTimePicker(index),
          _getTimePicker(index, isFirst: false),
        ],
      ),
    );
  }

  Future<void> _selectTime(int index, bool isFirst) async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select time.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (index != 0) {
      ModelTime modelTime = _selectedDates[index - 1];

      TimeOfDay secondTime = modelTime.secondTime;
      DateTime timeNow = DateTime.now();

      DateTime dateTime2 = DateTime(timeNow.year, timeNow.month, timeNow.day,
          secondTime.hour, secondTime.minute);

      DateTime newDateTime = DateTime(timeNow.year, timeNow.month, timeNow.day,
          newTime.hour, newTime.minute);

      if (!newDateTime.isAfter(dateTime2)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This time slot is booked. Picked another'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    if (isFirst) {
      _selectedDates.update(index, (value) => ModelTime(firstTime: newTime));
    } else {
      _selectedDates.update(
          index,
          (value) =>
              ModelTime(firstTime: value.firstTime, secondTime: newTime));
    }
    _dateController.add(true);
  }

  void _addNew() {
    int key = _selectedDates.length;
    ModelTime modelTime = _selectedDates[key - 1];
    if (modelTime == null ||
        modelTime.firstTime == null ||
        modelTime.secondTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select above unselected time.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _selectedDates[key] = ModelTime();
    _dateController.add(true);
  }
}

class ModelTime {
  TimeOfDay firstTime;
  TimeOfDay secondTime;

  ModelTime({this.firstTime, this.secondTime});
}
