import 'dart:io';


int port = 1975;
String address = '127.0.0.1'; 


void  main() async
{
    var server = await HttpServer.bind(address, port);
    server.listen((HttpRequest req) async
    {
        print('Connection requested');
        print(req.uri);
        if (req.uri.path == '/ws')
        {
            var socket = await WebSocketTransformer.upgrade(req);

            String version = "";
            String username = "";
            String user_address = "";
            //String user_address = req.headers;
            //print(user_address);

            socket.listen((client) async
            {
                print(client);

                if (client.length >= 9)
                {
                    if (client.substring(0, 8) == "version: ")
                    {
                        String version = client.substring(9);
                    }
                }

                if (client.length >= 10)
                {
                    if (client.substring(0, 9) == "username: ")
                    {
                        String username = client.substring(10);
                        print('User "${username}" joined from ${user_address} version ${version}');
                        socket.add("Data received, user '${username}' at ${user_address}");
                    }
                }

                    
            });

        }
    });



    
}













void handleConnection(String client)
{
    print(client);
}


void handleConnections(Socket client)
{
    print('Connection from ${client.remoteAddress.address}:${client.remotePort}');

    // listen for events from the client
    client.listen(

    // handle data from the client
    (data) async 
    {
        await Future.delayed(Duration(seconds: 1));
        final message = String.fromCharCodes(data);
     
        if (message == '') 
        {
        client.write('Who is there?');
        } 

        else if (message.length < 10) 
        {
            client.write('$message who?');
        } 

        else 
        {
            client.write('Very funny.');
            client.close();
        }
    },

    // handle errors
    onError: (error) 
    {
        print(error);
        client.close();
    },

    // handle the client closing the connection
    onDone: () 
    {
        print('Client left');
        client.close();
    },
  );



}
