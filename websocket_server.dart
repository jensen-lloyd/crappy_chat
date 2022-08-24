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
            print('Connection upgraded to WebSocket');
            socket.listen((client) 
            {
                bool error = false;
                while (error == false)
                {
                    //move socket listen inside while loop
                    String data = client;
                    print(data);

                    if (data.length >= 10)
                    {
                        if (data.substring(0, 9) == "username: ")
                        {
                            String username = data.substring(10);
                            print('Username "${username}" received.');
                        }
                    }

                    if (data.length >= 9)
                    {
                        if (data.substring(0, 8) == "version: ")
                        {
                            String version = data.substring(9);
                        }
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
