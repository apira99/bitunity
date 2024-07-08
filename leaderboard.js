const express = require('express');
const cors = require('cors');

const app = express();
const port = 3001;

app.use(cors({
  origin: '*', // Allow all origins
  methods: ['GET'], // Allow GET requests
  allowedHeaders: ['Content-Type'], // Allow Content-Type header
}));

// Sample leaderboard data (replace with your actual data)
const leaderboardData = [
  { name: 'Jackson', score: 1847, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user2.jpg' },
  { name: 'Eiden', score: 2430, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user1.jpg' },
  { name: 'Emma & Ava', score: 1674, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user3.jpg' },
  { name: 'Sebastian', score: 1124, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user4.jpg' },
  { name: 'Jason', score: 875, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user5.jpg' },
  { name: 'Natalie', score: 776, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user6.jpg' },
  { name: 'Serenity', score: 723, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user7.jpg' },
  { name: 'Hannah', score: 589, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user8.jpg' },
  { name: 'Patricia', score: 425, imageUrl: 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/user9.jpg' },
];

// Endpoint to get leaderboard data
app.get('/leaderboard', (req, res) => {
  res.json(leaderboardData);
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
