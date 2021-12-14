class TimesController {
  final _times = {
    "09:00": 0,
    "09:30": 1,
    "10:00": 2,
    "10:30": 3,
    "11:00": 4,
    "11:30": 5,
    "12:00": 6,
    "12:30": 7,
    "13:00": 8,
    "13:30": 9,
    "14:00": 10,
    "14:30": 11,
    "15:00": 12,
    "15:30": 13,
    "16:00": 14,
    "16:30": 15,
    "17:00": 16,
    "17:30": 17,
    "18:00": 18,
    "18:30": 19,
    "19:00": 20,
    "19:30": 21,
    "20:00": 22,
    "20:30": 23,
    "21:00": 24,
    "21:30": 25,
    "22:00": 26,
  };

  List<String> sortTimes(List<String> times) {
    List<String> sortedTimes = [];
    List<int> priorities = [];
    for (var time in times) {
      priorities.add(_times[time]!);
    }
    priorities.sort();
    for (var priority in priorities) {
      sortedTimes.add(getTimeByValue(priority));
    }
    return sortedTimes;
  }

  bool checkTimeInterval(String time, String from, String to) {
    int timePriority = _times[time]!;
    int fromPriority = _times[from]!-1;
    int toPriority = _times[to]!;
    if (timePriority >= fromPriority && timePriority < toPriority) {
      return true;
    } else {
      return false;
    }
  }

  String getTimeByValue(int timeValue) {
    String time = "";
    _times.forEach((key, value) {
      if (value == timeValue) {
        time = key;
      }
    });
    return time;
  }

  Map<String, dynamic> setTimesStatus(
      String from, int duration, String status) {
    Map<String, dynamic> timesStatus = {};
    int fromPriority = _times[from]!;
    if (duration == 1) {
      timesStatus.putIfAbsent(getTimeByValue(fromPriority), () => status);
      if (fromPriority != 0) {
        timesStatus.putIfAbsent(getTimeByValue(fromPriority - 1), () => status);
      }
      if (fromPriority != _times.length) {
        timesStatus.putIfAbsent(getTimeByValue(fromPriority + 1), () => status);
      }
    }
    if (duration == 2) {
      timesStatus.putIfAbsent(getTimeByValue(fromPriority), () => status);
      if (fromPriority != 0) {
        timesStatus.putIfAbsent(getTimeByValue(fromPriority - 1), () => status);
      }
      if (fromPriority != _times.length - 3) {
        timesStatus.putIfAbsent(getTimeByValue(fromPriority + 1), () => status);
        timesStatus.putIfAbsent(getTimeByValue(fromPriority + 2), () => status);
        timesStatus.putIfAbsent(getTimeByValue(fromPriority + 3), () => status);
      }
    }
    return timesStatus;
  }

  bool checkTimesStatusForTwoHours(
      Map<dynamic, dynamic> schedule, String from, String status) {
    int fromPriority = _times[from]!;
    if (fromPriority >= 21) {
      return false;
    } else if (schedule[getTimeByValue(fromPriority)] == 'открыто' &&
        schedule[getTimeByValue(fromPriority + 2)] == 'открыто'
    ) {
      return true;
    } else {
      return false;
    }
  }

  get times => _times;
}
