/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Import the Firebase SDK for Google Cloud Functions.
const functions = require("firebase-functions");

// Import and initialize the Firebase Admin SDK.
const admin = require("firebase-admin");
admin.initializeApp();

// Triggers when a notification is added to
// '/users/{uid}/notifications'
exports.sendNewChallengeNotification = functions.firestore
    .document("/users/{uid}/notifications/{docId}")
    .onCreate(async (snap, context) => {
      const newUid = context.params.uid;
      console.log(`To userr: ${newUid}`);

      // Get notification data
      const doc = snap.data();
      const receiverId = doc.receiver;
      const senderId = doc.sender;

      // Get token
      const userDoc = await admin.firestore().collection("users")
          .doc(receiverId).get();
      const token = userDoc.data().fcmToken;
      if (token == "") {
        console.log(`User fcmToken empty: ${receiverId}`);
        return;
      }
      console.log(`To token: ${token}`);

      // Notification body
      const payload = {
        token: token,
        notification: {
          title: "New Challenge!",
          body: senderId + " challenged you",
        },
      };

      // Send message
      await admin.messaging().send(payload)
          .then((response) => {
            // Response is a message ID string.
            console.log("Successfully sent message: ", response);
          })
          .catch((error) => {
            console.log("Error sending message: ", error);
          });
    });
