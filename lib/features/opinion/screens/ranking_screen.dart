import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/widgets/partner_footer.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      child: Column(
        children: [
          16.vSpacing,
          SvgPicture.asset(
            "images/logo.svg",
            width: 280,
          ),
          16.vSpacing,
          Text(
            "Rangliste der Weiterempfehlungen",
            style: context.typography.headlineLarge,
            textAlign: TextAlign.center,
          ),
          48.vSpacing,
          Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  "#",
                  style: context.typography.bodyLarge,
                ),
              ),
              Text(
                "Nutzer",
                style: context.typography.bodyLarge,
              ),
              const Spacer(),
              Text(
                "Empfehlungen",
                style: context.typography.bodyLarge,
              ),
            ],
          ),
          12.vSpacing,
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      "${index + 1}",
                      style: context.typography.bodyLarge,
                    ),
                  ),
                  Text(
                    "Max Mustermann",
                    style: context.typography.bodyLarge,
                  ),
                  const Spacer(),
                  Text(
                    "10",
                    style: context.typography.bodyLarge,
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: 10,
          ),
          96.vSpacing,
          const PartnerFooter(),
          96.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}
