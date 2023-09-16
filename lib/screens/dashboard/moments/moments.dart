import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:live_app/provider/moments_provider.dart';
import 'package:live_app/screens/dashboard/moments/post_moments.dart';
import 'package:live_app/screens/dashboard/moments/view_featured_post.dart';
import 'package:live_app/screens/dashboard/moments/view_following_post.dart';
import 'package:live_app/utils/constants.dart';

import 'package:live_app/utils/utils_assets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/common_widgets.dart';
import '../../../utils/helper.dart';

class Moments extends StatefulWidget {
  const Moments({Key? key}) : super(key: key);

  @override
  State<Moments> createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double a = Get.width / baseWidth;
    double b = a * 0.97;
    final List<Map> posts = [
      {
        "dp": "assets/dummy/b1.png",
        "name": "Ariful islam",
        "time": "3 days ago",
        "post": "assets/dummy/b2.png",
        "likes": "24",
        "comments": "16",
      },
      {
        "dp": "assets/dummy/g1.png",
        "name": "Liza",
        "time": "2 days ago",
        "post": "assets/dummy/g2.png",
        "likes": "15",
        "comments": "6",
      },
      {
        "dp": "assets/dummy/b1.png",
        "name": "Ariful islam",
        "time": "4 days ago",
        "post": "assets/dummy/b1.png",
        "likes": "12",
        "comments": "4",
      },
      {
        "dp": "assets/dummy/g1.png",
        "name": "Liza",
        "time": "5 days ago",
        "post": "assets/dummy/g1.png",
        "likes": "18",
        "comments": "9",
      }
    ];
    final momentsProvider = Provider.of<MomentsProvider>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: const Color(0x339E26BC),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 1,
          title: TabBar(
            indicatorColor: Colors.black,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 6 * a),
            indicatorWeight: 1.3,
            dividerColor: Colors.transparent,
            labelColor: const Color(0xff000000),
            unselectedLabelColor: const Color(0x99000000),
            labelStyle: SafeGoogleFont(
              'Poppins',
              fontSize: 18 * b,
              fontWeight: FontWeight.w400,
              height: 1.5 * b / a,
              letterSpacing: 0.96 * a,
              color: const Color(0xff000000),
            ),
            unselectedLabelStyle: SafeGoogleFont(
              'Poppins',
              fontSize: 18 * b,
              fontWeight: FontWeight.w400,
              height: 1.5 * b / a,
              letterSpacing: 0.96 * a,
              color: const Color(0x99000000),
            ),
            padding: EdgeInsets.symmetric(horizontal: 36 * a),
            labelPadding: EdgeInsets.zero,
            tabs: const [
              Tab(
                text: "Following",
              ),
              Tab(
                text: "Featured",
              ),
            ],
            onTap: (value) async {
              if(value == 0 && !momentsProvider.isLoadedFollowing && !momentsProvider.emptyFollowings){
                await momentsProvider.getFollowingMoments();
              }else if(value == 1 && !momentsProvider.isLoadedAll){
                await momentsProvider.getAllMoments();
              }
            },
          ),
        ),
        body: Consumer<MomentsProvider>(
            builder:(context, value, child) => TabBarView(
            children: [
              !value.emptyFollowings
                  ? (!value.isLoadedFollowing
                  ?const Center(child: CircularProgressIndicator(color: Color(0xff9e26bc)))
                  :( value.followingMoments!.data!.isEmpty
                  ?Column(
                children: [
                  SizedBox(
                    height: Get.width / 4,
                  ),
                  Image.asset(
                    "assets/icons/ic_empty.png",
                    width: Get.width / 2,
                    height: Get.width / 2,
                  ),
                  Text(
                    'No Posts yet',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16 * b,
                      fontWeight: FontWeight.w400,
                      height: 1.5 * b / a,
                      letterSpacing: 0.64 * a,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              )
                  :ListView(
                children: List.generate(value.followingMoments?.data?.length??0, (index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 21 * a, right: 21 * a, top: 12 * a, bottom: 12 * a),
                    margin: (value.followingMoments!.data!.length-1)==index ? EdgeInsets.only(bottom: 63*a):null,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: (value.followingMoments?.data?[index].userDetails?[0].images.toString()??'[]') == '[]'
                                      ? CircleAvatar(
                                    foregroundImage: const AssetImage("assets/profile.png"),
                                    radius: 22 * a,
                                  )
                                      :CircleAvatar(
                                    foregroundImage: NetworkImage(value.followingMoments!.data![index].userDetails!.first.images!.first!),
                                    radius: 22 * a,
                                  ),
                                  title: Text(
                                    value.followingMoments!.data![index].userDetails![0].name!,
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 18 * b,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5 * b / a,
                                      letterSpacing: 0.8 * a,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                  subtitle: Text(
                                      TimeUtil.getTimeDifferenceString(value.followingMoments!.data![index].createdAt!),
                                      overflow: TextOverflow.ellipsis,
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 15 * b,
                                        fontWeight: FontWeight.w300,
                                        height: 1.5 * b / a,
                                        letterSpacing: 0.8 * a,
                                        color: const Color(0x99000000),
                                      )),
                                )),
                            GestureDetector(
                              onTap: (){
                                report(value.followingMoments!.data![index].userDetails![0].id!);
                              },
                              child: Container(
                                height: 17 * a,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 7 * a, vertical: 15 * a),
                                child: Image.asset(
                                  'assets/icons/ic_three_dots.png',
                                  width: 28 * a,
                                  height: 8 * a,
                                ),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>ViewFollowingPost(index: index));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (value.followingMoments?.data?[index].images?.toString()??'[]') != '[]'
                                  ?Hero(
                                tag: value.followingMoments!.data![index].id!,
                                child: Image.network(
                                    value.followingMoments!.data![index].images!.first,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            value.followingMoments?.data?[index].caption != null
                                                ? Text(
                                              value.followingMoments!.data![index].caption.toString(),
                                              style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 14 * b,
                                                fontWeight: FontWeight.w400,
                                                height: 1.5 * b / a,
                                                letterSpacing: 0.8 * a,
                                                color: const Color(0xff000000),
                                              ),
                                            )
                                                :const SizedBox.shrink(),
                                            child
                                          ],
                                        );
                                      }
                                      return Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(248, 188, 187, 187),
                                        highlightColor: Colors.white,
                                        period: const Duration(seconds: 1),
                                        child: Container(
                                          color: Colors.white,
                                          width: 160 * a,
                                          height: 160 * a,
                                        ),
                                      );
                                    },
                                    height: 160 * a,
                                    width: 160 * a,
                                    fit: BoxFit.cover),
                              )
                                  :Image.asset('assets/dummy/b1.png',
                                  height: 160 * a,
                                  fit: BoxFit.fitHeight),
                              Container(
                                height: 18 * a,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 7 * a, vertical: 3 * a),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LikeButton(
                                      size: 27,
                                      isLiked: value.checkLike(index,all: true),
                                      onTap: (isLiked) async {
                                        value.likePost(value.followingMoments!.data![index].id!,all: true);
                                        return !isLiked;
                                      },
                                      circleColor: const CircleColor(start: Color(0x339E26BC),end: Color(0xff9e26bc)),
                                      bubblesColor: const BubblesColor(dotPrimaryColor: Color(0xff9e26bc),dotSecondaryColor: Color(0x339E26BC)),
                                      likeBuilder: (bool isLiked) => Icon(
                                        Icons.thumb_up,
                                        color: isLiked ? const Color(0xff9e26bc) : Colors.grey,
                                      ),
                                      likeCount: value.followingMoments?.data?[index].likes?.length??0,
                                      countBuilder: (int? count, bool isLiked, String text) {
                                        var color = isLiked ? const Color(0xff9e26bc)  : Colors.grey;
                                        Widget result;
                                        result = Text(
                                          text,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * b,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5 * b / a,
                                            letterSpacing: 0.48 * a,
                                            color: color,
                                          ),
                                        );
                                        return result;
                                      },
                                    ),
                                    SizedBox(width: 15 * a),
                                    if(value.followingMoments?.data?[index].isCommentRestricted == false)Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.mode_comment_outlined,color: Colors.grey),
                                        SizedBox(width: 5 * a),
                                        Text(
                                          value.followingMoments?.data?[index].comments?.length.toString()??'0',
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * b,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5 * b / a,
                                            letterSpacing: 0.48 * a,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
              )))
                  :Column(
                children: [
                  SizedBox(
                    height: Get.width / 4,
                  ),
                  Image.asset(
                    "assets/icons/ic_empty.png",
                    width: Get.width / 2,
                    height: Get.width / 2,
                  ),
                  Text(
                    'No Following yet',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16 * b,
                      fontWeight: FontWeight.w400,
                      height: 1.5 * b / a,
                      letterSpacing: 0.64 * a,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),

              !value.isLoadedAll
                  ?const Center(child: CircularProgressIndicator(color: Color(0xff9e26bc)))
                  :( value.allMoments!.data!.isEmpty
                  ?Column(
                children: [
                  SizedBox(
                    height: Get.width / 4,
                  ),
                  Image.asset(
                    "assets/icons/ic_empty.png",
                    width: Get.width / 2,
                    height: Get.width / 2,
                  ),
                  Text(
                    'No Posts yet',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16 * b,
                      fontWeight: FontWeight.w400,
                      height: 1.5 * b / a,
                      letterSpacing: 0.64 * a,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              )
                  :ListView(
                children: List.generate(value.allMoments?.data?.length??0, (index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 21 * a, right: 21 * a, top: 12 * a, bottom: 12 * a),
                    margin: (value.allMoments!.data!.length-1)==index ? EdgeInsets.only(bottom: 63*a):null,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: (value.allMoments?.data?[index].userDetails?[0].images.toString()??'[]') == '[]'
                                  ? CircleAvatar(
                                foregroundImage: const AssetImage("assets/profile.png"),
                                radius: 22 * a,
                              )
                                  :CircleAvatar(
                                foregroundImage: NetworkImage(value.allMoments!.data![index].userDetails!.first.images!.first!),
                                radius: 22 * a,
                              ),
                              title: Text(
                                value.allMoments!.data![index].userDetails![0].name!,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 18 * b,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * b / a,
                                  letterSpacing: 0.8 * a,
                                  color: const Color(0xff000000),
                                ),
                              ),
                              subtitle: Text(
                                  TimeUtil.getTimeDifferenceString(value.allMoments!.data![index].createdAt!),
                                  overflow: TextOverflow.ellipsis,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 15 * b,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * b / a,
                                    letterSpacing: 0.8 * a,
                                    color: const Color(0x99000000),
                                  )),
                            )),
                            GestureDetector(
                              onTap: (){
                                report(value.allMoments!.data![index].userDetails![0].id!);
                              },
                              child: Container(
                                height: 17 * a,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 7 * a, vertical: 15 * a),
                                child: Image.asset(
                                  'assets/icons/ic_three_dots.png',
                                  width: 28 * a,
                                  height: 8 * a,
                                ),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>ViewFeaturedPost(index: index));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (value.allMoments?.data?[index].images?.toString()??'[]') != '[]'
                                  ?Hero(
                                tag: value.allMoments!.data![index].id!,
                                    child: Image.network(
                                     value.allMoments!.data![index].images!.first,
                                      loadingBuilder: (context, child, loadingProgress) {
                                       if (loadingProgress == null) {
                                         return Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           value.allMoments?.data?[index].caption != null
                                               ? Text(
                                               value.allMoments!.data![index].caption.toString(),
                                             style: SafeGoogleFont(
                                               'Poppins',
                                               fontSize: 14 * b,
                                               fontWeight: FontWeight.w400,
                                               height: 1.5 * b / a,
                                               letterSpacing: 0.8 * a,
                                               color: const Color(0xff000000),
                                             ),
                                           )
                                               :const SizedBox.shrink(),
                                           child
                                         ],
                                       );
                                       }
                                        return Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(248, 188, 187, 187),
                                        highlightColor: Colors.white,
                                        period: const Duration(seconds: 1),
                                        child: Container(
                                          color: Colors.white,
                                          width: 160 * a,
                                          height: 160 * a,
                                        ),
                                      );
                                      },
                                        height: 160 * a,
                                        width: 160 * a,
                                        fit: BoxFit.cover),
                                  )
                                  :Image.asset('assets/dummy/b1.png',
                                    height: 160 * a,
                                    fit: BoxFit.fitHeight),
                              Container(
                                height: 18 * a,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 7 * a, vertical: 3 * a),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                      LikeButton(
                                        size: 27,
                                        isLiked: value.checkLike(index,all: true),
                                        onTap: (isLiked) async {
                                          value.likePost(value.allMoments!.data![index].id!,all: true);
                                          return !isLiked;
                                        },
                                        circleColor: const CircleColor(start: Color(0x339E26BC),end: Color(0xff9e26bc)),
                                        bubblesColor: const BubblesColor(dotPrimaryColor: Color(0xff9e26bc),dotSecondaryColor: Color(0x339E26BC)),
                                        likeBuilder: (bool isLiked) => Icon(
                                        Icons.thumb_up,
                                        color: isLiked ? const Color(0xff9e26bc) : Colors.grey,
                                      ),
                                        likeCount: value.allMoments?.data?[index].likes?.length??0,
                                        countBuilder: (int? count, bool isLiked, String text) {
                                          var color = isLiked ? const Color(0xff9e26bc)  : Colors.grey;
                                          Widget result;
                                          result = Text(
                                            text,
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 16 * b,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5 * b / a,
                                              letterSpacing: 0.48 * a,
                                              color: color,
                                            ),
                                          );
                                          return result;
                                        },
                                      ),
                                    SizedBox(width: 15 * a),
                                    if(value.allMoments?.data?[index].isCommentRestricted == false)Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.mode_comment_outlined,color: Colors.grey),
                                        SizedBox(width: 5 * a),
                                        Text(
                                          value.allMoments?.data?[index].comments?.length.toString()??'0',
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * b,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5 * b / a,
                                            letterSpacing: 0.48 * a,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
              )
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){Get.to(()=>const PostMoments());},tooltip: 'Add Moment',child: const Icon(Icons.add)),
      ),
    );
  }

  void report(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: (){
              showReportReasons(id);
            },
          ),
        );
      },
    );
  }

  void showReportReasons(String id) {
    Get.back();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Reason for Reporting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Spam'),
                onTap: (){
                  Get.back();
                  reportUser(id,'Spam');
                },
              ),
              ListTile(
                title: const Text('Inappropriate Content'),
                onTap: (){
                  Get.back();
                  reportUser(id,'Inappropriate Content');
                },
              ),
              ListTile(
                title: const Text('Other'),
                onTap: (){
                  Get.back();
                  reportUser(id,'Other');
                },
              ),
            ],
          ),
        );
      },
    );

  }

  void reportUser(String id, String message) async {
    final value = Provider.of<MomentsProvider>(context,listen: false);
    await value.reportUser(id: id,message: message);
    showCustomSnackBar('Reported!',Get.context!,isError: false,isToaster: true);
  }
}