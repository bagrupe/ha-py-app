part of 'antrag_layout.dart';

class _AntragContentLoadingPlaceholder extends StatelessWidget {
  const _AntragContentLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('antrag_content_loading_placeholder'),
      padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Skeletonizer.zone(
        effect: ShimmerEffect(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone(
              height: 34,
              width: 220,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            SizedBox(height: 28),
            Bone(
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            SizedBox(height: 16),
            Bone(
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            SizedBox(height: 16),
            Bone(
              height: 112,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
