import 'dart:io';


String address = "127.0.0.1";
int port = 1975;


main() async
{
    //var channel = IOWebSocketChannel.connect(Uri.parse('ws://thetechclicks.com:1975');

    var socket = await WebSocket.connect('ws://${address}:${port}/ws');
    socket.add('Hello ${address}, I am a client!');
    print("Connected to ${address} on port ${port}.");

    print("Enter a username for chat: ");
    String? username = stdin.readLineSync();
    socket.add("My username is: ${username}");


}
