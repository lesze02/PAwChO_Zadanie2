const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
    const data = new Date().toLocaleString();
    console.log(`Data uruchomienia: ${data}`);
    console.log(`Autor: Szymon Oleszek`);
    console.log(`Port TCP: ${PORT}`);
});