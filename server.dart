import 'dart:io';
//import 'dart:typed_data';

int port = 1975;
List<dynamic> data_array = [[]];


void main() async
{
    data_array[0] = ["server", "Chatroom initiated"];

    // bind the socket server to an address and port
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);

    // listen for clent connections to the server
    server.listen((client)
    {
        handleConnection(client);
    });
}

void handleConnection(Socket client) 
{
    String version = "";
    String username = "";


    stdout.writeln('Connection from ${client.remoteAddress.address}:${client.remotePort}');

    // listen for events from the client
    client.listen(

    // handle data from the client
    (Uint8List data) async 
    {
        await Future.delayed(Duration(seconds: 1));
        final message = String.fromCharCodes(data);


        stdout.writeln(message);

        if (version != "" && message.length >= 9)
        {
            if (message.substring(0, 9) == "version: ")
            {
                String version = message.substring(9);
                client.write("200");
                //check if version is recent enough, if not send error "505"
            }
        }

        if (username != "" && message.length >= 10)
        {
            if (message.substring(0, 10) == "username: ")
            {
                String username = message.substring(10);
                ('User "${username}" joined from ${client.remoteAddress.address} version ${version}');
                client.write("200");

                //check against usernames that are similar to "server"

                //check username does not already exist
            }
        }

        if (message.length >= 6)
        {
            if (message.substring(0, 6) == "data: ")
            {
                client.write("200");
                stdout.writeln(data);
                data_array.add(["test", "test"]);
                stdout.writeln(data);
                data_array.add([username, message.substring(6)]);
            }
        }

        else
        {
            stdout.writeln('Invalid data received from ${username} @${client.remoteAddress.address}');
            client.write('400');
        }     

        client.close();



    },

    // handle errors
    onError: (error) 
    {
      stdout.writeln(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () 
    {
      stdout.writeln('Client ${username} disconnected');
      data_array.add(["server", "#${username} has left the chat"]);
      client.close();
    },
  );
}
