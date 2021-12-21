import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/vediorecorder.dart';

void main() {
  runApp(

      GetMaterialApp(
    // It is not mandatory to use named routes, but dynamic urls are interesting.
    initialRoute: '/home',
    defaultTransition: Transition.native,
    translations: MyTranslations(),
    locale: Locale('pt', 'BR'),
    getPages: [
      //Simple GetPage
      GetPage(name: '/home', page: () => First()),
      // GetPage with custom transitions and bindings
      GetPage(
        name: '/second',
        page: () => Second(),
        customTransition: SizeTransitions(),
        binding: SampleBind(),
      ),
      // GetPage with default transitions
      GetPage(
        name: '/third',
        transition: Transition.cupertino,
        page: () => Third(),
      ),
    ],
  )
  );
}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'title': 'Hello World %s',
    },
    'en_US': {
      'title': 'Hello World from US',
    },
    'pt': {
      'title': 'Olá de Portugal',
    },
    'pt_BR': {
      'title': 'Olá do Brasil',
    },
  };
}

class Controller extends GetxController {
  int count = 0;
  void increment() {
    count++;
    // use update method to update all count variables
    update();
  }
}

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("Hi", "I'm modern snackbar");
          },
        ),
        title: Text("title".trArgs(['John'])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<Controller>(
                init: Controller(),
                // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
                builder: (_) => Text(
                  'clicks: ${_.count}',
                )),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Get.toNamed('/second');
              },
            ),
            ElevatedButton(
              child: Text('Change locale '),
              onPressed: () {
                //correct language sys
                Get.updateLocale(Locale('en', 'UK'));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.find<Controller>().increment();
          }),
    );
  }
}

class Second extends GetView<ControllerX> {
  late String name,email,password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         TextFormField(
           onChanged: (val){
             name=val;

           },
           decoration: InputDecoration(
             hintText: 'Name',
           ),
         ),
            TextFormField(
              onChanged: (val){
                email=val;

              },
              decoration: InputDecoration(
                hintText: 'email',
              ),
            ),   TextFormField(
              obscureText: true,
              onChanged: (val){
                password=val;

              },
              decoration: InputDecoration(
                hintText: 'password',
              ),
            ),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () {
                Get.back();
                controller.updateUser(name,email,password);
                Get.snackbar(
                  'new user',
                  'Successfully created',
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

class Third extends GetView<ControllerX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third ${Get.arguments}"),
      ),
      body: Center(
          child: Obx(() => ListView.builder(
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return Text("${controller.list[index]}");
              }))),
    );
  }
}

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
  }
}

class User {
  User({this.name = 'Name',  this.email='', this.password=''});
  String name,email,password;

}

class ControllerX extends GetxController {
  final name = 0.obs;
  final count2 = 0.obs;
  final list = [56].obs;
  final user = User().obs;

  updateUser(String name,String email,String pass) {
    user.update((value) {
      value!.name = name;
      value.email = email;
      value.password = pass;
    });
  }



}

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve!,
        ),
        child: child,
      ),
    );
  }
}
