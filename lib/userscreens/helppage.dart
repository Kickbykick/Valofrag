import 'package:flutter/material.dart';
import 'package:valorant_helper/shared/contants.dart';
import 'package:valorant_helper/shared/weapon_details_icons_icons.dart';

class HelpPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help", style: TextStyle(color: Constants.WineColor),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
          //     Table(
          //   border: TableBorder.all(color: Colors.black),
          //   children: [
          //     TableRow(children: [
          //       Text('Cell 1'),
          //       Text('Cell 2'),
          //       Text('Cell 3'),
          //     ]),
          //     TableRow(children: [
          //       Text('Cell 4'),
          //       Text('Cell 5'),
          //       Text('Cell 6'),
          //     ])
          //   ],
          // ),

          _createImage("images/ability_charge_1.png", "1 rate of ability charge."),
          _createImage("images/ability_charge_2.png", "2 rate of ability charge."),
          _createImage("images/ability_charge_3.png", "3 rate of ability charge."),

              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Icons',
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Icon(WeaponDetailsIcons.magazine)),
                      DataCell(Text('Magazine: storage places for cartridges in firearms in general.')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Icon(WeaponDetailsIcons.fire_rate)),
                      
                      DataCell(Text('Rate of fire: the frequency at which a specific weapon can fire or launch its projectiles.')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Icon(WeaponDetailsIcons.wall_penetration)),
                      DataCell(Text('Wall penetration: Level of wall penetration of each weapon.')),
                    ],
                  ),

                ],
              ),
            ]
          ),
        ),
      )
    );
  }

  Widget _createImage(String helpImg, String info){
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: new BoxDecoration(
          image: new DecorationImage(
            image: AssetImage(helpImg),
            fit: BoxFit.contain,
            ),
        )),
        Text(info, maxLines: null,)
      ],
    );
  }
}