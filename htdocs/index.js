window.addEventListener('load', function () {
    // var THREE = require('three');
    var createGame = require('voxel-engine');
    var game = createGame({
        generate: function(x, y, z) { return 0; },
        materials: ["#f00", "#0f0", "#00f", "#000", "#fff"],
        materialFlatColor: true
    });
    game.appendTo(document.body);
    game.gravity = [0, 0, 0];

    var createPlayer = require('voxel-player')(game);
    var player = createPlayer('dude.png');
    player.possess();
    player.position.set(0, 0, 5);

    window.addEventListener('keyup', function (event) {
        player.velocity = {x: 0, y: 0, z: 0};
    });

    var blocks = [];

    // WebSocket Client

    const socket = new WebSocket("ws://localhost:8001/");

    socket.addEventListener('message', function (event) {
        // var msg = JSON.parse(event.data);
        // console.log('Message from the server:', msg);

        for (var i=0; i < blocks.length; i++) {
            game.setBlock(blocks[i], 0);
        }
        blocks = [];
        lines = event.data.split(/\n/);
        for (var y=0; y < lines.length; y++) {
            for (var x=0; x < lines[y].length; x++) {
                var c = lines[y].charAt(x);
                if (!(c === " ")) {
                    game.setBlock([x, y, 0], parseInt(c, 10));
                    blocks.push([x, y, 0]);
                }
            }
        }
    });
});
