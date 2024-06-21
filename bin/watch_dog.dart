import 'package:dotenv/dotenv.dart';
import 'package:theo/external/discord.dart';
import 'package:theo/internal/watch_dir.dart';

void main(List<String> args) async {
  DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  String version = '9';
  String url = 'https://discord.com/api';

  Discord discord =
      Discord(bot_token: env['TOKEN'] ?? "", url: url, version: version);

  String? path = env['LOG_PATH'];
  if (path == null) throw Exception('LOG PATH not defined');

  wath_dir((message) async {
    // ignore: non_constant_identifier_names
    final l_time = DateTime.now().toString();

    await discord.send_message(
      message,
      channel_id: env['CHANNEL_ID'] ?? '',
      embed: Embed('NOTIFICATION SERVICE DUMP', l_time),
    );

    print('$l_time : um novo log foi enviado ao discord');
  }, path: path);
}
