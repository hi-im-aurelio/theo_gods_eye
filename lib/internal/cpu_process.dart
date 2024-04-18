// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:convert';

Map<String, dynamic> get_system_info() {
  var result = Process.runSync('top', ['-bn1']);
  var lines = LineSplitter.split(result.stdout);

  var details = <String, dynamic>{};

  for (var line in lines) {
    if (line.startsWith('top')) {
      var uptimeMatch = RegExp(r'up\s+([^,]+)').firstMatch(line);
      var loadAverageMatch = RegExp(r'load average:\s+([^,]+)').firstMatch(line);
      var userMatch = RegExp(r'(\d+) user').firstMatch(line);

      if (uptimeMatch != null && loadAverageMatch != null) {
        details['uptime'] = uptimeMatch.group(1);
        details['load_average'] = loadAverageMatch.group(1);
      }

      if (userMatch != null) {
        details['users'] = int.parse(userMatch.group(1)!);
      }
    } else if (line.startsWith('Tasks:')) {
      var tasksMatch = RegExp(
              r'Tasks: +(\d+) +total, +(\d+) +running, +(\d+) +sleeping, +(\d+) +stopped, +(\d+) +zombie')
          .firstMatch(line);
      if (tasksMatch != null) {
        details['tasks'] = {
          'total': tasksMatch.group(1),
          'running': tasksMatch.group(2),
          'sleeping': tasksMatch.group(3),
          'stopped': tasksMatch.group(4),
          'zombie': tasksMatch.group(5),
        };
      }
    } else if (line.startsWith('%Cpu(s):')) {
      var cpuMatch = RegExp(
              r'%Cpu\(s\):\s+([\d.]+)\s+us,\s+([\d.]+)\s+sy,\s+([\d.]+)\s+ni,\s+([\d.]+)\s+id,\s+([\d.]+)\s+wa,\s+([\d.]+)\s+hi,\s+([\d.]+)\s+si,\s+([\d.]+)\s+st')
          .firstMatch(line);
      if (cpuMatch != null) {
        details['cpu'] = {
          'us': cpuMatch.group(1),
          'sy': cpuMatch.group(2),
          'ni': cpuMatch.group(3),
          'id': cpuMatch.group(4),
          'wa': cpuMatch.group(5),
          'hi': cpuMatch.group(6),
          'si': cpuMatch.group(7),
          'st': cpuMatch.group(8),
        };
      }
    } else if (line.startsWith('MiB Mem :')) {
      var memMatch = RegExp(
              r'MiB Mem :\s+([\d.]+)\s+total,\s+([\d.]+)\s+free,\s+([\d.]+)\s+used,\s+([\d.]+)\s+buff/cache')
          .firstMatch(line);
      if (memMatch != null) {
        details['memory'] = {
          'Mem': {
            'total': memMatch.group(1),
            'free': memMatch.group(2),
            'used': memMatch.group(3),
            'buff/cache': memMatch.group(4),
          }
        };
      }
    } else if (line.startsWith('MiB Swap:')) {
      var swapMatch = RegExp(
              r'MiB Swap:\s+([\d.]+)\s+total,\s+([\d.]+)\s+free,\s+([\d.]+)\s+used.\s+([\d.]+)\s+avail Mem')
          .firstMatch(line);
      if (swapMatch != null) {
        details['swap'] = {
          'Swap': {
            'total': swapMatch.group(1),
            'free': swapMatch.group(2),
            'used': swapMatch.group(3),
          },
          'avail': swapMatch.group(4)
        };
      }
    }
  }

  return details;
}
