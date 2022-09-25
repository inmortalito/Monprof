import 'package:flutter/material.dart';

class Live extends StatefulWidget {
  @override
  _Live createState() => _Live();
}

class _Live extends State<Live> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    int coursID = arguments['coursId'];
    String coursTitle = arguments['coursTitle'];

    return Scaffold(
      body: Container(
        color: Color(0xffE5E5EF),
        child: CustomScrollView(slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Color(0xff29303b),
            centerTitle: true,
            title: Text(
              "Live : " + coursTitle,
              style: TextStyle(fontSize: 16.0),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 18.0,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    /* Navigator.push(
                  context,
                  _menuRoute(
                      details.course.id, isFav, isPur, details, markedChpIds),
                );*/
                  },
                  child: Image.asset("assets/icons/coursedetailmenu.png",
                      width: 17),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1,
              children: [
                Card(
                  //color: Colors.blue[200],
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 120.0,
                          //width: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/live.png'),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                              "Objectifs L'entreprise est un agent économique, combinant pédagogiques des facteurs production"),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Colors.blue[400],
                  child: Container(),
                ),
                Card(
                  color: Colors.blue[600],
                  child: Container(),
                ),
                Card(
                  color: Colors.blue[100],
                  child: Container(),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
    throw UnimplementedError();
  }
}
