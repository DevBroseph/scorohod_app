import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/address.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/services/constants.dart';

class EditAddressView extends StatelessWidget {
  final Function(UserAddress) onChanged;
  final Function() onRemove;
  final UserAddress userAddress;
  const EditAddressView({
    Key? key,
    required this.onChanged,
    required this.userAddress,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng? latLng;
    print('room: ' + userAddress.room.toString());
    print("entrance: " + userAddress.entrance.toString());
    print('floor: ' + userAddress.floor.toString());
    TextEditingController _addressController = TextEditingController(
      text: userAddress.address,
    );
    TextEditingController _roomController = TextEditingController(
      text: userAddress.room != null ? userAddress.room.toString() : '',
    );
    TextEditingController _entranceController = TextEditingController(
      text: userAddress.entrance != null ? userAddress.entrance.toString() : '',
    );
    TextEditingController _floorController = TextEditingController(
      text: userAddress.floor != null ? userAddress.floor.toString() : '',
    );
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
          height: 55,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[100],
          ),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: TextField(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    close: () {
                      Navigator.pop(context);
                    },
                    onSelect: (address, coordinates) {
                      Navigator.pop(context);
                      latLng = coordinates;
                      _addressController.text = address;
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              );
            },
            // enabled: false,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.black,
            ),
            controller: _addressController,
            decoration: InputDecoration.collapsed(
              hintText: 'Введите адрес',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      'Кв/Офис',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.2,
                        fontFamily: 'SFUI',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 10,
                      top: 5,
                    ),
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[100],
                      // border: Border.all(width: 0, color: red),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _roomController,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                        hintText: 'Кв/офис',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Подъезд',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.2,
                        fontFamily: 'SFUI',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                    ),
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[100],
                      // border: Border.all(width: 0, color: red),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _entranceController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Подъезд',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      'Этаж',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.2,
                        fontFamily: 'SFUI',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 5,
                    ),
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[100],
                      // border: Border.all(width: 0, color: red),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _floorController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Этаж',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: ScaleButton(
                onTap: () {
                  onChanged(
                    UserAddress(
                      _addressController.text,
                      int.tryParse(_floorController.text),
                      int.tryParse(_entranceController.text),
                      int.tryParse(_roomController.text),
                      '',
                      userAddress.selected,
                      false,
                      latLng ?? userAddress.latLng,
                    ),
                  );
                  // setState(() {
                  //   _addresses[index].editind = !_addresses[index].editind;
                  // });
                },
                bound: 0.05,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: red,
                    // boxShadow: shadow,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Сохранить',
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ScaleButton(
              onTap: () {
                onRemove();
                // setState(() {
                //   _addresses[index].editind = !_addresses[index].editind;
                // });
              },
              bound: 0.05,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: red,
                  // boxShadow: shadow,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.delete_outline_rounded, color: Colors.white),
              ),
            )
          ],
        )
      ],
    );
    ;
  }
}
