import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  TableWidget({super.key});

  final Stream<QuerySnapshot> _vendorStream = FirebaseFirestore.instance.collection('vendors').snapshots();

  _approveMethod(String docID, bool approve) async{
    DocumentReference documentRef = FirebaseFirestore.instance.collection('vendors').doc(docID);
    documentRef.update({
      'approve': approve
    }).then((value) {
      print('Document updated');
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Table(
          border: TableBorder.all(color: Colors.black12),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
             const TableRow(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("LOGO"),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("BUSINESS NAME"),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("CITY"),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("STATE"),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("ACTIVE"),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("VIEW MORE"),
                  ),
                ),
              ],
            ),
            ...List.generate(
                snapshot.data!.docs.length,
                    (index) => TableRow(
                  children:[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.network(
                          snapshot.data!.docs[index]['image'],
                          width: 10,
                          height: 10,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.docs[index]['businessName']),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.docs[index]['city']),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.docs[index]['state']),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: (){
                              _approveMethod(snapshot.data!.docs[index].id, !snapshot.data!.docs[index]['approve']);
                            },
                            child: Text(snapshot.data!.docs[index]['approve'].toString()),

                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {},
                          child: Text("View More"),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        );
      },
    );
  }
}
