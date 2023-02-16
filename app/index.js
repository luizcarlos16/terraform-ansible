const express = require('express')
const app = express()
const PORT = 3000;
const HOST = '0.0.0.0';

app.listen(PORT, HOST);
console.log(`Acesse http://${HOST}:${PORT}`);
app.get('/', (req, res) => {
  const candidato = process.env.CANDIDATO || 'Luiz Carlos Nascimento Junior';
  res.send(`Bem-vindo ${candidato}!`);
});
