const express = require('express');
const axios = require('axios');

const app = express();
const PORT = 5050; // You can choose any port number

app.use(express.json()); // Middleware to parse JSON bodies

// Example route that makes an external API call
app.get('/fetch-data', async (req, res) => {
  try {
    const response = await axios.get('https://api.example.com/data'); // Replace with the actual API URL
    res.json(response.data);
  } catch (error) {
    console.error('Error making API call:', error);
    res.status(500).json({ error: 'Failed to fetch data' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
