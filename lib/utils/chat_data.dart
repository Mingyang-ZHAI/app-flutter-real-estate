import 'package:flutter/material.dart';

List chatData = [
  {
    "id": "1",
    "name": "Sarah Williams",
    "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "lastMessage": "Is the villa still available for viewing tomorrow?",
    "timeAgo": "2 min ago",
    "unread": true,
    "unreadCount": 3,
    "isOnline": true,
    "messages": [
      {
        "text": "I'm interested in the villa at Phnom Penh, is it still available?",
        "isMe": false,
        "time": "2023-05-04T14:32:00",
      },
      {
        "text": "Yes, it's still available! Would you like to schedule a viewing?",
        "isMe": true,
        "time": "2023-05-04T14:35:00",
      },
      {
        "text": "Is the villa still available for viewing tomorrow?",
        "isMe": false,
        "time": "2023-05-04T14:40:00",
      },
    ],
  },
  {
    "id": "2",
    "name": "Robert Chen",
    "image": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "lastMessage": "What's the square footage of the Twin Villa?",
    "timeAgo": "15 min ago",
    "unread": true,
    "unreadCount": 1,
    "isOnline": false,
    "messages": [
      {
        "text": "Hello, I'd like to know more about the Twin Villa",
        "isMe": false,
        "time": "2023-05-04T13:25:00",
      },
      {
        "text": "Hi Robert! What would you like to know specifically?",
        "isMe": true,
        "time": "2023-05-04T13:40:00",
      },
      {
        "text": "What's the square footage of the Twin Villa?",
        "isMe": false,
        "time": "2023-05-04T13:45:00",
      },
    ],
  },
  {
    "id": "3",
    "name": "Jennifer Park",
    "image": "https://images.unsplash.com/photo-1617069470302-9b5592c80f66?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "lastMessage": "Thanks for the virtual tour, it was helpful!",
    "timeAgo": "2 hours ago",
    "unread": false,
    "unreadCount": 0,
    "isOnline": true,
    "messages": [
      {
        "text": "Can I get a virtual tour of the property?",
        "isMe": false,
        "time": "2023-05-04T10:05:00",
      },
      {
        "text": "Of course! I'll send you a link shortly.",
        "isMe": true,
        "time": "2023-05-04T10:10:00",
      },
      {
        "text": "Here's the virtual tour link: https://tour.example.com/villa123",
        "isMe": true,
        "time": "2023-05-04T10:15:00",
      },
      {
        "text": "Thanks for the virtual tour, it was helpful!",
        "isMe": false,
        "time": "2023-05-04T12:00:00",
      },
    ],
  },
  {
    "id": "4",
    "name": "Michael Johnson",
    "image": "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "lastMessage": "I'd like to make an offer for the Garden House",
    "timeAgo": "5 hours ago",
    "unread": false,
    "unreadCount": 0,
    "isOnline": false,
    "messages": [
      {
        "text": "I really liked the Garden House property",
        "isMe": false,
        "time": "2023-05-03T19:30:00",
      },
      {
        "text": "That's great to hear! It's one of our finest properties.",
        "isMe": true,
        "time": "2023-05-03T19:45:00",
      },
      {
        "text": "I'd like to make an offer for the Garden House",
        "isMe": false,
        "time": "2023-05-03T20:00:00",
      },
    ],
  },
  {
    "id": "5",
    "name": "Emily Zhang",
    "image": "https://images.unsplash.com/photo-1564460576398-ef55d99548b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "lastMessage": "Can we negotiate on the price for the Single Villa?",
    "timeAgo": "1 day ago",
    "unread": false,
    "unreadCount": 0,
    "isOnline": true,
    "messages": [
      {
        "text": "Hello, I'm interested in the Single Villa property",
        "isMe": false,
        "time": "2023-05-02T15:10:00",
      },
      {
        "text": "It's currently listed at \$280k, correct?",
        "isMe": false,
        "time": "2023-05-02T15:12:00",
      },
      {
        "text": "Yes, that's right. It's one of our premium properties.",
        "isMe": true,
        "time": "2023-05-02T15:20:00",
      },
      {
        "text": "Can we negotiate on the price for the Single Villa?",
        "isMe": false,
        "time": "2023-05-03T10:05:00",
      },
    ],
  },
  {
    "id": "6",
    "name": "David Smith",
    "image": "https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "lastMessage": "Are there any similar properties in that neighborhood?",
    "timeAgo": "2 days ago",
    "unread": false,
    "unreadCount": 0,
    "isOnline": false,
    "messages": [
      {
        "text": "I missed out on the Double Villa, it seems it's already sold",
        "isMe": false,
        "time": "2023-05-01T09:20:00",
      },
      {
        "text": "Yes, that property was sold yesterday. I apologize for that.",
        "isMe": true,
        "time": "2023-05-01T09:30:00",
      },
      {
        "text": "Are there any similar properties in that neighborhood?",
        "isMe": false,
        "time": "2023-05-02T11:45:00",
      },
    ],
  },
];