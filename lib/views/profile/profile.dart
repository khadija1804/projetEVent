import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/controller/auth_controller.dart';
import 'package:event/controller/data_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/ticket_model.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

bool isMenuVisible = false;

void toggleMenu() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  List<Ticketdetail> ticket = [
   
  ];


  bool isNotEditable = true;
  
  
  DataController? dataController;

  int? followers = 0,following=0;
  String image = '';
  AuthController? authController;

  @override
  initState(){
    super.initState();
    dataController = Get.find<DataController>();
    authController = Get.put(AuthController());

    firstNameController.text = dataController!.myDocument!.get('first');
    lastNameController.text = dataController!.myDocument!.get('last');

    try{
      descriptionController.text = dataController!.myDocument!.get('desc');
    }catch(e){
      descriptionController.text = '';
    }

    try{
      image = dataController!.myDocument!.get('image');
    }catch(e){
      image = '';
    }

    try{
      locationController.text = dataController!.myDocument!.get('location');
    }catch(e){
      locationController.text = '';
    }


    try{
      followers = dataController!.myDocument!.get('followers').length;
    }catch(e){
      followers = 0;
    }

    try{
      following = dataController!.myDocument!.get('following').length;
    }catch(e){
      following = 0;
    }



  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(
                      left: Get.width * 0.75, top: 20, right: 20),
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          
                        },
                        child: Image(
                          image: AssetImage('assets/sms.png'),
                          width: 28,
                          height: 25,
                        ),
                      ),
                      InkWell(
                            onTap: toggleMenu,
                            child: Image(
                              image: AssetImage('assets/menu.png'),
                              width: 23.33,
                              height: 19,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              Align(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 90, horizontal: 20),
                  width: Get.width,
                  height: isNotEditable? 240: 310,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 35),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(70),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff7DDCFB),
                              Color(0xffBC67F2),
                              Color(0xffACF6AF),
                              Color(0xffF95549),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: image.isEmpty? CircleAvatar(
                                radius: 56,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  'assets/profile.png',
                                )
                              ): CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                   image,
                                  )
                              ),
                              // child: Image.asset(
                              //   'assets/profilepic.png',
                              //   fit: BoxFit.contain,
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    isNotEditable?Text(
                      "${firstNameController.text} ${lastNameController.text}",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ):
                    Container(
                      width: Get.width*0.6,
                      child: Row(
                        children: [
                          Expanded(child: TextField(
                            controller: firstNameController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'First Name',

                            ),
                          ),),

                          SizedBox(
                            width: 10,
                          ),

                          Expanded(child: TextField(
                            controller: lastNameController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Last Name',

                            ),
                          ),),
                        ],
                      ),
                    ),
                   isNotEditable? Text(
                      "${locationController.text}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff918F8F),
                      ),
                    ):
                   Container(
                     width: Get.width*0.6,
                     child: TextField(
                       controller: locationController,
                       textAlign: TextAlign.center,
                       decoration: InputDecoration(
                           hintText: 'Location',

                       ),
                     ),
                   ),
                    SizedBox(
                      height: 15,
                    ),
                    isNotEditable?Container(
                      width: 270,
                      child: Text(
                        '${descriptionController.text}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: -0.3,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ): Container(
                      width: Get.width*0.6,
                      child: TextField(
                        controller: descriptionController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Description',

                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "${followers}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                "Followers",
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: -0.3,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 35,
                            color: Color(0xff918F8F).withOpacity(0.5),
                          ),
                          Column(
                            children: [
                              Text(
                                "${following}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.3),
                              ),
                              Text(
                                "Following",
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: -0.3,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(
                      height: 40,
                    ),
                    
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 0.01,
                                  ),
                                ),
                              ),
                              child: TabBar(
                                indicatorColor: Colors.black,
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10,
                                ),
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Tab(
                                    icon: Image.asset("assets/ticket.png"),
                                    height: 20,
                                  ),
                                  Tab(
                                    icon: Image.asset("assets/Group 18600.png"),
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: screenheight * 0.46,
                              //height of TabBarView
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: ticket.length,
                                      itemBuilder: (context, index) {
                                        return
                                          // InkWell(onTap: (){
                                          // Get.to(()=>Detailproduct(record: popular[index],));
                                          // },
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            width: 388,
                                            height: 130,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.15),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 10, left: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 41,
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                        6,
                                                      ),
                                                      border: Border.all(
                                                        color:
                                                        ticket[index].color!,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        myText(
                                                          text:
                                                          ticket[index].range,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        myText(
                                                          text:
                                                          ticket[index].date,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${ticket[index].name}',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].img1}'),
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].img2}'),
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].img3}'),
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].img4}'),
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].img5}'),
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].img6}'),
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            child: Image.asset(
                                                              ticket[index].heart,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10),
                                                            child: Text(
                                                              '${ticket[index].count}',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 23,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                '${ticket[index].message}'),
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10),
                                                            child: Text(
                                                              '${ticket[index].rate}',
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 27,
                                                          ),
                                                          Container(
                                                              child: Image(
                                                                image: AssetImage(
                                                                    '${ticket[index].share}'),
                                                                width: 15,
                                                                height: 15,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                      }),
                                  Container(
                                    child: Center(
                                      child: Text('Tab 2',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
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
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 105, right: 35),

                  child: InkWell
                    (
                    onTap: (){


                      if(isNotEditable ==false){
                        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'first': firstNameController.text,
                          'last': lastNameController.text,
                          'location':locationController.text,
                          'desc': descriptionController.text
                        },SetOptions(merge: true)).then((value) {
                          Get.snackbar('Profile Updated', 'Profile has been updated successfully.',colorText: Colors.white,
                              backgroundColor: Colors.blue);
                        });
                      }


                      setState(() {
                        isNotEditable = !isNotEditable;
                      });





                    },
                    child: isNotEditable? Image(
                      image: AssetImage('assets/edit.png'),
                      width: screenwidth * 0.04,
                    ): Icon(Icons.check,color: Colors.black,),
                  ),
                ),
              ),
            isMenuVisible
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: toggleMenu,
                      child: Container(
                        width: screenwidth * 0.4,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black.withOpacity(0.5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: screenwidth * 0.4,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50),
                                ListTile(
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  leading: Icon(Icons.logout, color: Colors.black),
                                  onTap: () {
                                     authController!.logout(); 
                                    toggleMenu();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}