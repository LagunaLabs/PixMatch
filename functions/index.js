const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  let msg = request.query.hello;//"<h1>Hello from Firebase!</h1> <p>This is a paragraph </p>";
 //response.send("<h1>Hello from Firebase!</h1> <p>This is a paragraph </p>");
 response.send(msg);
});

exports.retrieveCredentials = functions.https.onRequest((req, res) => {
  let html = req.query.markup;
  res.send(html);
});

exports.logout = functions.https.onRequest((req, res) => {
  let msg = req.query.status;
  res.send(msg);
});
