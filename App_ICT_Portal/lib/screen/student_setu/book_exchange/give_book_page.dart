import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:image_picker/image_picker.dart';

class GiveBookPage extends StatefulWidget {
  @override
  _GiveBookPageState createState() => _GiveBookPageState();
}

class _GiveBookPageState extends State<GiveBookPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  String? sellType;
  TextEditingController priceRentController = TextEditingController();
  XFile? bookImageFile;
  XFile? coverImageFile;
  XFile? endPageImageFile;
  XFile? randomPage1ImageFile;
  XFile? randomPage2ImageFile;
  XFile? randomPage3ImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Give Book'),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: bookNameController,
                  decoration: InputDecoration(
                    labelText: 'Book Name', // Label text without the asterisk
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Book Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Author is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: sellType,
                  onChanged: (newValue) {
                    setState(() {
                      sellType = newValue;
                    });
                  },
                  items: ['Free', 'Rent', 'Sell'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Book Sell Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Book Sell Type is required';
                    }
                    return null;
                  },
                ),
                if (sellType != null && sellType != 'Free') ...[
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: priceRentController,
                    decoration: InputDecoration(
                      labelText: 'Price / Rent',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price / Rent is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Price / Rent must be a number';
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: 16.0),
                buildImagePickerWidget(
                  'Pick image of book',
                  () async {
                    XFile? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      setState(() {
                        bookImageFile = pickedImage;
                      });
                    }
                  },
                  bookImageFile,
                ),
                buildImagePickerWidget(
                  'Pick cover of book',
                  () async {
                    XFile? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      setState(() {
                        coverImageFile = pickedImage;
                      });
                    }
                  },
                  coverImageFile,
                ),
                buildImagePickerWidget(
                  'Pick end page of book',
                  () async {
                    XFile? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      setState(() {
                        endPageImageFile = pickedImage;
                      });
                    }
                  },
                  endPageImageFile,
                ),
                buildImagePickerWidget(
                  'Pick random page of book',
                  () async {
                    XFile? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      setState(() {
                        randomPage1ImageFile = pickedImage;
                      });
                    }
                  },
                  randomPage1ImageFile,
                ),
                buildImagePickerWidget(
                  'Pick random page of book',
                  () async {
                    XFile? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      setState(() {
                        randomPage2ImageFile = pickedImage;
                      });
                    }
                  },
                  randomPage2ImageFile,
                ),
                buildImagePickerWidget(
                  'Pick random page of book',
                  () async {
                    XFile? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      setState(() {
                        randomPage3ImageFile = pickedImage;
                      });
                    }
                  },
                  randomPage3ImageFile,
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        bookImageFile != null) {
                      String bookName = bookNameController.text;
                      String author = authorController.text;
                      String? selectedSellType = sellType;
                      String priceRent = priceRentController.text;

                      print('Book Name: $bookName');
                      print('Author: $author');
                      print('Book Sell Type: $selectedSellType');
                      if (sellType != 'Free') {
                        print('Price / Rent: $priceRent');
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Submission Successful'),
                            content:
                                Text('Book details submitted successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      bookNameController.clear();
                      authorController.clear();
                      priceRentController.clear();
                      setState(() {
                        bookImageFile = null;
                        coverImageFile = null;
                        endPageImageFile = null;
                        randomPage1ImageFile = null;
                        randomPage2ImageFile = null;
                        randomPage3ImageFile = null;
                      });
                    } else if (bookImageFile == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Image Not Selected'),
                            content: Text('Please pick an image of the book.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImagePickerWidget(
    String labelText,
    VoidCallback onPressed,
    XFile? imageFile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.0),
        Row(
          children: [
            Text(
              labelText,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Pick Image'),
        ),
        if (imageFile != null) ...[
          SizedBox(height: 8.0),
          Image.file(
            File(imageFile.path),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
        ],
      ],
    );
  }

  Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    return pickedImage;
  }
}
