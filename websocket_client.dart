import 'dart:io';


String address = "127.0.0.1";
int port = 1975;
String version = "0.1";

List<String> servers = ["127.0.0.1", "neostalgia.ddns.net", "thetechclicks.com"];

main() async
{
    //var channel = IOWebSocketChannel.connect(Uri.parse('ws://thetechclicks.com:1975');

    var socket = await WebSocket.connect('ws://${address}:${port}/ws');
    socket.add(version);
    print("Connected to ${address} on port ${port}.");

    print("Enter a username for chat: ");
    String? username = stdin.readLineSync();
    socket.add(username);

    


}
