import 'dart:io';

void  main() async
{
    var server = await HttpServer.bind('127.0.0.1', 1975);
    //await server.forEach((HttpRequest request)
    //{
    //    request.response.write('Hello, world!');
    //    request.response.close();
    //});
    

    server.listen((HttpRequest req) async
    {
        if (req.uri.path == '/ws')
        {
            var socket = await WebSocketTransformer.upgrade(req);
            print(socket.listen());
        }
    });



    
}
