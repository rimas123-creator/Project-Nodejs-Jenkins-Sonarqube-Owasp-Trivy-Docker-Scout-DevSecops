const express = require('express');
const app = express();
const port = 3001;

app.get('/', (req, res) => {
    res.send(`Welcome to the DevSecOps NodeJS APP running on port ${port}`);
});

app.listen(port , () => {
    console.log(`Server is running on http://localhost:${port}`);
});