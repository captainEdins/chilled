import 'package:chilled/holder/pages/message/inbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chilled/resources/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chilled/resources/string.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    var notch = 10.0;
    if (MediaQuery.of(context).viewPadding.top > 0) {
      notch = 40.0;
    }
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          color: ColorList.white,
          child: Column(
            children: [
              SizedBox(
                height: notch == 10 ? 38 : 70,
                child: Stack(
                  children: [
                    Positioned(
                      top: notch,
                      left: 0,
                      right: 0,
                      child: const Center(
                          child: Text(
                            "Messages",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: ColorList.primary,
                                fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    botChatAI("Talk with Chilled"),
                    Container(
                      margin: const EdgeInsets.only(top: 20,bottom: 10),
                      color: ColorList.primary.withOpacity(.1),
                      height: 1,),
                    communityBox(
                      img: 'https://images.pexels.com/photos/6129203/pexels-photo-6129203.jpeg?auto=compress&cs=tinysrgb&w=600',
                      doctorName: 'Dr. David Kagwi Wairoto',
                      doctorTitle: 'Consultant Psychiatrist',
                      phoneNumber: "+254769398128"
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20,bottom: 10),
                      color: ColorList.primary.withOpacity(.1),
                      height: 1,),
                    communityBox(
                        img: 'https://images.pexels.com/photos/3825457/pexels-photo-3825457.jpeg?auto=compress&cs=tinysrgb&w=600',
                        doctorName: 'Dr. Lina Akello',
                        doctorTitle: 'Consultant Psychiatrist',
                        phoneNumber: "+25471029290"
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 20,bottom: 10),
                      color: ColorList.primary.withOpacity(.1),
                      height: 1,),
                    communityBox(
                        img: 'https://images.pexels.com/photos/7579319/pexels-photo-7579319.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                        doctorName: 'Dr. Linda N. Nyamute',
                        doctorTitle: 'Consultant Psychiatrist',
                        phoneNumber: "0737879077"
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget botChatAI(String title) {
    return InkWell(
      onTap: () {


        pushNewScreen(
          context,
          screen: Inbox(
              name: "Chilled",
              receiverId: Strings.userGPT,
              status: "May i know your problem",
              senderId: phone,
              receiverCode: "gpt"),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorList.primary.withOpacity(.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration:  BoxDecoration(
                  color: ColorList.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.category_rounded,
                  color: ColorList.white,
                  size: 20,
                )),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ColorList.primary,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                          const Text(
                            "May i get to know your problem",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: ColorList.primary,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget communityBox({required String img,
    required String doctorName,
    required String phoneNumber,
    required String doctorTitle,}) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: Inbox(
              name: doctorName,
              receiverId: phoneNumber,
              status: doctorTitle,
              senderId: phoneNumber,
              dp: img,
              receiverCode: phoneNumber),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: img,
              width: 40,
              height: 40,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorList.primary,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                           Text(
                            doctorTitle,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: ColorList.primary,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> setData() async {
    final prefs = await SharedPreferences.getInstance();
    final getName = prefs.getString('name') ?? "";
    final getEmail = prefs.getString('email') ?? "";
    final getPhone = prefs.getString('phone') ?? "";






    setState(() {
      name = getName;
      email = getEmail;
      phone = getPhone;

    }
    );


  }

  var name = "";
  var email = "";
  var phone = "";

}
