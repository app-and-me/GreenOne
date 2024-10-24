import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:greenone/api/Post.dart';
import 'package:greenone/api/PostDate.dart';
import 'package:greenone/pages/MainPage.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.taskTitle});

  final String taskTitle;

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String? _selectedImagePath;
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

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
            _buildTodoCard(widget.taskTitle),
            const SizedBox(height: 30),
            _buildContentCard(),
            const SizedBox(height: 38),
            _buildSelectPicture(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, right: 26),
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

  Widget _buildContentCard() {
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
            padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
            decoration: ShapeDecoration(
              color: const Color(0xFFF1F2E7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: TextField(
              controller: _contentController,
              cursorColor: const Color(0xFF333333),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '내용을 작성해주세요. (최대 1,000자)',
                hintStyle: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
              maxLines: null,
              maxLength: 1000,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectPicture() {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '사진 (1장 선택)',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '사진을 업로드해주세요.',
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _selectPicture(),
          const SizedBox(height: 60),
          _buildCompleteButton(),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Widget _selectPicture() {
    return GestureDetector(
      onTap: () {
        _pickImage();
      },
      child: _selectedImagePath == null
          ? SvgPicture.asset('assets/icons/addPicture.svg')
          : Container(
              width: 161,
              height: 161,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: FileImage(File(_selectedImagePath!)),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF01C674)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
    );
  }

  Widget _buildCompleteButton() {
    final bool isCompleteEnabled = _selectedImagePath != null && _contentController.text.isNotEmpty;

    return GestureDetector(
      onTap: isCompleteEnabled
          ? () {
            String uid = FirebaseAuth.instance.currentUser!.uid;
            File image = File(_selectedImagePath!);
            String content = _contentController.text;
            String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

            PostApi().createPost(uid, content, widget.taskTitle, image);
            PostDateApi().createPostDate(uid, formattedDate, true);

            // FirebaseStorage.instance
            //       .ref(DateFormat('yyyy-MM-dd').format(DateTime.now()))
            //       .putFile(image);
  

            Get.offAll(() => const MainPage());
          }
          : null,
      child: Container(
        width: 337.50,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          color: isCompleteEnabled ? const Color(0xFF333333) : const Color(0xFF8C8C8C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          '작성완료',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isCompleteEnabled ? Colors.white : const Color(0xFFCCCCCC),
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
