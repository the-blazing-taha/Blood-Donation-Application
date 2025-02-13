const {GoogleAuth} = require('google-auth-library');
const auth = new GoogleAuth({
    keyFile: './serviceaccount.json',
    scopes: 'https://www.googleapis.com/auth/firebase.messaging'
});
async function getAccessToken(){
    const client = await auth.getClient();
    const accessToken=await client.getAccessToken();
    return accessToken;
}
getAccessToken().then(token =>{
    console.log("Generated OAuth2 Token: ", token);
}).catch(error => console.error('Error generating token:', error));



