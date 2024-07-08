const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors()); // Enable CORS

app.get('/fruits/1', (req, res) => {
  res.json({
    name: 'Apple',
    vitamins: 'Vitamin A, Vitamin C',
    fiber: '2.4g', // Ensure 'fiber' field is correctly named
    sugarContent: '10g'
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
