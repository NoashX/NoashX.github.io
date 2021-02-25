map.when(function() {
  map.loadAll()
    .catch(function(error) {
      console.log("error: ", error);
    })
    .then(function() {
      console.log("All loaded");
      map.layers.forEach(function(layer) {
        layers.push(layer);
      });
      console.log("# of layers in webmap: ", layers.length);
      var i;
      for (i = 0; i < layers.length; i++) {
        console.log("analyzing layer #", i + 1);
        switch (layers[i].renderer.type) {
          case "unique-value":
            console.log("unique-value case");
            var uniqueLayer = layers[i];
            var length = uniqueLayer.renderer.uniqueValueInfos.length;
            var labelArray = [];
            var j;
            for (j = 0; j < length; j++) {
              var word = layers[i].renderer.field;
              var field = "$feature." + word;
              var compare2 = layers[i].renderer.uniqueValueInfos[j].value;
              var whereExpression;
              if (isNaN(compare2)) {
                whereExpression = word + " = '" + compare2 + "'";
              } else {
                whereExpression = word + " = " + compare2;
              }
              var uniqueColor = layers[i].renderer.uniqueValueInfos[j].symbol.color;
              var theHaloColor;
              if (uniqueColor == "black") {
                theHaloColor = "white";
              } else if (uniqueColor == null) {
                theHaloColor = "black";
                uniqueColor = "white";
              } else {
                theHaloColor = "black";
              }
              var placement;
              if (uniqueLayer.geometryType == "point") {
                placement = "above-left";
              } else if (uniqueLayer.geometryType == "polygon") {
                placement = "always-horizontal";
              } else if (uniqueLayer.geometryType == "polyline") {
                placement = "center-along";
              } else {
                console.log("geomType undefined :(");
              }
              var labelclass = {
                symbol: {
                  type: "text",
                  color: uniqueColor,
                  haloColor: theHaloColor,
                  haloSize: 1.5,
                  font: {
                    family: "Arial Unicode MS",
                    size: 14
                  }
                },
                labelPlacement: placement,
                labelExpressionInfo: {
                  expression: field
                },
                where: whereExpression
              };
              labelArray.push(labelclass);
            }
            layers[i].labelingInfo = labelArray;
            layers[i].labelsVisible = true;
            break;
          default:
            console.log("DEFAULT CASE");
        }
      }
  }
});
