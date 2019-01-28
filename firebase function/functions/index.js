const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!Sen-da");
});


exports.observerFollowing = functions.database.ref('/Follows/{userid}/{followingId}').onCreate((snapshot,event) => {
	
		const original = snapshot.val();
		var uid = event.params.userid;
		var followingId = event.params.followingId;
		
		console.log('User: ', uid, 'is following ', followingId);
		
		return admin.database().ref('/Users/' + followingId).once('value',snapshot => {
			
				var userWeAreFollowing = snapshot.val();
				
			return admin.database().ref('/Users/' + uid).once('value',snapshot =>{
				
					var userDoingTheFollowing = snapshot.val();
				
					
					var registrationToken = userWeAreFollowing.fcmToken;
					
					// See documentation on defining a message payload.
					var message = {
						
						notification: {
					    title: 'You now have a new follower.',
					    body: userDoingTheFollowing.userName + 'is now following you'
					  },
					  data: {
							followerId:uid,
					    score: '850',
					    time: '2:45'
					  },
					  token: registrationToken
					};
					
					// Send a message to the device corresponding to the provided
					// registration token.
					admin.messaging().send(message)
					  .then((response) => {
					    // Response is a message ID string.
					    console.log('Successfully sent message:', response);
							 return null;
					  })
					  .catch((error) => {
					    console.log('Error sending message:', error);
					  });
			
			});
			
		});
	
	
});

exports.sendPushNotifications = functions.https.onRequest((request, response) => {
 response.send("Attempting to send push notification...");
 console.log('Logger----')

// This registration token comes from the client FCM SDKs.
var registrationToken = 'fnBzJtkAaSs:APA91bEtRVeaRMP1dWtZThVkgnOUIwvyis9JNAY0uU8Xr6M62T7wjG3PlpJa5V3odA6gGuAHoUzdL7GpKN0xSr36rq1wgbdAbYRcSGW5gspRftRtfLwW33S6eqB6f9_aX-XW8HIW0nXz';

// See documentation on defining a message payload.
var message = {
	
	notification: {
    title: '$GOOG up 1.43% on the day',
    body: '$GOOG gained 11.80 points to close at 835.67, up 1.43% on the day.'
  },
  data: {
    score: '850',
    time: '2:45'
  },
  token: registrationToken
};

// Send a message to the device corresponding to the provided
// registration token.
admin.messaging().send(message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
		 return null;
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });
 
});