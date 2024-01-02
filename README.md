# test_agora

A new Flutter project.

## GOTO AGORA CONSOLE

1. https://console.agora.io/

Click on config project and get your project APP_ID and Generate Temporary Token paste it into the
Project ,
Tokens are valid only for one day

How to use For one to one calling
run this project first on a device then again change only change id here it should be unique for both devices

```
await agoraEngine.joinChannel(
  token: token,
  channelId: channelName,
  options: options,
  uid: 2, // UNIQUE for the second user, can be 1 or 0 (canvas)
);
```
