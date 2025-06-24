import 'package:navinotes/packages.dart';
import 'vm.dart';

class AboutMeProfilePic extends StatelessWidget {
  const AboutMeProfilePic({super.key, this.size = 55});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Consumer<AboutMeVm>(
      builder: (_, vm, _) {
        bool hasImage = isNotNull(vm.image);
        return OutlinedChild(
          size: size,
          decoration: BoxDecoration(
            color: AppTheme.pastelBloom,
            border: Border.all(color: AppTheme.skyFoam),
            shape: BoxShape.circle,
            image:
                hasImage
                    ? DecorationImage(
                      image: FileImage(vm.image!),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              hasImage
                  ? const SizedBox.shrink()
                  : SVGImagePlaceHolder(imagePath: Images.logo, size: 22),
        );
      },
    );
  }
}
