# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

function to_data(wb) {
  var result = [];
  var ws = wb.Sheets[wb.SheetNames[0]];
  var csv = XLS.utils.sheet_to_csv(ws);
  return csv.split('\n').map(function(x){return x.split(",")});
}

function handleFile(e) {
  var files = e.target.files;
  var i,f;
  for (i = 0; i != files.length; ++i) {
    f = files[i];
    var reader = new FileReader();
    var name = f.name;
    reader.onload = function(e) {
      var data = e.target.result;

      var workbook;
      if(rABS) {
        /* if binary string, read with type 'binary' */
        workbook = XLSX.read(data, {type: 'binary'});
      } else {
        /* if array buffer, convert to base64 */
        var arr = fixdata(data);
        workbook = XLSX.read(btoa(arr), {type: 'base64'});
      }
      work = workbook;
      hot1 = new Handsontable(container1, {
         data: to_data(workbook),
         header: true
       });
    };
    reader.readAsBinaryString(f);
  }
}

function fixdata(data) {
  var o = "", l = 0, w = 10240;
  for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
  o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
  return o;
}

var rABS, container1, hot1, work;


$(document).ready(function(){
  document.getElementById("file").addEventListener('change', handleFile, false);
  rABS = true;
  container1 = document.getElementById('example1');
  hot1;
});
