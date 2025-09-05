import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/core/style.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2, // Specifies 2 columns for a 2x2 grid
                padding: const EdgeInsets.all(16.0), // Adds padding around the grid
                mainAxisSpacing:
                    50, // Spacing between items along the main axis (vertical)
                crossAxisSpacing:
                    50, // Spacing between items along the cross axis (horizontal)
                children: <Widget>[
                  // Example children widgets for the grid cells
                  InkWell(onTap: (){
                    context.push('/assets_music');
                  }, child: collection('Lofi Chill')),
                  InkWell(onTap: (){
                    context.push('/assets_music');
                  }, child: collection('3am')),
                  InkWell(onTap: (){
                    context.push('/assets_music');
                  }, child: collection('StayWithMe')),
                  InkWell(onTap: (){
                    context.push('/assets_music');
                  }, child: collection('BePresent')),
                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget collection(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: IMAppColor.appWhite, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/icon-play.png')),
            SizedBox(height: 5,),
            Text(title, style: TextStyle(color: IMAppColor.appWhite)),
          ],
        ),
      ),
    );
  }
}
