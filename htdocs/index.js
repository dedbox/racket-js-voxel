window.addEventListener('load', function () {
    var THREE = require('three');

    var createGame = require('voxel-engine');
    window.game = createGame({
        generate: function(x, y, z) { return y === -1 ? 1 : 0; },
        materials: ["#000", "#f00", "#0f0", "#00f", "#fff"],
        materialFlatColor: true
    });
    game.appendTo(document.body);
    // game.gravity = [0, 0, 0];

    var createPlayer = require('voxel-player')(game);
    var player = createPlayer('dude.png');
    player.possess();
    player.position.set(-2, 0, 5);

    // window.addEventListener('keyup', function (event) {
    //     player.velocity = {x: 0, y: 0, z: 0};
    // });

    // WebSocket Client

    const socket = new WebSocket("ws://localhost:8001/");

    socket.addEventListener('message', function (event) {
        var msg = JSON.parse(event.data);

        // console.log('Got message:', msg);
        
        if (msg.action === "voxel") {
            game.materials.load(msg.color);
            game.setBlock(msg.position, msg.color);
        }

        else if (msg.action === "unvoxel") {
            game.setBlock(msg.position, 0);
        }

        else {
            console.log('unhandled websocket message:', msg);
        }
    });
});
