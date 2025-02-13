const axios = require('axios');
const token = 'ya29.c.c0ASRK0Gb8yQnbz1V3wJeiuUZsOkdiHozL99N93H0KuQSYmrbEUliw4CYjtmCSueZzNgdaqqU8uaFhor0IXw79lKf_Pw3M0xfl3hTmxmboy575WMx-97nYrPZiSWzZh1hN60-tZVX6fJzJRoy7dRTG285SOKQsb4Oh1bpsZ_DURGo9_buwIyjJyz7SRsKLzsPN05h7j6kv4wPy4HdY6VgZFmJldrp_GCnmlnDDQcvgeGTAhOt64vtjVFrq7YrPZiSWzZh1hN60-tZVX6fJzJRoy7dRTG285SOKQsb4Oh1bpsZ_DURGo9_buwIyjJyz7SRsKLzsPN05h7j6kv4wPy4HdY6VgZFmJldrp_GCnmlnDDQcvgeGTAhOt64vtjVFrq7krzuiRMV2XksJmITI1gkERDFbg8ZENLi_FDta3UsW51wOvJjoA614wVruxPATdjxqy7YX6zy9SYhreyiVlnJVenvBdVv0tHyzEkmQjdCFS8CQKswiRcl7QRDMQ5fxnrN385CtMkrzuiRMV2XksJmITI1gkERDFbg8ZENLi_FDta3UsW51wOvJjoA614wVruxPATdjxqy7YX6zy9SYhreyiVlnJVenvBdVv0tHyzEkmQjdCFS8CQKswiRcl7QRDMQ5fxnrN385CtM0BJ36k_VbqUXbV4zZv_6O54gmBwFv1lr9OebdQWtauB4p9ygyo7qI10Q3hIwi7nkVtZu6f9Yo_te3FmXeW9bif1YWdQxOS1xfmMb1ijdFM1chYF-xznIWntawg9Mts-sgi66BnqOZceWoh4syeWzB-kzB42pbFRQ8mV7-hzF--xi3vVI2J57YBBBmtOjZ9nk03yZBhORO3JwZOfuz3MhqcpWjxZ3dV0Q4cgUdvrfp624mxckZowvs7BbtS_X4OtcU9Zmybn3Fd2qqOZceWoh4syeWzB-kzB42pbFRQ8mV7-hzF--xi3vVI2J57YBBBmtOjZ9nk03yZBhORO3JwZOfuz3MhqcpWjxZ3dV0Q4cgUdvrfp624mxckZowvs7BbtS_X4OtcU9Zmybn3Fd2q6h6sVdgb6-_JcatQzWp-asBcYo-FYnbYdvcQ00Qv_SIi-gxinUu8qUqWVciSr5OS9clzaZ64e-8maSlhZXhUsnx7dzzp93xcp3lv3RRUd_VRZWcit82Jy_W_v91vvMV675607gf9Qx0k2XI85V1j4yjog4bprVntQb7vdUXkmn0wU2F0XmMig4f8yFhbfvujpOyzbJ0vUxBddQJ69vgwvcgn4UrZjrsma3sSVwcmwcSgF5pdWoznpQytloxImc8OSspvu5cVwueQxmwZt7fuaY1qFoSQMYZijqOQ3d7WcZdSh1oQuJpcm09dmff2RtXeeVmbaXybjjFRogRiuy40daoi5J5hR74Bl76Oy1WtVk3s';
const url = 'https://fcm.googleapis.com/v1/projects/blood-donation-applicati-30737/messages:send';

const messagePayload = {
    message:{
        topic:'all devices',
        notification: {
            title:"Broadcast Notification",
            body: "This message is sent to all devices!"
        },
        android:{
            priority: "high",
            notification:{
                channel_id:"high_importance_channel"
            }
        }
    }
};


const header= {
    'Authorization': `Bearer ${token}`,
    'Content-type': 'application/json'
};

axios.post(url,messagePayload,{header}).then(response=>{console.log('Message set successfully:',response.data);}).catch(error=>{console.error('Error Sending Messages:',error.response ? error.response.data:error.message);
});