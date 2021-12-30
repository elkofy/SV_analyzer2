const express = require("express");
const res = require("express/lib/response");
const R = require("r-integration");
const app = express();
const cors = require("cors");


var array;


global.__basedir = __dirname;

var corsOptions = {
  origin: "http://localhost:8081"
};

app.use(cors(corsOptions));

const initRoutes = require("./routes");

app.use(express.urlencoded({ extended: true }));
initRoutes(app);

let port = 8080;
app.listen(port, () => {
  console.log(`Running at localhost:${port}`);
});
  

app.get("/", function (req, res) {
  res.send("Hello World");
  
});




var server = app.listen(8081, function () {
  var port = server.address().port;
  console.log(`Example app listening at http://localhost:${port}`);
});
