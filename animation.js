const express = require('express');
const cors = require('cors');
const app = express();
const port = 3002;

app.use(cors());

const imageUrl = 'https://fruitykiduserimagebucket.s3.eu-north-1.amazonaws.com/apple.jpg';
const additionalText = 'apple';

app.get('/animation', (req, res) => {
  res.json({ imageUrl, additionalText });
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
