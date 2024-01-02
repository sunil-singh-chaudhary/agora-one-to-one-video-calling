import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:test_agora/AgoraEventHandler.dart';
import 'package:test_agora/Agrommanager.dart';
import 'package:test_agora/cohost_screen.dart';

import 'Dashboard.dart';
import 'host_screen.dart';

String testAppIDagora = '4f207f0bf8ad46ed89963c98bce3a8db';
String testchannelname = 'raj';
String tempToken =
    '007eJxTYJj89lRMhbbnr21bF+7s/CKneG3a3/69B/rqzQpfnw7X2K6swGCSZmRgnmaQlGaRmGJilppiYWlpZpxsaZGUnGqcaJGSpDl/UmpDICNDwok+JkYGCATxmRmKErMYGAApFCJJ';

class OneToOneLiveScreen extends StatefulWidget {
  const OneToOneLiveScreen({super.key});

  @override
  State<OneToOneLiveScreen> createState() => OneToOneLiveScreenState();
}

class OneToOneLiveScreenState extends State<OneToOneLiveScreen> {
  late RtcEngine agoraEngine; // Agora engine instance
  int conneId = 0;
  late AgoraEventHandler agoraEventHandler;
  ValueNotifier<bool> isMuted = ValueNotifier(false);
  ValueNotifier<bool> isImHost = ValueNotifier(false);
  final dragController = DragController();
  ValueNotifier<bool> isJoined = ValueNotifier(false);
  ValueNotifier<int?> remoteUid = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    initagora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
      valueListenable: isJoined,
      builder: (BuildContext context, bool isJoin, Widget? child) =>
          ValueListenableBuilder(
        valueListenable: isImHost,
        builder: (BuildContext context, bool meHost, Widget? child) => Stack(
          children: [
            //BOTTOM BAR MUTE CALL DISCONNECT SPEAKER

            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 10.h,
                width: 100.w,
                child: Row(children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: SizedBox(
                        height: 10.h,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              isMuted.value = !isMuted.value;
                              // int volume = isMuted.value ? 0 : 100;

                              // log('Volume Audio is $volume');
                              // AgoraManager().muteVideoCall(
                              //   volume,
                              //   agoraEngine,
                              // );
                            },
                            child: ValueListenableBuilder(
                              valueListenable: isMuted,
                              builder: (BuildContext context, bool meMuted,
                                      Widget? child) =>
                                  CircleAvatar(
                                radius: 3.h,
                                backgroundColor:
                                    meMuted ? Colors.black12 : Colors.black38,
                                child: FaIcon(
                                  meMuted
                                      ? FontAwesomeIcons.microphoneSlash
                                      : FontAwesomeIcons.microphone,
                                  color: meMuted ? Colors.blue : Colors.white,
                                  size: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: SizedBox(
                        height: 10.h,
                        child: InkWell(
                          onTap: () {
                            AgoraManager().leave(
                              agoraEngine,
                              onchannelLeaveCallback: (isLiveEnded) {
                                if (isLiveEnded) {
                                  //LIVE SESSION ENDED GOTO PREVIOUS SCREEN
                                  Future.delayed(
                                    Duration.zero,
                                    () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Dashboard(),
                                          ));
                                    },
                                  );
                                } else {
                                  log('live not ended');
                                }
                              },
                            );
                          },
                          child: SizedBox(
                            width: 100.w,
                            height: 6.h,
                            child: Center(
                              child: CircleAvatar(
                                radius: 3.h,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 10.h,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: CircleAvatar(
                            radius: 3.h,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //IS USER JOINED LAYOUT
                  isJoin
                      ? SizedBox(
                          width: double.infinity,
                          height: 80.h,
                          child: CoHostWidget(
                              remoteUid: remoteUid.value,
                              agoraEngine: agoraEngine),
                          //CO-HOST VIDEO
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amberAccent,
                          ),
                        )
                ],
              ),
            ),
            //IS IM HOST YES
            meHost
                ? HostWidget(localid: conneId, agoraEngine: agoraEngine)
                : Center(
                    child: Text('Im host-->s $meHost'),
                  ),
          ],
        ),
      ),
    ));
  }

  void handler() {
    agoraEventHandler.handleEvent(agoraEngine);
  }

  void initagora() async {
    agoraEngine = await AgoraManager().initializeAgora(testAppIDagora);
    AgoraManager().joinChannel(tempToken, testchannelname, agoraEngine);

    agoraEventHandler = AgoraEventHandler(
      onJoinChannelSuccessCallback: (isHost, localUid) {
        isImHost.value = isHost;
        conneId = localUid!;
        setState(() {});
        log('Local ID-> $localUid');
      },
      onUserJoinedCallback: (remoteId, isJoin) {
        isJoined.value = isJoin!;
        remoteUid.value = remoteId;
      },
      onUserMutedCallback: (remoteUid3, muted) {
        log('Is muted->  $muted');
        // isMuted.value = muted!;  this is user mute not host
        //! working on mute unmute then speaker on off then camer back fron
        if (remoteUid.value == remoteUid3) {
          if (muted == true) {
            isImHost.value = true;
            log('isimHost in onUserMuteVideo muted $isImHost');
          } else {
            isImHost.value = true;
            log('isimHost in onUserMuteVideo mutede else $isImHost');
          }
        }
      },
      onUserOfflineCallback: (id, reason) {
        debugPrint("User is Offiline reasion is -> $reason");
        remoteUid.value = null;
      },
      onUserLeaveChannelCallback: (con, sc) {
        debugPrint("onLeaveChannel called${con.localUid}");
        isJoined.value = false;
        remoteUid.value = null;
      },
      onAgoraError: (err, msg) {
        log('error agora - $err  and msg is - $msg');
      },
    );

    handler();
  }
}
