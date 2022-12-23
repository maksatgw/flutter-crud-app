// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_crud/model/product_model.dart';
import 'package:flutter_crud/services/product_service.dart';

class ProductGetPage extends StatefulWidget {
  const ProductGetPage({super.key});

  @override
  State<ProductGetPage> createState() => _ProductGetPageState();
}

class _ProductGetPageState extends State<ProductGetPage> {
  //[1] ProductModel'imizi liste olarak alacagimiz icin liste olarak tanimladik.
  List<ProductModel>? _model;
  ProductModel? _models;

  //[2] ProductService classindaki metodlari initstate icinde esitleyecedigimiz icin late final olarak bir nesne turetiyoruz
  late final ProductService _services;

  //[3] circularProgressBar kontrolu icin boolean bir degisken turetiyoruz
  bool _isLoading = false;

  //[6] Alertialog icindeki textfieldlar icin controller olusturuyoruz

  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _services = ProductService();
    //[5] get methodumuzu cagiriyoruz
    _getProductsFromService();
  }

  //[4] Metodlarimizi initstatein altina yaziyoruz
  //[4]-[1] isLoading'i kullanildigi anda false veya true yapan fonksiyonumuzu yaziyoruz
  void _changeLoading() {
    setState(() {
      //isLoading hangi durumda ise onu tersine cevir
      _isLoading = !_isLoading;
    });
  }

  //[4]-[2] Get metodumuzu cagirip kullanacagimiz fonksiyonu yaziyoruz.
  Future<void> _getProductsFromService() async {
    //changeLoading fonksiyonunu cagirarak false durumunu true yapiyoruz. boylelikle data gelmeden once true durumunda olacak
    _changeLoading();

    //Get methodumuzu listemiz bkz[1] ile esitliyoruz
    _model = await _services.getProducts();

    //changeloading'i tekrar cagirarak false durumuna getiriyoruz
    _changeLoading();
  }

  //Buton metodlarini [put - del - post] buraya cekerek kodumuzu temizlemis oluyoruz

  //

  Future<void> _putDataToService(ProductModel? productModel, int? id) async {
    _changeLoading();

    var _result = await _services.putProducts(productModel, id);
    if (_result = true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Başarılı"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hata"),
      ));
    }
    _getProductsFromService();
    Navigator.of(context).pop();
    _changeLoading();
  }

  Future<void> _delDataFromService(int? id) async {
    _changeLoading();

    var _result = await _services.delProducts(id);
    if (_result = true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Başarılı"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hata"),
      ));
    }
    _getProductsFromService();
    _changeLoading();

    Navigator.of(context).pop();
  }

  Future<void> _postItems(ProductModel productModel) async {
    _changeLoading();
    _services.postProducts(productModel);
    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _brandController,
                          decoration: InputDecoration(
                            hintText: "Brand",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _modelController,
                          decoration: InputDecoration(
                            hintText: "Model",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            hintText: "Price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _stockController,
                          decoration: InputDecoration(
                            hintText: "Stock",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 215,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            final _models = ProductModel(
                                brand: _brandController.text,
                                model: _modelController.text,
                                stock: int.parse(_stockController.text),
                                price: int.parse(_priceController.text));
                            var _response =
                                await _services.postProducts(_models);

                            if (_response == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Başarılı"),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Hata"),
                              ));
                            }
                            _getProductsFromService();

                            Navigator.of(context).pop();
                            _brandController.text = "";
                            _priceController.text = "";
                            _stockController.text = "";
                            _modelController.text = "";
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      //_model listem null degil ise listeyi null ise circular progress indicatoru gonder
      body: _model != null
          ? ListView.builder(
              //_model listesi null ise listenin sayisini 0 ver
              itemCount: _model?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${_model?[index].brand}"),
                  subtitle: Text("${_model?[index].model}"),
                  onTap: () {
                    final txt =
                        TextEditingController(text: _model?[index].brand);
                    final txt2 =
                        TextEditingController(text: _model?[index].model);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 500,
                                      child: TextField(
                                        controller: txt,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 500,
                                      child: TextField(
                                        controller: txt2,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: const Text('Save'),
                                    onPressed: () async {
                                      // [1] Güncellenen veriyi _models nesnesine ata
                                      _models = ProductModel(
                                        id: _model?[index].id,
                                        brand: txt.text,
                                        model: txt2.text,
                                      );
                                      _putDataToService(
                                          _models, _model?[index].id);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text("Delete"),
                                      onPressed: () async =>
                                          _delDataFromService(
                                              _model?[index].id),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
