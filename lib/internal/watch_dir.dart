// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

void wath_dir(Function(String) call_back, {required String path}) {
  final directory = Directory(path);

  if (!directory.existsSync()) throw Exception('PATH NOT FOUND: $path');

  directory.watch().listen((event) async {
    if (event.type == FileSystemEvent.create) {
      final contents = await File(event.path).readAsString();

      try {
        var data = jsonDecode(contents);
        DateTime time = DateTime.parse(data["timestamp"]);
        String f_time = '${time.hour}:${time.minute}h.';
        String method = data["type"].toString().toLowerCase();
        String ins_id = data["installment_id"];

        var sms =
            'Houve uma falha no envio de $method para a parcela $ins_id as $f_time';

        call_back(sms);
      } catch (e) {
        call_back(
            'Uma nova falha ocorreu, mas houve uma erro ao ler o novo arquivo de erro.');
      }
    }
  });
}
