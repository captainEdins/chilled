import 'package:cached_network_image/cached_network_image.dart';
import 'package:chilled/holder/main/connectFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chilled/resources/color.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:chilled/resources/string.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';


class Inbox extends StatefulWidget {
  String name, receiverId, senderId, status, type, receiverCode, dp;

  Inbox(
      {super.key,
        required this.name,
        required this.receiverId,
        required this.senderId,
        required this.status,
        required this.receiverCode,
        this.type = "single",
        this.dp = "empty"});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  TextEditingController getMessageText = TextEditingController();
  bool emojiShowing = false;
  int countValue = 0;
  FocusNode inputNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.primary,
      body: WillPopScope(
        //if emojis are shown & back button is pressed then hide emojis
        //or else simple close current screen on back button click
        onWillPop: () {
          if (emojiShowing) {
            setState(() => emojiShowing = !emojiShowing);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ColorList.iconBackground,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: ColorList.white,
                            size: 20,
                          )),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          children: [
                            if (widget.receiverId == Strings.userKemus ||
                                widget.receiverId == Strings.userGPT ||
                                widget.dp == "empty")
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: ColorList.iconBackground,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: Icon(
                                    widget.receiverId == Strings.userKemus ||
                                        widget.receiverId == Strings.userGPT
                                        ? Icons.category_rounded
                                        : Icons.person_rounded,
                                    color: ColorList.white,
                                    size: 20,
                                  ))
                            else
                              CachedNetworkImage(
                                imageUrl: widget.dp,
                                width: 40,
                                height: 40,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: ColorList.white,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    const Text(
                                      "Active Now",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: ColorList.black,
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(
                          CupertinoIcons.phone_circle_fill,
                          color: ColorList.white,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          CupertinoIcons.videocam_circle_fill,
                          color: ColorList.white,
                          size: 35,
                        )
                      ],
                    )
                  ],
                )),
            Positioned(
                top: MediaQuery.of(context).viewPadding.top > 0 ? 90 : 60,
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                color: ColorList.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(40)),
                              ),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('chats')
                                    .where("chatArray", arrayContainsAny: [
                                  widget.senderId + widget.receiverId,
                                  widget.receiverId + widget.senderId
                                ])
                                    .where("type", isEqualTo: widget.type)
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    setState(() {
                                      countValue = snapshot.data!.docs.length;
                                    });
                                  }

                                  print(snapshot.data?.docs.length);

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    reverse: true,
                                    controller: _scrollController,
                                    itemCount: snapshot.hasData
                                        ? snapshot.data?.docs.length
                                        : 0,
                                    itemBuilder: (ctx, index) => bubbleText(
                                      snap: snapshot.data!.docs[index].data(),
                                    ),
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              chatTextField(),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: ColorList.iconBackground,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: ColorList.white,
                                    size: 24,
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  checkIfCanSend();
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: ColorList.iconBackground,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                    ),
                                    child: Icon(
                                      !micCheck ? Icons.mic : Icons.send,
                                      color: ColorList.white,
                                      size: 24,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: !emojiShowing,
                          child: SizedBox(
                              height: 300,
                              child: EmojiPicker(
                                textEditingController: getMessageText,
                                onEmojiSelected: (category, emoji) {
                                  if (getMessageText.text.isNotEmpty) {
                                    setState(() {
                                      micCheck = true;
                                    });
                                  }
                                },
                                config: Config(
                                  columns: 7,
                                  emojiSizeMax: 32 *
                                      (foundation.defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                          ? 1.30
                                          : 1.0),
                                  verticalSpacing: 0,
                                  horizontalSpacing: 0,
                                  gridPadding: EdgeInsets.zero,
                                  initCategory: Category.RECENT,
                                  bgColor: const Color(0xFFF2F2F2),
                                  indicatorColor: ColorList.primary,
                                  iconColor: Colors.grey,
                                  iconColorSelected: ColorList.primary,
                                  backspaceColor: ColorList.primary,
                                  skinToneDialogBgColor: Colors.white,
                                  skinToneIndicatorColor: Colors.grey,
                                  enableSkinTones: true,
                                  recentTabBehavior: RecentTabBehavior.RECENT,
                                  recentsLimit: 28,
                                  replaceEmojiOnLimitExceed: false,
                                  noRecents: const Text(
                                    'No Resents',
                                    style: TextStyle(
                                        fontSize: 20, color: ColorList.primary),
                                    textAlign: TextAlign.center,
                                  ),
                                  loadingIndicator: const SizedBox.shrink(),
                                  tabIndicatorAnimDuration: kTabScrollDuration,
                                  categoryIcons: const CategoryIcons(),
                                  buttonMode: ButtonMode.MATERIAL,
                                  checkPlatformCompatibility: true,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool micCheck = false;

  Widget chatTextField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 1, right: 1),
        child: Container(
          decoration: const BoxDecoration(
            color: ColorList.iconBackground,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: TextField(
            cursorColor: ColorList.white,
            maxLines: 4,
            minLines: 1,
            onChanged: (data) {
              if (data.isEmpty) {
                setState(() {
                  micCheck = false;
                });
              } else {
                setState(() {
                  micCheck = true;
                });
              }
            },
            onTap: () {
              if (emojiShowing == true) {
                FocusScope.of(context).unfocus();
              }
            },
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            controller: getMessageText,
            focusNode: inputNode,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: ColorList.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: "type message...",
              hintStyle:
              const TextStyle(color: ColorList.black, fontSize: 16),
              border: InputBorder.none,
              prefixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      emojiShowing = !emojiShowing;

                      if (emojiShowing != false) {
                        FocusScope.of(context).unfocus();
                      } else {
                        FocusScope.of(context).requestFocus(inputNode);
                      }
                    });
                  },
                  child: Icon(
                    !emojiShowing
                        ? Icons.emoji_emotions_outlined
                        : Icons.keyboard_alt_rounded,
                    size: 24,
                    color: ColorList.white,
                  )),
              suffixIcon: const Icon(
                Icons.attach_file,
                size: 24,
                color: ColorList.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bubbleText({required Map<String, dynamic> snap}) {
    return Container(
      padding: EdgeInsets.only(
          left: snap['senderId'] == widget.senderId ? 60 : 14,
          right: snap['senderId'] == widget.senderId ? 14 : 60,
          top: 5,
          bottom: 10),
      child: Row(
        mainAxisAlignment: snap['senderId'] == widget.senderId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: snap['senderId'] == widget.senderId
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: snap['senderId'] == widget.senderId ? false : true,
            child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(
                  color: ColorList.black,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: const Icon(
                  Icons.category_rounded,
                  color: ColorList.white,
                  size: 20,
                )),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: snap['senderId'] == widget.senderId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: snap['senderId'] == widget.senderId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                InkWell(
                  onLongPress: () {
                    Fluttertoast.showToast(
                        msg: "Copied to clipboard",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM);
                    Clipboard.setData(
                        ClipboardData(text: snap['message']));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: snap['senderId'] == widget.senderId
                            ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(4))
                            : const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(4)),
                        color: (snap['senderId'] == widget.senderId
                            ? ColorList.primary
                            : ColorList.black),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: snap['senderId'] == widget.senderId
                          ? Text(
                        snap['message'],
                        style: const TextStyle(
                            fontSize: 15, color: ColorList.white),
                      )
                          : ReadMoreText(
                        snap['message'],
                        trimLines: 20,
                        colorClickableText: ColorList.white,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: "more",
                        moreStyle: const TextStyle(
                            fontSize: 15,
                            color: ColorList.white,
                            fontWeight: FontWeight.w900),
                        lessStyle: const TextStyle(
                            fontSize: 15,
                            color: ColorList.white,
                            fontWeight: FontWeight.w900),
                        trimExpandedText: "less",
                        style: const TextStyle(
                            fontSize: 15, color: ColorList.white),
                      )),
                ),
                Text(
                  newFormatter
                      .format(DateTime.fromMicrosecondsSinceEpoch(
                      snap['timestamp'] * 1000))
                      .toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: ColorList.secondaryText,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final newFormatter = DateFormat("MMMM dd, yyyy - HH:mm a");

  void checkIfCanSend() {
    if (getMessageText.text.isNotEmpty) {
      if (widget.type == "single") {
        sendChat(
          receiverId: widget.receiverId,
        );

        //clear the text-field
        getMessageText.clear();

        setState(() {
          micCheck = false;
        });
      } else {}
    }
  }

  Future<void> sendChat({required String receiverId}) async {
    await ConnectFirebase().sendMessage(
        messages: getMessageText.text,
        senderId: widget.senderId,
        receiverId: receiverId,
        type: widget.type,
        context: context,
        receiverCode: widget.receiverCode,
        countValue: countValue);
  }

  Widget typingProgress() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: ColorList.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Lottie.asset("lottie/typing.json", width: 100, height: 40),
    );
  }

}
