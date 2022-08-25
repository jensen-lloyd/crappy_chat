import 'dart:io';
import 'dart:typed_data';
import 'dart:math';


int port = 1975;
String version = "0.1";
String address = "127.0.0.1"; //temporary
bool error = false;

List<String> servers = ["127.0.0.1", "neostalgia.ddns.net", "thetechclicks.com"];


void main() async 
{
    
    //String address = servers[Random().nextInt(servers.length-1)];

    // connect to the socket server
    final server = await Socket.connect(address, port);
    print('Connected to: ${server.remoteAddress.address}:${server.remotePort}');

    // listen for responses from the server
    server.listen(

    // handle data from the server
    (Uint8List data) 
    {
        final serverResponse = String.fromCharCodes(data);
        
        if (serverResponse.substring(0,3) == "505")
        {
            stdout.writeln("This version of the app (${version}) is outdated, please update and come back!");
        }

        if (serverResponse.substring(0,3) == "400")
        {
            stdout.writeln("The app has encountered an error, please try again.");
            stdout.writeln("If this has occured multiple times, close and reopen the app.");
            stdout.writeln("If reopening the app does not work, my sincere apologies. There might be an issue with the server, or more likely, the code.");
        }

        if (serverResponse.substring(0,3) == "200")
        {
            if (serverResponse.length >= 3)
            {
                stdout.writeln(serverResponse.substring(3));
            }
        }

    },

    // handle errors
    onError: (error)
    {
        error = true;
        print(error);
        server.destroy(); 
    }, 

    // handle server ending connection 
    onDone: () 
    {
        print('Server left.');
        server.destroy();
    },
  );

    // send some messages to the server
    sendData(server, "using the sendData function");
    sendData(server, "version: ${version}");
    stdout.writeln("Enter a username for chat: ");
    String? username = stdin.readLineSync();
    sendData(server, "username: ${username}");

    while (error == false)
    {
        sendData(server, "data: ${stdin.readLineSync()}");
    }
}



Future<void> sendData(Socket server, String data) async
{
    server.write(data);
    await Future.delayed(Duration(seconds: 2));

}
