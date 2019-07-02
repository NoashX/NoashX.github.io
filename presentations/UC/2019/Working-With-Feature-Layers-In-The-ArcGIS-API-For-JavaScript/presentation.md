<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-1.png" -->

<h1 style="text-align: left; font-size: 80px;">Working with Feature Layers</h1>
<h2 style="text-align: left; font-size: 60px;">in the ArcGIS API for JavaScript</h2>
</br>
<p style="text-align: left; font-size: 30px;">Yann Cabon | Noah Sager</p>
    <p style="text-align: left; font-size: 30px;">slides: <a href="https://git.io/fhp4D"><code>https://git.io/fhp4D</code></a></p>

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-2.png" -->

## Agenda

</br>

* Types of feature layers
* Visualization styles
* Labeling 
* Popups
* Querying
* Editing features

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Feature Layer powered by

* [Feature Services](https://developers.arcgis.com/javascript/latest/sample-code/layers-featurelayer/index.html)
* [Feature Collections](https://developers.arcgis.com/javascript/latest/sample-code/layers-featurelayer-collection/index.html)
* [Portal Item](https://developers.arcgis.com/javascript/latest/sample-code/layers-portal/index.html)
* Client side data
  * CSV: [SDK sample](https://developers.arcgis.com/javascript/latest/sample-code/layers-csv-projection/index.html)
  * GeoJSON: [DevSummit Plenary](https://ycabon.github.io/2019-devsummit-plenary/2_geojson.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Bringing a feature layer into your app

* FeatureLayer by URL

```ts
const layer = new FeatureLayer({
  url: "https://<url to my server>/FeatureServer",
  layerId: 0,
  renderer: { ... },
  popupTemplate: { ... },
});

map.add(layer);
```

[Demo](./demos/1_bringing_data/1_byUrl.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Bringing a feature layer into your app

Restrict data retrieved from the feature service

* to work with a subset of features
* to remove features with `null` attributes.

```ts
layer.definitionExpression = "STATE_NAME = 'California'";
```

[Demo](./demos/1_bringing_data/2_byUrl_definitionExpression.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Bringing a feature layer into your app

FeatureLayer by portal item

```ts
const portal = new Portal({
  url: "https://jsapi.maps.argis.com"
});

const layer = new FeatureLayer({
  portalItem: {
    id: "bca022ee5d9440c9b60399ee4d809d9b",
    portal
  }
});

map.add(layer);
```

[Demo](./demos/1_bringing_data/3_byPortalItem.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Bringing a feature layer into your app

Alternative: using `Layer.fromPortalItem()`

```ts
Layer.fromPortalItem({
  portalItem: {
    id: "82d8d8213afc4bb380bb16083735f573"
  }
})
.then((layer) => {
  map.add(layer);
});
```

[Demo](./demos/1_bringing_data/4_byPortalItem_using_fromPortalItem.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Bringing portal feature layer into your app

New in 4.11: Only fields for display requested

```ts
const webmap = new WebMap({
  portalItem: {
    id: "<webmap id>"
  }
});

await webmap.loadAll();

const layer = webmap.allLayers
  .find((layer) => layer.title === "test");

layer.outFields = ["some_field"];
```

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Visualization styles

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Labelling

Label features to show relevant information at a glance

* [Multiline labels](https://developers.arcgis.com/javascript/latest/sample-code/labels-multiline/index.html) 
* [Multiple label classes](https://developers.arcgis.com/javascript/latest/sample-code/labels-multiple-classes/index.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Popups to communicate information

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Query the data from the server

* [queryFeatures()](./demos/3_query/1_query_features.html)
* [queryFeatures() - by distance](./demos/3_query/2_query_features_by_distance.html)
* [queryFeatures() - pagination](./demos/3_query/3_query_features_pagination.html)
* [queryAttachments()](./demos/3_query/4_query_attachments.html)
* [queryRelatedFeatures()](./demos/3_query/5_query_related_features.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-3.png" -->

## Editing

* make edits and stuff

[Demo](./demos/4_client-side_statistics/index.html)

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-2.png" -->

# Questions

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/alias_slide.png" -->

---

<!-- .slide: data-background="../../reveal.js/img/2019/uc/bg-5.png" -->