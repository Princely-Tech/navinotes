import 'package:navinotes/packages.dart';

class BoardType {
  final String name;
  final String image;
  final String description;
  final String route;

  BoardType({
    required this.name,
    required this.route,
    required this.image,
    required this.description,
  });
}

List<BoardType> boardTypes = [
  BoardType(
    name: 'Plain',
    image: Images.boardPlain,
    description: 'Clean, distraction-free interface',
    route: '',
  ),
  BoardType(
    name: 'Minimalist',
    image: Images.boardMinimalist,
    description: 'Simplified, essential elements only',
    route: '',
  ),
  BoardType(
    name: 'Dark Academia',
    image: Images.boardAcademiaDark,
    description: 'Vintage scholarly, darker tones',
    route: Routes.boardDarkAcademia,
  ),
  BoardType(
    name: 'Light Academia',
    image: Images.boardAcademiaLight,
    description: 'Bright scholarly, cream tones',
    route: '',
  ),
  BoardType(
    name: 'Nature',
    image: Images.boardNature,
    description: 'Organic patterns, natural colors',
    route: '',
  ),
  BoardType(
    name: 'Pastel',
    image: Images.boardPastel,
    description: 'Soft, muted color palette',
    route: '',
  ),
  BoardType(
    name: 'Tech/Neon',
    image: Images.boardNeon,
    description: 'Digital, vibrant highlights',
    route: '',
  ),
];
