import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:greenone/pages/post/PostPage.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.title,
    required this.date,
    this.iconColor,
    this.titleColor,
  });

  final String title;
  final String date;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2E7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 332,
        child: Padding(
          padding: const EdgeInsets.only(left: 17.57, top: 15.48, bottom: 15.48, right: 27),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E7DE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/icons/leaf.svg',
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 14),
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? const Color(0xFF8C8C8C),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFFD1D2D1),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageCardWithImage extends StatelessWidget {
  const MessageCardWithImage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.content
  });

  final String title;
  final String imageUrl;
  final String date;
  final String content;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildCard(),
          ],
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      width: 340,
      padding: const EdgeInsets.only(left: 17.57, top: 15.48, bottom: 17.45),
      decoration: ShapeDecoration(
        color: const Color(0xFFF0F2E7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfile(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 4.6),
                _buildDateTime(),
                const SizedBox(height: 32.49),
                _buildImage(),
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFFE6E7DE),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset('assets/icons/leaf.svg'),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            _buildTodayBadge(),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.to(() => PostPage(
              title: title, 
              imageUrl: imageUrl, 
              date: date, 
              content: content,));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(right: 10),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            children: [
              const Text(
                '더보기',
                style: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              SvgPicture.asset('assets/icons/arrow-forward.svg')
            ],
          )
        ),
      ],
    );
  }

  Widget _buildTodayBadge() {
    return DateFormat('yyyy.MM.dd').format(DateFormat('yyyy.MM.dd').parse(date)) == DateFormat('yyyy.MM.dd').format(DateTime.now())
    ? const Text(
      '오늘',
      style: TextStyle(
        color: Color(0xFF01C674),
        fontSize: 12,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
    ) : Container();
  }

  Widget _buildDateTime() {
    return Text(
      date,
      style: const TextStyle(
        color: Color(0xFFD1D2D1),
        fontSize: 10,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 138,
      height: 138,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF01C674)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}