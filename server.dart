import 'dart:io';


int port = 1975;
String address = '127.0.0.1'; 


void  main() async
{
    var server = await HttpServer.bind(address, port);
    server.listen((HttpRequest req) async
    {
        print('Connection requested');
        print(req);

        if (req.uri.path == '/ws')
        {
            var socket = await WebSocketTransformer.upgrade(req);
            print('Connection upgraded to WebSocket');
            socket.listen((client) 
            {
                //handleConnection(client);
                print(client);
            });
        }
    });



    
}



void handleConnection(Socket client)
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
