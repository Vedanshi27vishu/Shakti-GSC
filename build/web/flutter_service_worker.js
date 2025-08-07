'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "ba5a5f41428084046ff7cb6243b7cb37",
"assets/AssetManifest.bin.json": "700a84e4d6a2d1c282a16069fdcc1cd5",
"assets/AssetManifest.json": "878bf2ffaca756bcdb40dc158f5462cd",
"assets/assets/%25E2%2580%2594Pngtree%25E2%2580%2594cutting-edge%2520ai%2520robot%2520displaying%2520seo_20858701.png": "5ed59c91930390540cbff7ceb2957be3",
"assets/assets/3D%2520Business%2520GIF%2520by%2520L3S%2520Research%2520Center.gif": "3ed8fcd152be6ec081b3387153af634f",
"assets/assets/arrow.png": "b141709cc6955ee73f81d8542882c3af",
"assets/assets/flowchart%2520(1).png": "15ead9651bd4f57761b0845767f8f171",
"assets/assets/Image1.png": "40207404ded4c01242a66d84c82589e5",
"assets/assets/images/1750482628529.jpeg": "310f088b03837150c1ea59d1d4392b8a",
"assets/assets/images/Aikansh.jpg": "a744bc01d169e687dd6deed2c26918df",
"assets/assets/images/arrow%2520(1).png": "0333d7169a45ecdef7da333d943a0c92",
"assets/assets/images/dishablack.png": "e422bfd8469d43a54080c1b68cbbb44e",
"assets/assets/images/dishawhite.png": "4da5847d206ff3860c1535dc0b5b9ed2",
"assets/assets/images/doc.png": "b4f9f7766cc993b265ac152f1f537c69",
"assets/assets/images/famicons_person-outline.png": "412f4839cd8a4198c3cb8da3cae3f442",
"assets/assets/images/flowchart.png": "08aaa164c7da91a3a3fabcb4947a31dc",
"assets/assets/images/fluent_people-community-16-regular.png": "bb2ea4504d0e881ceda2fed11191e92f",
"assets/assets/images/Google.png": "76da3f5249d24e17d244c2dbb66d8f19",
"assets/assets/images/Group%2520(3).png": "022da8781e64838462030e3fabe93a64",
"assets/assets/images/image%252020.png": "cc222b39b0284ebc6d8e6a445ae6bf1b",
"assets/assets/images/mdi_circle-double.png": "ed8dea5c508f05c089046a208e75411c",
"assets/assets/images/newwallet.png": "4304ae7c3364fa310573aff18fc5066c",
"assets/assets/images/raphael_piechart.png": "4480baabd0f856788486eddfdd9000b8",
"assets/assets/images/rupees.png": "e463b33caf1e5ae2b69b359024730c83",
"assets/assets/images/rupeesyellow.png": "dbcf4c10ec4ceb917631fc712d115b49",
"assets/assets/images/Vector%2520(2).png": "c36600df9118a90d40d985a1449b7c34",
"assets/assets/images/Vector%2520(3).png": "84448514ca83581c2fd1b4a151c66f54",
"assets/assets/images/Vector%2520(4).png": "05c76cbc81e3f7db9e13f50108f7246f",
"assets/assets/images/Vector%2520(5).png": "f101caca4a29474a053f05de36dd2744",
"assets/assets/images/Vector%2520(6).png": "7b253a3d6b21d84ee72f0c113429b09f",
"assets/assets/images/Vector-1.png": "9ad6a59da09f1c2a33ea5b369336cfcd",
"assets/assets/images/video.png": "a0c57f7ae32bb47097dc36556f452d7d",
"assets/assets/images/wallet.png": "4304ae7c3364fa310573aff18fc5066c",
"assets/assets/images/yellowcommunity.png": "bc6b7172981eb3f0e796e6d959bc19dd",
"assets/assets/logo.png": "59971db1049f4281c3573b12dca576d5",
"assets/assets/logonew.png": "a4bb2ef20d57b5bc677ed7c335779424",
"assets/assets/portfolio.png": "1284eb9acaf86aed718898debdd02fcf",
"assets/assets/presentation.png": "9b0f72ba5d897c7500fc972eb328caaf",
"assets/assets/Progress.png": "c7622bcb0f53021dc904873d2cdd0b68",
"assets/assets/rupees.png": "cb99ded47946b989222d1b0b18d12478",
"assets/assets/video%2520(1).png": "5229132bda4b3f230bd6e833174ed730",
"assets/assets/video-editing.png": "d310850759c26514c1996322e91c3bbb",
"assets/assets/video1.png": "db1aed9a2bf5928847d07fb067173366",
"assets/assets/video2.png": "15797cae52c9819e082811ae991fea01",
"assets/assets/video3.png": "3f73992fec22c924b798745ff21fbaa1",
"assets/assets/video4.png": "ce6074225b82c03a4e93986db3adc7c3",
"assets/assets/video5.png": "9b28f377d90ea6ffe92ccbe82463837a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "2aa3018b3866a492f9a0c81060522036",
"assets/NOTICES": "787a3246fe2babd3271d52a4ad0b1db8",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
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
"flutter_bootstrap.js": "0ccd7124d73cc769fc5c70cf68bbd377",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "51774cccec4cb62125baff8019c6c214",
"/": "51774cccec4cb62125baff8019c6c214",
"main.dart.js": "06f30fb60777aba372a0161ed055bac5",
"manifest.json": "611b25d39440b4c5a578a400b87cbd85",
"version.json": "cb4bb67624262c039f9d471ed41a4ff4"};
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
