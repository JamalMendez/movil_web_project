import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidgetList extends StatelessWidget {
   BannerWidgetList({super.key});
  final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance.collection('banners').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 6,
              crossAxisSpacing: 8
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.network(snapshot.data!.docs[index]['image'],
                  width: 120,
                  height: 120,
                ),
                //Text(snapshot.data!.docs[index]['categoryName'])
              ],
            );
          },);
      },
    );
  }
}
