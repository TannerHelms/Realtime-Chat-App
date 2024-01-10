const express = require('express');
const { createServer } = require('node:http');
const { join } = require('node:path');
const { Server } = require('socket.io');

const app = express();
const server = createServer(app);
const io = new Server(server);

io.on('connection', (socket) => {
    console.log(socket.id);
    const username = socket.handshake.query.username;
  console.log(`${username} has joined the server`);
  const welcome = {
    message: `Welcome to the server ${username}`,
    senderUsername: 'Server',
    sentAt: Date.now()
  }

  io.to(socket.id).emit('message', welcome);

  socket.on('message', (data) => {
    const message = {
        message: data.message,
        senderUsername: username,
        sentAt: Date.now()
    };
    io.emit('message', message);
  });
});

server.listen(3000, () => {
  console.log('server running at http://localhost:3000');
});