// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( './Main' );
var localForage = require('localForage');
var app = Elm.Main.embed( document.getElementById( 'main' ) );


localForage.getItem('deck', function (err, value) {
    if (!err && value) {
        setTimeout(function () {
            app.ports.loadDeck.send(value);
        });
    }
    app.ports.saveDeck.subscribe(function (deck) {
        localForage.setItem('deck', deck);
    });
});

app.ports.requestTableMetrics.subscribe(function () {
  var tableTop = document.querySelector('table').offsetTop;
  var rowBottoms = Array.prototype.map.call(document.querySelectorAll('tr'), function (tr) {return tr.offsetTop + tr.offsetHeight;})
  app.ports.receiveTableMetrics.send({
    tableTop: tableTop,
    rowBottoms: rowBottoms
  })
})

app.ports.focusAndSelect.subscribe(function (id) {
  var element = document.getElementById(id);
  if (!element) {
    console.error("Could not find element by ID: " + id);
  }
  element.focus();
  element.select();
})
