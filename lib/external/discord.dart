// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

interface class Embed {
  final String title;
  final String description;

  Embed(this.title, this.description);
}

class Discord {
  final String bot_token;
  final String url;
  final String version;

  late final String _url;

  Discord({required this.bot_token, required this.url, required this.version})
      : _url = '$url/v$version';

  Future<Map> send_message(String msg, {required String channel_id, Embed? embed}) async {
    Map<String, dynamic> message_data = {
      "content": msg,
      "tts": false,
      "embeds": [
        {"title": embed?.title, "description": embed?.description}
      ]
    };

    String channel_url = '$_url/channels/$channel_id/messages';

    var response = await http.post(
      Uri.parse(channel_url),
      headers: {
        'Authorization': 'Bot $bot_token',
        'User-Agent': 'DiscordBot ($url, 9)',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message_data),
    );

    return jsonDecode(response.body);
  }

  String get base_url => _url;
}
