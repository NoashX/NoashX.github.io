<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>  
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=7,IE=9" />
    <!--The viewport meta tag is used to improve the presentation and behavior of the samples on iOS devices-->
    <meta name="viewport" content="initial-scale=1, maximum-scale=1,user-scalable=no"/>
	<title>Flood Information Map</title>
	<link rel="stylesheet" type="text/css" href="claro.css">
	<link rel="stylesheet" href="http://serverapi.arcgisonline.com/jsapi/arcgis/3.3/js/esri/css/esri.css">
	<script type="text/javascript">var djConfig = {parseOnLoad: true};</script>	<!--- for basemaps --->
	<script src="http://serverapi.arcgisonline.com/jsapi/arcgis/3.3/"></script>
    <script type="text/javascript">
	dojo.require("esri.map");
	dojo.require("dijit.layout.BorderContainer");
	dojo.require("dijit.layout.ContentPane");
	dojo.require("esri.dijit.Popup");

	//basemap menu
	dojo.require("esri.dijit.BasemapGallery");
	dojo.require("dijit.form.Button");
	dojo.require("dijit.Menu");

	//tools
	dojo.require("esri.toolbars.navigation");
	dojo.require("dijit.Toolbar");

	var layer, map, visible = [];
	var identifyTask,identifyParams;
	var basemapGallery;

	function disableEnterKey(e)
	{
		 var key;     
		 if(window.event)
			  key = window.event.keyCode; //IE
		 else
			  key = e.which; //firefox
		 return (key != 13);
	}
			
	function init() 
	{
		var initExtent = new esri.geometry.Extent({"xmin":-13349000,"ymin":3983000,"xmax":-12980000,"ymax":4146000,"spatialReference":{"wkid":102100}});
		
		//setup the popup window 
		var popup = new esri.dijit.Popup({
			fillSymbol: new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,0,0]), 2), new dojo.Color([255,255,0,0.25]))
		}, dojo.create("div"));	
	
		map = new esri.Map("map",{
			infoWindow:popup,
			basemap: "topo",
			center: [-118.29044,34.26953],
			zoom: 9
			//extent:initExtent
		});

		//basemaps		
		basemapGallery = new esri.dijit.BasemapGallery({
			showArcGISBasemaps: true,
			map: map
		});

		dojo.connect(basemapGallery,"onLoad",function(){
			dojo.forEach(basemapGallery.basemaps, function(basemap) {            
				//Add a menu item for each basemap, when the menu items are selected
				dijit.byId("basemapMenu").addChild(new dijit.MenuItem({
					label: basemap.title,
					onClick: dojo.hitch(this, function() {
						this.basemapGallery.select(basemap.id);
					})
				}));
			});
		});
		//end
		
		dojo.place(popup.domNode,map.root);      
		dojo.connect(map,"onLoad",mapReady);

		layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://egis3.lacounty.gov/arcgis/rest/services/DPW/rweflood/MapServer",{opacity:.75});
		map.addLayer(layer);

		//resize the map when the browser resizes - 'Resizing and repositioning the map' 
		//more details http://help.esri.com/EN/webapi/javascript/arcgis/help/jshelp_start.htm#jshelp/inside_guidelines.htm
		var resizeTimer;
		dojo.connect(map, 'onLoad', function(theMap) {
			dojo.connect(dijit.byId('map'), 'resize', function() {  //resize the map if the div is resized
				clearTimeout(resizeTimer);
				resizeTimer = setTimeout( function() {
				map.resize();
				map.reposition();
				}, 500);
			});
		});
	}
	
	function updateLayerVisibility() 
	{
		var inputs = dojo.query(".list_item"), input;
		//in this application layer 0 is always on (dummy layer)
		visible = [2];
		for (var i=0, il=inputs.length; i<il; i++) 
		{
			if (inputs[i].checked) 
			{
				visible.push(inputs[i].id);
			}
		}
		//if there aren't any layers visible set the array value to = -1
		if(visible.length === 0) 
		{
			visible.push(-1);
		}

		layer.setVisibleLayers(visible);
		mapReady();	//recheck which layers are active/toggled on
	}

	function mapReady(map)
	{
		//map.infoWindow.resize(250,200);
		dojo.connect(map,"onClick",executeIdentifyTask);

		//create identify tasks and setup parameters 
		identifyTask = new esri.tasks.IdentifyTask("http://egis3.lacounty.gov/arcgis/rest/services/DPW/rweflood/MapServer");
 
		var getID = "2"; //dummy point
		if (document.getElementById("0").checked == true) {getID += ", " + 0;} //rw map

		identifyParams = new esri.tasks.IdentifyParameters();
		identifyParams.tolerance = 3;
		identifyParams.returnGeometry = true;
		identifyParams.layerIds = [ getID ];
		identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;

		//resize the map when the browser resizes - view the 'Resizing and repositioning the map' section
		//details http://help.esri.com/EN/webapi/javascript/arcgis/help/jshelp_start.htm#jshelp/inside_guidelines.htm
		dojo.connect(dijit.byId('map'), 'resize', function() {  //resize the map if the div is resized
			clearTimeout(resizeTimer);
			resizeTimer = setTimeout( function() {
				map.resize();
				map.reposition();
			}, 500);
		});
	}

	function executeIdentifyTask(evt) 
	{
		identifyParams.geometry = evt.mapPoint;
		identifyParams.mapExtent = map.extent;
 
		var deferred = identifyTask.execute(identifyParams);
		var content = "";

		deferred.addCallback(function(response) {     
			//response is an array of identify result objects    
			//Let's return an array of features.
			return dojo.map(response, function(result) {
				var feature = result.feature;
				feature.attributes.layerName = result.layerName;
				if(result.layerName === 'DPW.Flood_Right_of_Way_Map')
				{
					console.log(feature.attributes.R_W_MAP_NO);
					content = "this is a test"
					var template = new esri.InfoTemplate("RW Map", content);
					feature.setInfoTemplate(template);
				}
				return feature;
			});
		});

		//InfoWindow expects an array of features from ea deferred object you pass. If response from the task execution above is not an 
		//array of features, then need to add callback like the one above to post-process the response and return an array of features.
		map.infoWindow.setFeatures([ deferred ]);
		map.infoWindow.show(evt.mapPoint);
	}

	dojo.addOnLoad(init);
    </script>
</head>

<body class="claro">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<table width="100%">					
					<tr>					
						<td>
							<div id="layers">
								<input type='checkbox' class='list_item' id='0' value=0 onclick='updateLayerVisibility();' checked/><img src="images/RW.gif" alt="RW image">&nbsp;RW Map No<br>
								<input type='checkbox' class='list_item' id='1' value=1 onclick='updateLayerVisibility();' /><img src="images/TG.gif" alt="TG image">&nbsp;TG Page<br>
							</div><br>
						</td>
					</tr>
				</table>		
			</td>
			<td valign="top" width="68%">
				<div id="map" class="claro" style="border:0px solid #000;"></div>
				<div style="position:absolute; right:20px; top:75px; z-Index:99; font-size: 9.5pt;">
					<button id="dropdownButton" label="Basemaps"  dojoType="dijit.form.DropDownButton">
						<div dojoType="dijit.Menu" id="basemapMenu" style="font-size: 9.5pt;">
							<!--The menu items are dynamically created from basemaps-->
						</div>
					</button>
				</div>
			</td>
		</tr>
	</table>
	<script>
		var mapDivHeight=screen.height-300;
		document.getElementById("map").style.height=mapDivHeight+"px";
	</script>		
</body>
</html>
