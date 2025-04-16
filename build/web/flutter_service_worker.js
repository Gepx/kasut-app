'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "e60c05682a14fde79b6b0cff2f2b12ef",
"assets/AssetManifest.bin.json": "f3ac979539f81e85a2e13f4692322774",
"assets/AssetManifest.json": "93c73c4de589838f8e73fa9cbd6ac6eb",
"assets/assets/blog/content.png": "a945e60087895eedb7eab87aae7f4c93",
"assets/assets/blog/content2.png": "601e524e0825714abc937de8d68e0456",
"assets/assets/blog/profile.png": "80cc5b2f7b1ad1eeba3e647862a54b65",
"assets/assets/brand-products/adidas/Adidas-Adifom-Climacool-Wonder-Beige.png": "43aeb59134ad82035d27313d2388a760",
"assets/assets/brand-products/adidas/Adidas-Adifom-Supernova-Core-Black.png": "ee514662f9cefb0eba562cfaec43a65e",
"assets/assets/brand-products/adidas/Adidas-Adilette-Slides-Off-White.png": "c09d85dc2748d695e304819de46772ec",
"assets/assets/brand-products/adidas/Adidas-Adistar-Cushion-Song-for-the-Mute-Simple-Brown.png": "fc2fd36a73213c4bcc87d691120b199c",
"assets/assets/brand-products/adidas/Adidas-Adizero-Prime-x-Strung-Black-Spark.png": "78ebcb3cdad3a7614d40ee66d8f07ddd",
"assets/assets/brand-products/adidas/Adidas-Gazelle-CLOT-Linen-Khaki.png": "91c62c4ae1cbd74f8479142b2d68a950",
"assets/assets/brand-products/adidas/Adidas-Handball-Spezial-Core-Black-Leather.png": "99ec76475d1c052731c658bb7b57e8c2",
"assets/assets/brand-products/adidas/Adidas-Handball-Spezial-Suede-Grey.png": "a11b7038d13de2a9d7f7d23fbc137c23",
"assets/assets/brand-products/adidas/Adidas-Harden-Vol.-McDonalds-All-American.png": "21a3d92defa03847de191f308bcc5973",
"assets/assets/brand-products/adidas/Adidas-NMD-Hu-Pharrell-Solar-Pack-Orange.jpeg": "409c6f3b443f75cb647f4aeaa7f39c41",
"assets/assets/brand-products/adidas/Adidas-NMD-R-Core-Black-Red.png": "4eae12cf43bc7c7b309dcd7fa2cb1c56",
"assets/assets/brand-products/adidas/Adidas-Rivalry-Low-Hikari-Shibata-Light-Solid-Grey.png": "862a9236ad88edb8e7786e74475e8fa5",
"assets/assets/brand-products/adidas/Adidas-Samba-Nylon-Wales-Bonner-Core-Black.png": "639f295f4b7e642805a29b9f7219da0b",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-Black-Wonder-Quartz-Ribbon-(Women's).png": "2498b557f3d08be0c8a4f3ade4af8162",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-Cloud-White-Core-Black.png": "abd6ea6bc3895d287900045c1355f79f",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-JJJJound-Mesa.png": "9525dcb033ad56125b3ab2e59183d2fb",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-Maroon-(Women).png": "ef4dbf69c055c37d6dee3b99af69704f",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-Mineral-Green-(Women).png": "d3fdd2743faeb2f08ed74eda5337b40d",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-Off-White.png": "02c92c85d298c4991dcc11eac7017061",
"assets/assets/brand-products/adidas/Adidas-Samba-OG-Vegan-Black.png": "bd0980431060a7653183a550b924414c",
"assets/assets/brand-products/adidas/Adidas-SL-RS-Bob-Marley-One-Love.png": "6fbcb3c316a5a00a67eab5814c34076b",
"assets/assets/brand-products/adidas/Adidas-SL-RS-Wonder-Aluminum.png": "f8c7230c2c54d609d488b5d107315b7e",
"assets/assets/brand-products/adidas/Adidas-Supernova-Core-Black.png": "45918c13a88dbc853fb291ec5b4555b4",
"assets/assets/brand-products/adidas/Adidas-Ultra-Boost-Parley-Tech-Ink-(Women).jpeg": "2608568da1d1d7f031cb9b62494a95b5",
"assets/assets/brand-products/adidas/Adidas-Yeezy-Slide-Granite.png": "24dac2367f2038400cfbaad7235c1127",
"assets/assets/brands/adidas.png": "bc23f7fa4ca74a692a73a9571714a8f0",
"assets/assets/brands/mizuno.png": "3d2633723c3d8d7cef33adead3abf6b4",
"assets/assets/brands/new_balance.png": "21585c11182d49083fc3739f92aaeafa",
"assets/assets/brands/nike.png": "5f9f67753cb4329ad2b910bb99bc15af",
"assets/assets/brands/oncloud.png": "987e8531c6f915c8a0ca53c8d57280d4",
"assets/assets/brands/ortuseight.png": "506ce4a64c378e0aa11c033c5cb7238d",
"assets/assets/brands/puma.png": "cf55a5edbc2041aca4bf5ecdfdb04abd",
"assets/assets/brands/specs.png": "d83c18fd4b764b6d964c78b20d99ca92",
"assets/assets/brands/under_armour.png": "2d494b6220172a570fa268aaeebff4a2",
"assets/assets/home/airjordan.png": "5927b9cfd7b178254ed6a61974d3c8c6",
"assets/assets/home/arrivals.png": "abb88698f59553323d92cf320a79abaa",
"assets/assets/home/asics.png": "8682b2022a468e370f6ae4a489e5eca8",
"assets/assets/home/kids.png": "f5fda20bd3ab95bc92cd5fd458bfc2b4",
"assets/assets/home/mens.png": "be51e1d4d66a9500bb7e27d06ecd0bea",
"assets/assets/home/oncloud.png": "a30a5bb9a896423e2b210eaa244cff10",
"assets/assets/home/samba.png": "a282676629505230ea23833a4aa01987",
"assets/assets/home/womens.png": "bf3325cec531191a998cf4ddf1abba28",
"assets/assets/seller/indonesia_flag.png": "0dfbf866b9e697a5d02ce0756733ceda",
"assets/FontManifest.json": "3c6f2aec284ba6e927fd5e00fb6c4257",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "9f1d2f6ee05249d093af76e1c61b942a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "8d74b65701eef5d700659bca8aec18f8",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "2735409840435e6ad89eb7b911205454",
"/": "2735409840435e6ad89eb7b911205454",
"main.dart.js": "8b0f966ab7a4078f4fe127721c710de7",
"manifest.json": "14ffc513e14229b712fc9ba9f448c149",
"version.json": "504916fd8f03f1d47846a6095c58d3a0"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
