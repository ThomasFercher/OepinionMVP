import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/widgets/partner_footer.dart';
import 'package:oepinion/main.dart';

Future<List<(String, int)>> getRankings() async {
  final result = await supabase
      .from('referals')
      .select('referal_count, nicknames(nickname)')
      .order('referal_count', ascending: false)
      .limit(10);

  return result
      .map((e) =>
          (e['nicknames']['nickname'] as String, e['referal_count'] as int))
      .toList();
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late final Future<List<(String, int)>> future;
  @override
  void initState() {
    future = getRankings();
    super.initState();
  }

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
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                );
              }

              final data = snapshot.data as List<(String, int)>? ?? [];

              return ListView.separated(
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
                        data[index].$1,
                        style: context.typography.bodyLarge,
                      ),
                      const Spacer(),
                      Text(
                        data[index].$2.toString(),
                        style: context.typography.bodyLarge,
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: data.length,
              );
            },
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
