import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'NationalParkDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget  {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> nationalParks = [];

  @override
  void initState() {
    super.initState();
    loadNationalParks();
    print('start');
  }

  Future<List<Map<String, String>>> fetchNationalParks() async {
    final response = await http.get(Uri.parse('http://localhost/api/national-parks/'));
    //ใช้ Flutter package http เพื่อส่ง HTTP request เข้าไปยัง API ของ National Parks ที่อยู่ใน http://localhost/api/national-parks/ ด้วย method http.get() โดยส่ง URI ที่ต้องการไปในรูปแบบของ Uri.parse()

    if (response.statusCode == 200) { // ตรวจสอบว่า response ที่ได้รับมาจาก API มีสถานะเป็น 200 (OK) หรือไม่ โดยใช้ response.statusCode
      final List<dynamic> data = json.decode(response.body); //
      //ถ้า response มีสถานะเป็น 200 (OK) จะทำการแปลง JSON ที่ได้รับมาจาก API ให้อยู่ในรูปแบบของ List<Map<String, String>>
      // โดยการใช้ json.decode() และ map() ตามด้วยฟังก์ชันที่ return ค่าเป็น Map<String, String> ซึ่งจะเก็บข้อมูลที่จำเป็นของแต่ละ National Park เช่น ชื่อ (name), รายละเอียด (description), ภาพ (image)
      // เป็นต้น แล้ว return ค่า List<Map<String, String>> นี้ออกไป
      final nationalParks = data
          .map<Map<String, String>>((dynamic park) => {
        'name': park['name'],
        'description': park['description'],
        'image': park['image'],
        'weather': park['weather'],
        'postion': park['postion'],
        'vegetation': park['vegetation'],
        'animal': park['animal'],
        'tourist': park['tourist'],
        'events': park['events'],
        'signal': park['signal'],
        'donot': park['donot'],
        'house': park['house'],
        'agency': park['agency'],
        'contact': park['contact'],
        'link': park['link'],
      })
          .toList();
      return nationalParks;
    } else { //ถ้า response ไม่ใช่สถานะ 200 (OK) จะ throw Exception ขึ้นมาแจ้งเตือนว่าการดึงข้อมูล National Parks ไม่สำเร็จ
      throw Exception('Failed to load national parks');
    }
  }

  Future<void> loadNationalParks() async {
    try {
      final parks = await fetchNationalParks(); // เรียกใช้ฟังก์ชัน fetchNationalParks() เพื่อดึงข้อมูล National Parks จาก API
      //ถ้าการดึงข้อมูลสำเร็จ ฟังก์ชัน fetchNationalParks() จะ return ค่าเป็น List<Map<String, String>> และเก็บไว้ในตัวแปร parks
      setState(() { // เรียกใช้ setState() เพื่ออัปเดตค่า nationalParks ให้เป็น parks ที่ดึงมาจาก API โดยการ set state จะทำให้ widget ที่เกี่ยวข้องกับ nationalParks ถูก rebuild ใหม่
        nationalParks = parks;
      });
      print(nationalParks);
    } catch (e) { // ถ้าการดึงข้อมูลไม่สำเร็จ จะ catch Exception ที่ถูก throw ขึ้นมาในฟังก์ชัน fetchNationalParks() และพิมพ์ข้อความ error ที่ได้ออกทาง console
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (nationalParks.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
      return Scaffold( // Scaffold เป็น Widget ที่ใช้สร้างหน้าจอหลักของแอปพลิเคชัน โดยสามารถเพิ่ม Widget อื่น ๆ เข้าไปได้ เช่น AppBar, BottomNavigationBar, Drawer และอื่น ๆ
        body: Column( // Column เป็น Widget ที่จัดเรียง Widgets ลงมาเป็นแนวตั้ง โดยจะใส่ Widgets อื่น ๆ เข้าไปด้านในของ Column
          children: [
            Container( // Container เป็น Widget ที่ใช้สร้างพื้นที่ตามขนาดที่กำหนด ซึ่งสามารถใส่ Widgets อื่น ๆ เข้าไปได้ ในนี้เป็นการกำหนดขนาดของรูปภาพที่จะแสดงบนหน้าจอ โดยกำหนดความกว้างเท่ากับความกว้างของหน้าจอและความสูงเท่ากับ 40% ของความสูงของหน้าจอ
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding( // Padding เป็น Widget ที่ใช้เพิ่มพื้นที่ว่างระหว่าง Widgets ต่าง ๆ โดยกำหนดค่า EdgeInsets ซึ่งเป็นการกำหนดขนาดของช่องว่างระหว่าง Widgets ทั้งหมด ในตัวอย่างนี้เป็นการกำหนด Padding ให้กับรูปภาพที่แสดงบนหน้าจอเพื่อเพิ่มความสวยงามและความสมดุลของหน้าจอ
                padding: const EdgeInsets.all(8.0), // กำหนด Padding ขนาด 8 pixel ให้กับ Container ที่ใส่รูปภาพ
                child: Image.network( // เป็นวิดเจ็ตของ Flutter ที่แสดงภาพจาก URL ที่กำหนด
                'https://cdn.discordapp.com/attachments/506416477310812161/1097210605041111040/564000010482201.png',
                fit: BoxFit.cover, // ทำการปรับขนาดภาพให้มีขนาดพอดีกับพื้นที่ใน Container ที่ใส่ภาพ และตัดขอบภาพที่ไม่พอดีให้หายไป
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) { // เป็นฟังก์ชั่นที่เรียกใช้เมื่อภาพกำลังโหลด ซึ่งรับพารามิเตอร์ 3 ตัว ได้แก่
                  // BuildContext, Widget, และ ImageChunkEvent ที่แสดงความคืบหน้าของการดาวน์โหลดภาพ ในโค้ดนี้ฟังก์ชั่นจะแสดง CircularProgressIndicator ที่ตรงกลางภาพ หาก loadingProgress ไม่เป็น null
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Text('Error Loading Image');
                },
              ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
            'National Park List',
            style: TextStyle(fontSize:20),
            ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nationalParks.length,
                itemBuilder: (BuildContext context, int index) {
                  String name = nationalParks[index]['name']!;
                  String image = nationalParks[index]['image']!;
                  String desc = nationalParks[index]['description']!;
                  String weather = nationalParks[index]['weather']!;
                  String postion = nationalParks[index]['postion']!;
                  String vegetation = nationalParks[index]['vegetation']!;
                  String animal = nationalParks[index]['animal']!;
                  String tourist = nationalParks[index]['tourist']!;
                  String events = nationalParks[index]['events']!;
                  String signal = nationalParks[index]['signal']!;
                  String donot = nationalParks[index]['donot']!;
                  String house = nationalParks[index]['house']!;
                  String agency = nationalParks[index]['agency']!;
                  String contact = nationalParks[index]['contact']!;
                  String link = nationalParks[index]['link']!;

                  return GestureDetector(
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NationalParkDetails(
                          name: name,
                          description: desc,
                          image: image,
                          weather: weather,
                          postion: postion,
                          vegetation: vegetation,
                          animal: animal,
                          tourist: tourist,
                          events: events,
                          signal: signal,
                          donot: donot,
                          house: house,
                          agency: agency,
                          contact: contact,
                          link: link,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(

                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 200,
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Text('Error Loading Image');
                            },
                          )
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(desc),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  );
                },
              ),
              )
          ],
        ),
      );
  }
}


