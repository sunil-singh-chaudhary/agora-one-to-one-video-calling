import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HostWidget extends StatelessWidget {
  final int localid;
  const HostWidget({
    required this.localid,
    super.key,
    required this.agoraEngine,
  });

  final RtcEngine agoraEngine;

  @override
  Widget build(BuildContext context) {
    // Local user joined as a host
    return SizedBox(
      height: 40.h,
      width: 30.w,
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(
            uid: 0, //Put it same for both like 0 for both but dont use  0 then in hostscreen 
          ),
        ),
      ),
    );
  }
}
