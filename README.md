# Chat App

This project is a real-time one-to-one chat application built using Flutter and Django. It leverages websockets to facilitate real-time communication between users.
## Features
### Real-time one-to-one chat

Exchange messages instantly with the other user.
## Auto-scrolling to newest message

When a new message arrives, the chatbox automatically scrolls to the bottom to show the latest message.
## Dynamic message box

The message box can dynamically grow in size, up to six lines, as the user types a longer message.
## Robust and efficient backend

The Django server provides a stable and efficient backend support for the application.
## How it Works

The application makes use of the web_socket_channel package to establish a websocket connection with the Django server. Messages are sent and received in JSON format, with details including the message content, and the sender and receiver information.
