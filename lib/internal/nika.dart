import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final backupDir = '/home/ivy/bkp';
  final date = DateTime.now().toIso8601String().split('T').first;
  final backupFile = 'backup_$date.sql';
  final pgHost = 'localhost';
  final pgPort = '5435';
  final pgUser = 'seu_usuario';
  final pgDb = 'seu_banco_de_dados';

  final command = 'pg_dump';
  final args = [
    '-h',
    pgHost,
    '-p',
    pgPort,
    '-U',
    pgUser,
    '-F',
    'c',
    '-b',
    '-v',
    '-f',
    p.join(backupDir, backupFile),
    pgDb,
  ];

  try {
    print('Iniciando backup do banco de dados...');
    final result =
        await Process.run(command, args, mode: ProcessStartMode.inheritStdio);

    if (result.exitCode == 0) {
      print('Backup realizado com sucesso: $backupFile');
    } else {
      print('Falha ao realizar o backup.');
      print('Código de saída: ${result.exitCode}');
    }
  } catch (e) {
    print('Erro ao executar o comando de backup: $e');
  }

  try {
    final daysOld = 7;
    final findCommand = 'find';
    final findArgs = [
      backupDir,
      '-type',
      'f',
      '-name',
      'backup_*.sql',
      '-mtime',
      '+$daysOld',
      '-exec',
      'rm',
      '{}',
      '\\;',
    ];

    print('Limpando backups antigos...');
    final findResult = await Process.run(findCommand, findArgs,
        mode: ProcessStartMode.inheritStdio);

    if (findResult.exitCode == 0) {
      print('Limpeza de backups antigos concluída.');
    } else {
      print('Falha ao limpar backups antigos.');
      print('Código de saída: ${findResult.exitCode}');
    }
  } catch (e) {
    print('Erro ao executar a limpeza de backups: $e');
  }

  print('Processo de backup concluído.');
}
