const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(require("./serviceaccount.json")),
});

async function sendNotification(tokens, title, body) {
    if (!tokens || tokens.length === 0) return;

    const message = {
        notification: {
            title: title,
            body: body,
        },
        tokens: tokens, // Correct placement for multicast
    };

    try {
        const response = await admin.messaging().sendEachForMulticast(message);
        console.log("Notifications sent successfully:", response);
    } catch (error) {
        console.error("Error sending notifications:", error);
    }
}

// Example Usage (Replace with actual FCM tokens)
sendNotification(
    fcmToken,
    "Urgent Blood Request",
    "A nearby patient needs your blood group. Please donate!"
);
