import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/Goods/home.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:hakgeun_market/pages/chatroom/chatroom.dart';

class Detail extends StatefulWidget {
  final Goods goods;
  final List<Goods> goodsDataList;
  const Detail(
      {super.key,
      required this.goods,
      required this.goodsDataList}); // 생성자: 상품의 id를 받음.

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Goods? goodsData;
  late List<Goods> goodsList;
  var isLoading = true;

  @override
  void initState() {
    // 위젯이 생성될 때 Firebase에서 데이터를 가져옴.(상태초기화)
    super.initState();
    goodsData = widget.goods;
    goodsList = widget.goodsDataList;
  }

  // 앱 바 위젯 생성 함수
  PreferredSizeWidget _appbarWidget() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  // 이미지 위젯 생성 함수
  Widget _makeimage() {
    if (goodsData?.photoList == null || goodsData!.photoList!.isEmpty) {
      return Container(
          width: double.infinity,
          child: Image.asset(
            'assets/images/empty.jpg',
            width: 100,
            height: 300,
            fit: BoxFit.fill,
          )); // 사진이 없을 경우 표시할 위젯(현재는 빈 컨테이너)
    }
    String imageUrl = goodsData!.photoList![0];
    return Container(
        width: double.infinity,
        child: Image.asset(
          imageUrl,
          width: 100,
          height: 300,
          fit: BoxFit.fill,
        ));
  }

  // 매너 온도 등을 표시하는 위젯 생성 함수
  Widget _temp() {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Column(
                  children: [
                    const Text(
                      "36.5°C",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: 6,
                            color: Colors.black.withOpacity(0.2),
                            child: Row(
                              children: [
                                Container(
                                    height: 6, width: 40, color: Colors.green),
                              ],
                            )))
                  ],
                )
              ],
            ),
          ),
          const Text(
            "매너온도",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _tempset() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(
        children: [
          _temp(),
          Container(
              width: 30,
              height: 30,
              child: Image.asset("assets/images/level-3.jpg"))
        ],
      ),
    ]));
  }

  // 판매자 정보와 매너 온도를 표시하는 위젯 생성 함수
  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: Image.asset("assets/images/user.png").image,
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "양준석",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text("디지털관 1층"),
              ],
            ),
            const SizedBox(width: 150),
            Expanded(child: _tempset())
          ],
        ),
      ),
    );
  }

  // 구분선 생성 함수
  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // 상품 내용 상세 정보를 표시하는 위젯 생성 함수
  Widget _contentDetail() {
    if (goodsData == null) return Container(); // 데이터가 없는 경우
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              goodsData!.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              goodsData!.category,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              goodsData!.content ?? '',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 15),
            Text(
              goodsData!.readCnt ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ));
  }

  // 판매자의 다른 상품 정보를 표시하는 섹션 생성 함수
  Widget _otherCellContents() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          // "모두보기" 버튼을 눌렀을 때 AllProductsPage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                // builder: (context) => Home(SearchData: goodsList)),
                builder: (context) => App()),
          );
        },
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "판매자님의 판매 상품",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "모두보기",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 하단 바 생성 함수
  Widget _bottomBarWidget() {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/svg/heart_off.svg",
            width: 20,
            height: 20,
            color: Colors.green,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goodsData!.price,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "가격제안불가",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green,
                  ),
                  child: GestureDetector(
                    child: const Text(
                      "채팅으로 거래하기",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    onTap: () {
                      // 해당 Text 클릭시 채팅 페이지로 이동
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const ChatRoom(
                      //       rname: '',
                      //       uid1: '',
                      //       uid2: '',
                      //       rid: '',
                      //       uid: '',
                      //       name: '',
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 메인 바디 위젯 생성 함수
  Widget _bodyWidget() {
    // if (isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _makeimage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ],
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // goodsDataList에서 각 아이템 가져오기
              if (widget.goodsDataList == null ||
                  index >= widget.goodsDataList.length) {
                // goodsDataList가 null이거나 인덱스가 범위를 벗어날 경우 에러 방지
                return Container();
              }
              Goods goods = widget.goodsDataList[index];

              // if (goods.photoList == null || goods.photoList!.isEmpty) {
              //   // photoList가 null이거나 비어 있을 경우 에러 방지
              //   return Container();
              // }

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey.withOpacity(0.3),
                        height: 120,
                        child: goods.photoList != null &&
                                goods.photoList!.isNotEmpty
                            ? Image.asset(
                                goods.photoList![0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                'assets/images/empty.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    Text(
                      goods.title,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      goods.price,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appbarWidget(),
        body: _bodyWidget(),
        bottomNavigationBar: _bottomBarWidget());
  }
}
