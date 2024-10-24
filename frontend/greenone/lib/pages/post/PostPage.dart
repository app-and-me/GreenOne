import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostPage extends StatefulWidget {
  const PostPage({
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
  // ignore: library_private_types_in_public_api
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAED),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAED),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/left.svg',
            color: const Color(0xFFAAAAAA),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '지구 돕기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.41,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 23),
            _buildDateText(widget.date),
            const SizedBox(height: 23),
            _buildTodoCard(widget.title),
            const SizedBox(height: 30),
            _buildContentCard(widget.content),
            const SizedBox(height: 32.5),
            _buildImage(widget.imageUrl)
          ],
        ),
      ),
    );
  }

  Widget _buildDateText(String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTodoCard(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 할 일',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
            decoration: ShapeDecoration(
              color: const Color(0xFFF1F2E7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '내용',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: ShapeDecoration(
              color: const Color(0xFFF1F2E7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 26),
        child: Container(
          width: 161,
          height: 161,
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
        ),
      )
    );
  }
}
