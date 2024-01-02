import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraManager {
  static final AgoraManager _instance = AgoraManager._internal();
  factory AgoraManager() {
    return _instance;
  }

  AgoraManager._internal();

  Future<RtcEngine> initializeAgora(String appID) async {
    await [Permission.microphone, Permission.camera].request();
    //create an instance of the Agora engine
    RtcEngine agoraEngine = createAgoraRtcEngine();
    try {
      await agoraEngine.initialize(RtcEngineContext(appId: appID));
      log('init agora appID- $appID ');
    } catch (e) {
      log(e.toString());
    }
    return agoraEngine;
  }

  void joinChannel(
      String token, String channelName, RtcEngine agoraEngine) async {
    log('join-channel');
    ChannelMediaOptions options;
    // Set channel profile and client role ONE TO ONE VIDEO CALL
    options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await agoraEngine.startPreview();
    await agoraEngine.enableVideo();

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid:
          2, //UNIQUE for second user can be 1 or 0  canvas canvas: const VideoCanvas(
      //Put it same for both like 0 for both but dont use  0 then in hostscreen
    );
  }

  void leave(RtcEngine agoraEngine,
      {required void Function(bool isLiveEnded) onchannelLeaveCallback}) async {
    try {
      await agoraEngine.leaveChannel();
      await agoraEngine.release();
      onchannelLeaveCallback(true);
    } on Exception catch (e) {
      log('Exception leaving channel-> $e.toString()');
      onchannelLeaveCallback(false);
    }
  }

  void muteVideoCall(
    int volume,
    RtcEngine agoraEngine,
  ) async {
    try {
      agoraEngine.adjustAudioMixingVolume(volume);
      agoraEngine.adjustPlaybackSignalVolume(volume);
    } catch (e) {
      log(e.toString());
    }
  }
}
