import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/address.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/edit_address_view.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

class AddressModal extends StatefulWidget {
  const AddressModal({Key? key}) : super(key: key);

  @override
  State<AddressModal> createState() => _AddressModalState();
}

class _AddressModalState extends State<AddressModal> {
  // List<UserAddress> _addresses = [
  //   UserAddress('Москва, солнечная 6', 1, 2, 3, '', true, false),
  //   UserAddress('Торжок, улица ленина 2', 4, 1, 1, '', false, false),
  //   UserAddress('Бежецк', 6, 2, 3, '', false, false),
  // ];
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    if (provider.addresses.isEmpty) {
      print('123123123');
      provider.updateAddresses(
          [UserAddress('', null, null, null, '', false, false, null)]);
    }
    // provider.updateAddresses([]);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ваши адреса',
                      style: GoogleFonts.rubik(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.addresses.length,
                  itemBuilder: (context, index) {
                    return _addressesWidget(index, provider.addresses);
                  },
                ),
                const SizedBox(height: 15),
                ScaleButton(
                  onTap: () {
                    setState(() {
                      provider.addresses.add(
                        UserAddress(
                            '', null, null, null, '', false, false, null),
                      );
                    });
                  },
                  bound: 0.05,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: red,
                      // boxShadow: shadow,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Добавить новый',
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 30,
              margin: const EdgeInsets.only(top: 10),
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }

  ScaleButton _addressesWidget(int index, List<UserAddress> addresses) {
    var provider = Provider.of<DataProvider>(context);
    return ScaleButton(
      bound: 0.05,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: !addresses[index].editing ? 65 : 235,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: shadow
            // border: Border.all(
            //   width: 1,
            //   color: Colors.grey[300]!,
            // ),
            ),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: !addresses[index].editing
            ? _addressListTile(index, addresses, provider)
            : EditAddressView(
                userAddress: addresses[index],
                onRemove: () {
                  setState(() {
                    addresses.removeAt(index);
                    provider.updateAddresses(addresses);
                  });
                },
                onChanged: (userAddress) {
                  setState(() {
                    addresses[index] = userAddress;
                  });
                  provider.updateAddresses(addresses);
                  if (addresses[index].selected) {
                    provider.setUserAddress(userAddress.address);
                    provider.setUserLatLng(userAddress.latLng!);
                    provider.setUserEntrance(
                      addresses[index].entrance != null
                          ? addresses[index].entrance.toString()
                          : '',
                    );

                    provider.setUserFloor(
                      addresses[index].floor != null
                          ? addresses[index].floor.toString()
                          : '',
                    );
                    provider.setUserRoom(
                      addresses[index].room != null
                          ? addresses[index].room.toString()
                          : '',
                    );
                  }
                },
              ),
      ),
    );
  }

  GestureDetector _addressListTile(
      int index, List<UserAddress> addresses, DataProvider provider) {
    return GestureDetector(
      onTap: () {
        print(addresses[index].toJson());
        if (addresses[index].address != '') {
          setState(() {
            addresses.forEach((element) {
              if (addresses.any((element) => element.editing == true)) {
                element.editing = false;
              }
              element.selected = false;
            });
            provider.setUserLatLng(addresses[index].latLng!);
            provider.setUserAddress(addresses[index].address);
            provider.setUserEntrance(
              addresses[index].entrance != null
                  ? addresses[index].entrance.toString()
                  : '',
            );

            provider.setUserFloor(
              addresses[index].floor != null
                  ? addresses[index].floor.toString()
                  : '',
            );
            provider.setUserRoom(
              addresses[index].room != null
                  ? addresses[index].room.toString()
                  : '',
            );
            addresses[index].selected = true;
          });
        } else {
          if (addresses[index].latLng != null) {
            print('123123');
            setState(() {
              addresses[index].editing = true;
            });
          } else {
            MyFlushbar.showFlushbar(context, 'Внимание',
                'Чтобы выбрать адрес, необходимо заполнить информацию.');
          }
        }
      },
      child: ListTile(
        leading: SizedBox(
          width: 40,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: addresses[index].selected ? Colors.green[200] : null,
                shape: BoxShape.circle,
                border: !addresses[index].selected
                    ? Border.all(
                        width: 1,
                        color: Colors.grey[200]!,
                      )
                    : null,
              ),
              child: addresses[index].selected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),
        ),
        title: Text(
          addresses[index].address != ''
              ? addresses[index].address
              : 'Адрес не выбран',
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: addresses[index].address != ''
                ? Colors.black
                : Colors.grey[500],
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              addresses[index].editing = !addresses[index].editing;
            });
          },
          child: Icon(
            Icons.mode_edit_rounded,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
