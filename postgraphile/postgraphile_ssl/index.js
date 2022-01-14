const express = require("express");
const { postgraphile } = require("postgraphile");
require("dotenv").config();

const app = express();
process.env.NODE_TLS_REJECT_UNAUTHORIZED=0


app.use(
  postgraphile(process.env.DATABASE_URL , "public", {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
  })
);

app.listen(process.env.PORT);
