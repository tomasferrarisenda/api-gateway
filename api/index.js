const express = require('express');
const app = express(); // Create an Express application using the express function
const PORT = 3000;

app.use(express.json()); // Middleware to parse JSON bodies

app.get('/tshirt', (req, res) => {
    res.status(200).send({
        tshirt: '👕',
        size: 'large'
    });
});

app.post('/tshirt/:id', (req, res) => {
    const { id } = req.params;
    const { logo } = req.body;

    if (!logo) {
        res.status(418).send({ message: 'We need a logo!' });
        return; // Ensure no further processing if logo is not provided
    }

    res.send({
        tshirt: `👕 with your ${logo} and ID of ${id}`
    });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
