import 'package:flutter/material.dart';
import 'package:sutt_task_final/classes/hex_color.dart';
import 'package:go_router/go_router.dart';
import 'package:sutt_task_final/classes/fadeanimation.dart';
import 'package:sutt_task_final/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:sutt_task_final/utils/language_list.dart';
import 'package:sutt_task_final/services/userprovider.dart';
import 'package:provider/provider.dart';


enum FormData {
  input,
  dropdown,
}

int outputState = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color enabled = Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  FormData? selected;

  String dropdownValue = 'English';
  String target = 'en';
  TextEditingController inputController = TextEditingController();
  String outputText = 'Translated text will be displayed here';


  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final name = userProvider.username;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: HexColor("#4b4293").withOpacity(0.8),
        title: Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 35),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Hello ' + name + ' !',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await UserSecureStorage.setLoggedIn('false');
                context.go('/login');
              },
              child: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 30,
              ),
            )
          ]),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              HexColor("#4b4293").withOpacity(0.8),
              HexColor("#4b4293"),
              HexColor("#08418e"),
              HexColor("#08418e")
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage('lib/assets/background.jpg'),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 15),
              FadeAnimation(
                delay: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("#4b4293"),
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: SingleChildScrollView(
                    child: TextField(
                      onTap: () {
                        setState(() {
                          selected = FormData.input;
                        });
                      },
                      controller: inputController,
                      maxLines: null, // Allows for multiline input
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Text to be translated',
                          hintStyle: TextStyle(
                            color: enabledtxt,
                            fontSize: 16,
                          )),
                      style: TextStyle(
                          color:
                          selected == FormData.input ? enabledtxt : deaible,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                delay: 1,
                child: TextButton(
                    onPressed: () async {
                      if(inputController.text.isEmpty) {FocusScope.of(context).unfocus();}
                      else {
                        setState(() {
                          outputState = 1;
                        });
                        FocusScope.of(context).unfocus();
                      final dio = Dio();
                      final res1 = await dio.post(
                        'https://google-translate1.p.rapidapi.com/language/translate/v2/detect',
                        data: {
                          "q": inputController.text,
                        },
                        options: Options(
                            contentType: Headers.formUrlEncodedContentType,
                            headers: {
                              "Accept-Encoding": "application/gzip",
                              "X-RapidAPI-Key":
                              "4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d",
                              "X-RapidAPI-Host":
                              "google-translate1.p.rapidapi.com"
                            }),
                      );
                      var source =
                      res1.data['data']['detections'][0][0]['language'];
                      final res = await dio.post(
                        'https://google-translate1.p.rapidapi.com/language/translate/v2',
                        data: {
                          "q": inputController.text,
                          "target": target,
                          "source": "$source",
                        },
                        options: Options(
                            contentType: Headers.formUrlEncodedContentType,
                            headers: {
                              "Accept-Encoding": "application/gzip",
                              "X-RapidAPI-Key":
                              "4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d",
                              "X-RapidAPI-Host":
                              "google-translate1.p.rapidapi.com"
                            }),
                      );
                      setState(() {
                        outputState = 0;
                        outputText = res.data['data']['translations'][0]
                        ['translatedText'];
                      });}
                    },
                    child: Text(
                      "Translate",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF2697FF).withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 80),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)))),
              ),
              SizedBox(height: 15),
              FadeAnimation(
                delay: 1,
                child: Row(
                  children: [
                    Text('Translate to Language :  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          setState(() {
                            target = langMap[newValue].toString();
                            print(target);
                          });
                        });
                      },
                      dropdownColor: HexColor("#4b4293"),
                      items: <String>[
                        'English',
                        'French',
                        'German',
                        'Spanish',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FadeAnimation(
                  delay: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("#4b4293"),
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: outputState == 1 ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                          Text('loading',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        outputText,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
