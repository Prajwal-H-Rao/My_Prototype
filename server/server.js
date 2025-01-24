const dotenv = require("dotenv");
const cors = require("cors");
const express = require("express");

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Listening on port:${port}`);
});
