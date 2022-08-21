import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'dart:io';

main() async
{
    //var channel = IOWebSocketChannel.connect(Uri.parse('ws://thetechclicks.com:1975');

    var socket = await WebSocket.connect('ws://thetechclicks.com:1975/ws');
    socket.add('Hello, I am a client!');


}
