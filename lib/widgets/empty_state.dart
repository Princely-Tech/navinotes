import 'package:navinotes/packages.dart';

class EmptyState extends StatelessWidget {
  /// Creates a centered empty state widget with an icon, title, and subtitle.
  ///
  /// The [icon] is typically an [Icons] or [CustomIcons] value.
  /// The [title] is displayed in a larger, bolder font.
  /// The [subtitle] provides additional context and is displayed below the title.
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.footer,
    this.padding = const EdgeInsets.all(24.0),
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? footer;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).hintColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(
                  context,
                ).textTheme.titleLarge?.color?.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isNotNull(footer)) ...[const SizedBox(height: 24), footer!],
          ],
        ),
      ),
    );
  }
}
