const express = require("express");
const app = express();
const cors = require("cors");


global.__basedir = __dirname;

var corsOptions = {

  origin:'*',
};

app.use(cors(corsOptions));

const initRoutes = require("./routes");

app.use(express.urlencoded({ extended: true }));
initRoutes(app);

let port = 3000;
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
