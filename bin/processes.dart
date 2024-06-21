import 'package:cron/cron.dart';
import 'package:dotenv/dotenv.dart';
import 'package:theo/external/discord.dart';
import 'package:theo/internal/cpu_process.dart';

void main() {
  DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  String version = '9';
  String url = 'https://discord.com/api';

  Discord discord =
      Discord(bot_token: env['TOKEN'] ?? "", url: url, version: version);

  Cron cron = Cron();

  cron.schedule(Schedule.parse('* * * * *'), () async {
    try {
      var details = get_system_info();

      // Tempo de atividade
      var uptime = details['uptime'];

      // Média de carga
      var loadAverage = details['load_average'];

      // Processos
      var tasks = details['tasks'];
      var totalTasks = tasks['total'];
      var runningTasks = tasks['running'];
      var sleepingTasks = tasks['sleeping'];

      // Uso da CPU
      var cpu = details['cpu'] ?? "";
      var userCpu = cpu['us'] ?? "";
      var systemCpu = cpu['sy'] ?? "";
      var idleCpu = cpu['id'] ?? "";

      // Memória
      var memory = details['memory'];
      var totalMemory = memory['Mem']['total'];
      var freeMemory = memory['Mem']['free'];
      var usedMemory = memory['Mem']['used'];

      // Memória Swap
      var swap = details['swap'];
      var totalSwap = swap['Swap']['total'];
      var freeSwap = swap['Swap']['free'];
      var usedSwap = swap['Swap']['used'];

      // Usuários
      var users = details['users'];

      String message = '''
- Tempo de atividade: $uptime
- Usuários conectados: $users
- Média de carga: $loadAverage
- Processos: Total: $totalTasks, Rodando: $runningTasks, Dormindo: $sleepingTasks
- Uso da CPU: Usuário: $userCpu%, Sistema: $systemCpu%, Ociosidade: $idleCpu%
- Memória: Total: $totalMemory MB, Livre: $freeMemory MB, Usada: $usedMemory MB
- Memória Swap: Total: $totalSwap MB, Livre: $freeSwap MB, Usada: $usedSwap MB
''';

      await discord.send_message(
        message,
        channel_id: env['CHANNEL_ID'] ?? '',
        embed: Embed('INFORMACOES DO SISTEMA', DateTime.now().toString()),
      );
    } catch (e) {
      await discord.send_message(
        e.toString(),
        channel_id: env['CHANNEL_ID'] ?? '',
        embed: Embed('ERRO DE ENVIO DE MENSAGEM', DateTime.now().toString()),
      );
    }
  });
}
