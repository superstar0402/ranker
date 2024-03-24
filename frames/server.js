const express = require('express');
const axios = require('axios');

const app = express();
const PORT = 5050;

app.use(express.json()); // Middleware to parse JSON bodies

// Existing example route
app.get('/fetch-data', async (req, res) => {
  // Existing functionality
});

app.post('/scores/personalized/engagement/fids', async (req, res) => {
  const { k, limit } = req.query; // Extracting query parameters
  const fids = req.body; // The list of fids from the request body

  // Construct the API URL with query parameters
  const apiUrl = `https://api.example.com/scores/personalized/engagement/fids?k=${k || 2}&limit=${limit || 100}`;

  try {
    // Making a POST request to the external API
    const response = await axios.post(apiUrl, fids, {
      headers: {
        'Content-Type': 'application/json', // Ensure proper content type header
      },
    });
    res.json(response.data); // Send back the response data
  } catch (error) {
    console.error('Error making API call:', error);
    res.status(500).json({ error: 'Failed to fetch data' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
