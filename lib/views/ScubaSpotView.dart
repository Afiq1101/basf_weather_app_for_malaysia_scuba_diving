

import 'dart:ui';

import 'package:basf_weather_app_for_malaysia_scuba_diving/models/ScubaSpotModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/widget/InkWellButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../viewModels/ScubaSpotViewModel.dart';

class ScubaSpotView extends StatelessWidget {
  final Function(ScubaSpotModel) changeLocation;
  const ScubaSpotView({super.key, required this.changeLocation});


  @override
  Widget build(BuildContext context) {
    const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 8);
    return ChangeNotifierProvider(
      create: (_) => ScubaSpotViewModel(),
      child: Consumer<ScubaSpotViewModel>(
          builder: (context, scubaSpotViewModel, _) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: AnimatedOpacity(
                    opacity: scubaSpotViewModel.titleOpacity,
                    duration: const Duration(milliseconds: 200),
                    child: Text("Locations",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,letterSpacing:0,
                        color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),)),
                leading: IconButton(icon: Icon(Icons.arrow_back_rounded,color: Theme.of(context).primaryColorDark.withValues(alpha: 1),size: 30,), onPressed: () { Navigator.of(context).pop(); },),
              ),
              body: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  onNotification: scubaSpotViewModel.handleScrollNotification,
                  child: CustomScrollView(
                    controller: scubaSpotViewModel.scrollController,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: horizontalPadding,
                        sliver: SliverToBoxAdapter(
                          child: Container(
                              alignment: AlignmentDirectional.bottomStart,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              key: scubaSpotViewModel.titleSliverKey,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Locations',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 35,letterSpacing:0,
                                      color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                                ),
                              )
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PersistentHeader(
                          child: Container(
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(18,12,18,12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha:0.2),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 8,
                                      child: TextField(
                                        focusNode: scubaSpotViewModel.focusNode,
                                        onTapOutside: (details){
                                          scubaSpotViewModel.focusNode.unfocus();
                                        },
                                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                            color: Theme.of(context).primaryColorDark.withValues(alpha: 1),letterSpacing: -0.5),
                                        textInputAction: TextInputAction.search,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                          const EdgeInsets.fromLTRB(0, 9, 0, 0),
                                          counterText: '',
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          enabledBorder: InputBorder.none,
                                          hintText: "Search for diving spot",
                                          hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: Theme.of(context).primaryColorDark.withValues(alpha: 0.2),letterSpacing: -0.5),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(0,9,0,9),
                                            child: SizedBox(
                                              height: 12,
                                              width: 12,
                                              child: SvgPicture.asset(
                                                "assets/svg/sw_search.svg",
                                                colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.2), BlendMode.srcIn),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (text){
                                          scubaSpotViewModel.searchScubaSpots(text);
                                        },
                                      ),
                                    ),
                                    Flexible(flex:1, child: IconButton(onPressed: (){scubaSpotViewModel.addCurrentLocationToScubaSpot();}, icon: Icon(CupertinoIcons.location_solid,size: 20, color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7)  )))

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      scubaSpotViewModel.isLoading ?    SliverToBoxAdapter(child: ScubaSpotLoadingWidget()):    SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return ScubaLocationTile(scubaSpotModel: scubaSpotViewModel.filteredSpots[index], changeLocation: changeLocation, deleteLocation: scubaSpotViewModel.deleteLocation,);
                          },
                          addAutomaticKeepAlives:true,
                          childCount: scubaSpotViewModel.filteredSpots.length,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
      ),

    );
  }

}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  PersistentHeader({required this.child});

  @override
  double get minExtent => 60; // Min header header
  @override
  double get maxExtent => 60; // Max header height

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

//reusable tile for scuba locations
class ScubaLocationTile extends StatelessWidget {
  final ScubaSpotModel scubaSpotModel;
  final Function(ScubaSpotModel) changeLocation;
  final Function(ScubaSpotModel) deleteLocation;
  const ScubaLocationTile({super.key, required this.scubaSpotModel, required this.changeLocation, required this.deleteLocation});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Padding(
      padding: const EdgeInsets.fromLTRB(18,0,18,12),
      child: GestureDetector(
        onTap: (){
          changeLocation(scubaSpotModel);
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all( Radius.circular(16.0)),
            border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.orangeAccent, Colors.redAccent]),
          ),
          width: size.width-40,
          height: size.width*0.29,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,11,16,11),
            child: Stack(
              children: [
                Container(
                  width: size.width-80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          scubaSpotModel.scubaSpotLabel,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 21,letterSpacing:0,
                              color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        scubaSpotModel.regionLabel,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 15,letterSpacing:0,
                            color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                      ),
                      Spacer(),
                      Text(
                        scubaSpotModel.countryLabel,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 15,letterSpacing:0,
                            color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: scubaSpotModel.saveType != "json_file" ? SizedBox.shrink() :  Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: GestureDetector(
                        onTap: (){
                          showDeleteConfirmationDialog(
                              context: context,
                              scubaPot: scubaSpotModel,
                              onConfirm:(){
                                deleteLocation(scubaSpotModel);
                              });
                        },
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: SvgPicture.asset(
                            "assets/svg/sw_options_circle.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 1), BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> showDeleteConfirmationDialog({required BuildContext context,required ScubaSpotModel scubaPot, required VoidCallback onConfirm}) async {
      showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title:   Text('Delete Spot'),
          content:  Text('Are you sure you want to delete "${scubaPot.scubaSpotLabel}"?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
  }
}

class ScubaSpotLoadingWidget extends StatelessWidget {
  const ScubaSpotLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
        ),
        height: size.width,
        width: size.width,
        child:const Center(child: CupertinoActivityIndicator(radius: 18,color: Colors.white,)),
      ),
    ),
    );
  }
}




