import 'package:flutter/material.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/services/barang.dart';
import 'package:toko_online/widgets/alert.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class BarangView extends StatefulWidget {
  const BarangView({super.key});

  @override
  State<BarangView> createState() => _BarangViewState();
  
}

class _BarangViewState extends State<BarangView> { 
  BarangService barang = BarangService();
  List action =["Update", "Hapus"];
  List? film;
  getfilm() async {
    ResponseDataList getBarang = await barang.getBarang();
    setState(() {
      film = getBarang.data;
    });
  }

  @override
  void initState () {
    super.initState();
    getfilm();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barang"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) =>
              tambahBarangView(title: "Tambah Barang", item : {})));
          }, 
          icon: Icon (Icons.add)),
        ],
        ),
        body: film != null
        ? ListView.builder(
          itemCount: film!.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(film! [index].title),
                trailing: 
                PopupMenuButton(itemBuilder: (BuildContext content) {
                  return action.map((r) {
                    return PopupMenuItem(
                      onTap: () async {
                        if (r == "Update") {
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => tambahBarangView(
                                            title: "Update Barang",
                                            item: film![index])));
                        } else {
                          var results = await AlertMessage()
                          .showAlertDialog(context);
                          if (results != null &&
                              results.containsKey('status')) {
                            if (results['status'] == true) {
                              var res = await barang.hapusBarang(
                                context, film![index].id);
                                if (res.status == true) {
                                  AlertMessage().showAlert(
                                    context, res.message, true);
                                  getfilm();  
                                } else {
                                  AlertMessage().showAlert(
                                    context, res.message, false);
                              }
                            }
                          }
                        }
                      },
                      value: r,
                      child:Text(r), //wajib ada ketika ada action.map
                    );
                  }).toList(); //perlu ini jika ada map.()
                }),
                leading: Image(image: NetworkImage(film![index].posterPath)),
              ),
            );
          })
       : Center(
          child: CircularProgressIndicator(),
       ),
      bottomNavigationBar: BottomNav(1),
    );   
  }
  tambahBarangView({required String title, required Map item}) {}
}
