const uploadFile = require("../middleware/upload");
const XLSX = require("xlsx");
const path = require("path");
const fs = require('fs')

const analyseXlSX = async (req, res) => {
  try {
    await uploadFile(req, res);
    if (req.file == undefined) {
      return res.status(400).send({ message: "Please upload a file!" });
    }
    const fileName = req.file.originalname;
    const filepath = path.parse(fileName).name;
    var obj = getXlsxData(fileName);
    var seuils = getSeuils(filepath);
    res.status(200).send({
      Seuils: seuils,
      Data: obj,
    });

    fs.unlink("./excel/"+fileName, (err => {
        if (err) console.log(err);
      }));



  } catch (err) {
    res.status(500).send({
      message: `Could not upload the file: ${req.file.originalname}. ${err}`,
    });
  }
};


function getSeuils(filename) {
    let result = callMethod("./fonctions_aux.R", "code_ruptures", ["./excel/" + filename]);
    result = [parseFloat(result[1].slice(6)), parseFloat(result[2].slice(6))];
    return {SV1: result[0], SV2: result[1]};
}

function worker(workbook, letter) {
  let obj = [];
  let first_sheet_name = workbook.SheetNames[0];
  let worksheet = workbook.Sheets[first_sheet_name];
  for (let index = 121; index < 1000; index++) {
    let address_of_cell = letter + index;
    let desired_cell = worksheet[address_of_cell];
    let desired_value = desired_cell ? desired_cell.v : undefined;
    if (desired_value != undefined) {
      obj.push(desired_value);
    }
  }
  return obj;
}
function getXlsxData(filename) {
  let workbook = XLSX.readFile("./excel/" + filename);
  let VEVO2 = worker(workbook, "I");
  let Time = worker(workbook, "A");
  return { VEVO2: VEVO2, Time: Time };
}

module.exports = {
  analyseXlSX,
};
