import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'onetooneVideo.dart';

class CoHostWidget extends StatelessWidget {
  const CoHostWidget({
    super.key,
    required this.remoteUid,
    required this.agoraEngine,
  });

  final int? remoteUid;
  final RtcEngine agoraEngine;

  @override
  Widget build(BuildContext context) {
    if (remoteUid != null) {
      debugPrint('remote id from _videoPanelForCoHost:- $remoteUid');
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: remoteUid), //Remote User ID placed here
          connection: RtcConnection(channelId: testchannelname),
        ),
      );
    } else {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          'Astrologer not  join..,',
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
