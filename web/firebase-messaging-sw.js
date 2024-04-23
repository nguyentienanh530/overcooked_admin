importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');


const firebaseConfig = {
    apiKey: 'AIzaSyC-Hvr2eMGEkWvEMhhfmjed_KOR2bWP6dY',
    appId: '1:83984534471:web:9570d85afcac26d98827e2',
    messagingSenderId: '83984534471',
    projectId: 'overcooked-d5f12',
    authDomain: 'overcooked-d5f12.firebaseapp.com',
    storageBucket: 'overcooked-d5f12.appspot.com',
    measurementId: 'G-S3H5J0DSYH',
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();


messaging.onBackgroundMessage(function (payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});