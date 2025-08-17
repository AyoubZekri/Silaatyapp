import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/constant/imageassets.DART';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Handlingview extends StatelessWidget {
  final Statusrequest statusrequest;
  final Widget widget;

  const Handlingview({
    super.key,
    required this.statusrequest,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusrequest) {
      case Statusrequest.loadeng:
      case Statusrequest.none:
        return Center(child: Lottie.asset(Appimageassets.loading, width: 190));
      case Statusrequest.serverfailure:
        return Center(child: Lottie.asset(Appimageassets.server, width: 190));
      case Statusrequest.offlinefailure:
        return Center(child: Lottie.asset(Appimageassets.offline, width: 190));
      case Statusrequest.failure:
        return ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Lottie.asset(Appimageassets.nodata, width: 190),
                ],
              ),
            ),
          ],
        );
      default:
        return widget;
    }
  }
}

class Handlingviewfrom extends StatelessWidget {
  final Statusrequest statusrequest;
  final Widget widget;

  const Handlingviewfrom({
    super.key,
    required this.statusrequest,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusrequest) {
      case Statusrequest.loadeng:
        return Center(child: Lottie.asset(Appimageassets.loading, width: 190));
      case Statusrequest.offlinefailure:
        return Center(child: Lottie.asset(Appimageassets.offline, width: 190));
      case Statusrequest.serverfailure:
        return Center(child: Lottie.asset(Appimageassets.server, width: 190));
      case Statusrequest.failure:
        return Center(child: Lottie.asset(Appimageassets.nodata, width: 190));
      default:
        return widget;
    }
  }
}

class HandlingviewAuth extends StatelessWidget {
  final Statusrequest statusrequest;
  final Widget widget;

  const HandlingviewAuth({
    super.key,
    required this.statusrequest,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusrequest) {
      case Statusrequest.loadeng:
        return Center(child: Lottie.asset(Appimageassets.loading, width: 190));
      case Statusrequest.offlinefailure:
        return Center(child: Lottie.asset(Appimageassets.offline, width: 190));
      case Statusrequest.serverfailure:
        return Center(child: Lottie.asset(Appimageassets.server, width: 190));
      default:
        return widget;
    }
  }
}

class Handlingviewhome extends StatelessWidget {
  final Statusrequest statusrequest;
  final Widget widget;

  const Handlingviewhome({
    super.key,
    required this.statusrequest,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusrequest) {
      case Statusrequest.loadeng:
      case Statusrequest.none:
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );

      case Statusrequest.serverfailure:
        return ListView(
          children: [
            const SizedBox(height: 100),
            Center(child: Lottie.asset(Appimageassets.server, width: 190)),
          ],
        );

      case Statusrequest.failure:
        return ListView(
          children: [
            const SizedBox(height: 100),
            Center(child: Lottie.asset(Appimageassets.nodata, width: 190)),
          ],
        );

      case Statusrequest.offlinefailure:
        return ListView(
          children: [
            const SizedBox(height: 100),
            Center(child: Lottie.asset(Appimageassets.offline, width: 190)),
          ],
        );

      default:
        return widget;
    }
  }
}
