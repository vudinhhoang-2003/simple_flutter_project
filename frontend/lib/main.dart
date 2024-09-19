import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

/// Widget MainApp là widget gốc của ứng dụng, sử dụng một StatelessWidget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng full-stack flutter đơn giản',
      home: MyHomePage(),
    );
  }
}

// Widget MyHomePage là trang chính của ứng dụng, sử dụng StatefulWidget
// để quản lý trạng thái do có nội dung cần thay đổi trên trang này
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Lớp state cho MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  // Controller để lấy dữ liệu từ Widget TextField
  final controller = TextEditingController();

  // Biến để lưu thông điệp phản hồi từ server

  String responseMessage = '';

//Hàm để gửi tên tới server
  Future<void> sendName() async {
    // Lấy tên từ TextField
    final name = controller.text;

    //Sau khi lấy được tên thì xóa nội dung trong controller
    controller.clear();

    // Endpoint submit
    final url = Uri.parse('http://localhost:8080/api/v1/submit');
    try {
      //Gửi yêu cầu POST tới server
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'name': name}),
          )
          .timeout(Duration(seconds: 10));

      if (response.body.isNotEmpty) {
        final data = json.decode(response.body);

        setState(() {
          responseMessage = data['message'];
        });
      } else {
        setState(() {
          responseMessage = 'Không nhận được phản hồi từ server';
        });
      }
    } catch (e) {
      setState(() {
        responseMessage = 'Đã xảy ra lỗi: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ứng dụng full-stack flutter đơn giản'),
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Tên'),
          ),
          SizedBox(height: 20),
          FilledButton(
            onPressed: sendName,
            child: Text('Gửi'),
          ),
          //Hiển thị thông điệp phản hồi server
          Text(
            responseMessage,
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
///