//import 'package:dart_websockets/server.dart';
import 'dart:io';

const int port = 1000;
List<WebSocket> connections;


void main()
{

    connections = new List<WebSocket>();

    HttpServer.bind(InternetAddress.ANY_UP_V4, port).then((HttpServer server)
    {
        print('Server listening on port ${port}.');
        server.listen((HttpRequest request)
        {

            if (WebsocketTransformer.isUpgradeRequest(request)))
            {
                WebSocketTransformer.upgrade(request).then(Websocket ws)
                {
                    connections.add(ws);
                    print('Client connected, there are now ${connections.length} client(s) connected.');
                    ws.listen((String message)
                    {
                        for (Websocket connection in connections)
                        {
                            connection.add(message);
                        }
                    },

                    onDone: ()
                    {
                        connections.remove(ws);
                        print('Client disconnected, there are now ${connections.length} client(s) connected.');
                    });
                });
            }

            else
            {
                request.response.statusCode = HttpStatus.FORBIDDEN;
                request.response.reasonPhrase = 'Websocket connections only!';
                request.response.close();
            }
        }
    });

}
