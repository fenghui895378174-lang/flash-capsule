// FlashCapsule Service Worker - 离线缓存 & 后台通知支持
const CACHE_NAME = 'flashcapsule-v1';
const ASSETS = [
  './index.html',
  './manifest.json'
];

// 安装：缓存核心文件
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});

// 激活：清理旧缓存
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

// 请求拦截：缓存优先策略
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(cached => cached || fetch(event.request))
  );
});

// 后台通知（当页面不可见时）
self.addEventListener('notificationclick', event => {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window' }).then(clientsList => {
      if (clientsList.length > 0) {
        clientsList[0].focus();
      } else {
        clients.openWindow('./index.html');
      }
    })
  );
});
