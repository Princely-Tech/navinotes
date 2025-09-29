import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/stylus_settings.dart';

class StylusSettingsDialog extends StatefulWidget {
  final StylusSettings initialSettings;
  final Function(StylusSettings) onSettingsChanged;

  const StylusSettingsDialog({
    Key? key,
    required this.initialSettings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<StylusSettingsDialog> createState() => _StylusSettingsDialogState();
}

class _StylusSettingsDialogState extends State<StylusSettingsDialog>
    with TickerProviderStateMixin {
  late StylusSettings _settings;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateSettings(StylusSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPressureTab(),
                  _buildPalmRejectionTab(),
                  _buildGesturesTab(),
                  _buildAdvancedTab(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.edit,
            size: 28,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Text(
            'Stylus Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.2),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(
            icon: Icon(Icons.touch_app),
            text: 'Pressure',
          ),
          Tab(
            icon: Icon(Icons.pan_tool),
            text: 'Palm Rejection',
          ),
          Tab(
            icon: Icon(Icons.gesture),
            text: 'Gestures',
          ),
          Tab(
            icon: Icon(Icons.tune),
            text: 'Advanced',
          ),
        ],
      ),
    );
  }

  Widget _buildPressureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pressure Sensitivity'),
          _buildSwitchTile(
            'Enable Pressure Sensitivity',
            'Vary stroke width based on stylus pressure',
            _settings.pressureSensitivityEnabled,
            (value) => _updateSettings(
              _settings.copyWith(pressureSensitivityEnabled: value),
            ),
          ),
          if (_settings.pressureSensitivityEnabled) ...[
            const SizedBox(height: 20),
            _buildPressureCurveSelector(),
            const SizedBox(height: 20),
            _buildPressureRangeSliders(),
            const SizedBox(height: 20),
            _buildPressurePreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildPalmRejectionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Palm Rejection'),
          _buildPalmRejectionLevelSelector(),
          const SizedBox(height: 20),
          _buildSwitchTile(
            'Stylus Only Mode',
            'Only accept input from stylus, ignore finger touches',
            _settings.stylusOnlyMode,
            (value) => _updateSettings(
              _settings.copyWith(stylusOnlyMode: value),
            ),
          ),
          _buildSwitchTile(
            'Allow Finger Drawing',
            'Enable drawing with finger when stylus is not detected',
            _settings.fingerDrawingEnabled,
            (value) => _updateSettings(
              _settings.copyWith(fingerDrawingEnabled: value),
            ),
          ),
          const SizedBox(height: 20),
          _buildSliderTile(
            'Palm Rejection Radius',
            'Size of area around palm touches to ignore',
            _settings.palmRejectionRadius,
            20.0,
            100.0,
            (value) => _updateSettings(
              _settings.copyWith(palmRejectionRadius: value),
            ),
            suffix: 'px',
          ),
        ],
      ),
    );
  }

  Widget _buildGesturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Double Tap'),
          _buildSwitchTile(
            'Enable Double Tap',
            'Perform action when double-tapping with stylus',
            _settings.doubleTapEnabled,
            (value) => _updateSettings(
              _settings.copyWith(doubleTapEnabled: value),
            ),
          ),
          if (_settings.doubleTapEnabled) ...[
            const SizedBox(height: 16),
            _buildDoubleTapActionSelector(),
          ],
          const SizedBox(height: 20),
          _buildSectionTitle('Tilt Sensitivity'),
          _buildSwitchTile(
            'Enable Tilt Sensitivity',
            'Adjust stroke appearance based on stylus tilt',
            _settings.tiltSensitivityEnabled,
            (value) => _updateSettings(
              _settings.copyWith(tiltSensitivityEnabled: value),
            ),
          ),
          if (_settings.tiltSensitivityEnabled) ...[
            const SizedBox(height: 16),
            _buildTiltBehaviorSelector(),
            const SizedBox(height: 16),
            _buildSliderTile(
              'Tilt Sensitivity',
              'How much tilt affects the stroke',
              _settings.tiltSensitivity,
              0.0,
              1.0,
              (value) => _updateSettings(
                _settings.copyWith(tiltSensitivity: value),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Hover & Preview'),
          _buildSwitchTile(
            'Show Hover Preview',
            'Display cursor when stylus is near screen',
            _settings.hoverPreviewEnabled,
            (value) => _updateSettings(
              _settings.copyWith(hoverPreviewEnabled: value),
            ),
          ),
          _buildSwitchTile(
            'Show Cursor',
            'Display drawing cursor',
            _settings.showCursor,
            (value) => _updateSettings(
              _settings.copyWith(showCursor: value),
            ),
          ),
          if (_settings.showCursor) ...[
            const SizedBox(height: 16),
            _buildSliderTile(
              'Cursor Opacity',
              'Transparency of the drawing cursor',
              _settings.cursorOpacity,
              0.1,
              1.0,
              (value) => _updateSettings(
                _settings.copyWith(cursorOpacity: value),
              ),
            ),
          ],
          const SizedBox(height: 20),
          _buildSectionTitle('Stroke Smoothing'),
          _buildSwitchTile(
            'Enable Stroke Smoothing',
            'Smooth out jittery strokes for cleaner lines',
            _settings.strokeSmoothingEnabled,
            (value) => _updateSettings(
              _settings.copyWith(strokeSmoothingEnabled: value),
            ),
          ),
          if (_settings.strokeSmoothingEnabled) ...[
            const SizedBox(height: 16),
            _buildSliderTile(
              'Smoothing Level',
              'Amount of smoothing to apply',
              _settings.smoothingLevel,
              0.0,
              1.0,
              (value) => _updateSettings(
                _settings.copyWith(smoothingLevel: value),
              ),
            ),
          ],
          const SizedBox(height: 20),
          _buildSectionTitle('Haptic Feedback'),
          _buildSwitchTile(
            'Enable Haptic Feedback',
            'Provide tactile feedback for gestures',
            _settings.hapticFeedbackEnabled,
            (value) => _updateSettings(
              _settings.copyWith(hapticFeedbackEnabled: value),
            ),
          ),
          if (_settings.hapticFeedbackEnabled) ...[
            const SizedBox(height: 16),
            _buildSliderTile(
              'Haptic Intensity',
              'Strength of haptic feedback',
              _settings.hapticIntensity,
              0.1,
              1.0,
              (value) => _updateSettings(
                _settings.copyWith(hapticIntensity: value),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    String suffix = '',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${value.toStringAsFixed(1)}$suffix',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: Theme.of(context).primaryColor,
              overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPressureCurveSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pressure Curve',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'How pressure input is interpreted',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PressureCurve.values.map((curve) {
              final isSelected = _settings.pressureCurve == curve;
              return GestureDetector(
                onTap: () => _updateSettings(
                  _settings.copyWith(pressureCurve: curve),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    curve.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPressureRangeSliders() {
    return Column(
      children: [
        _buildSliderTile(
          'Minimum Pressure',
          'Lowest pressure value to register',
          _settings.pressureMinimum,
          0.0,
          0.5,
          (value) => _updateSettings(
            _settings.copyWith(pressureMinimum: value),
          ),
        ),
        _buildSliderTile(
          'Maximum Pressure',
          'Highest pressure value to use',
          _settings.pressureMaximum,
          0.5,
          1.0,
          (value) => _updateSettings(
            _settings.copyWith(pressureMaximum: value),
          ),
        ),
      ],
    );
  }

  Widget _buildPressurePreview() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pressure Preview',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Test how pressure affects stroke width',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              painter: PressurePreviewPainter(_settings),
              size: const Size.fromHeight(60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalmRejectionLevelSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Palm Rejection Level',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'How aggressively to reject palm touches',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PalmRejectionLevel.values.map((level) {
              final isSelected = _settings.palmRejectionLevel == level;
              return GestureDetector(
                onTap: () => _updateSettings(
                  _settings.copyWith(palmRejectionLevel: level),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    level.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubleTapActionSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Double Tap Action',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          ...DoubleTapAction.values.map((action) {
            final isSelected = _settings.doubleTapAction == action;
            return GestureDetector(
              onTap: () => _updateSettings(
                _settings.copyWith(doubleTapAction: action),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      action.icon,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      action.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTiltBehaviorSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tilt Behavior',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'How tilt affects the stroke appearance',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TiltBehavior.values.map((behavior) {
              final isSelected = _settings.tiltBehavior == behavior;
              return GestureDetector(
                onTap: () => _updateSettings(
                  _settings.copyWith(tiltBehavior: behavior),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    behavior.name.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _updateSettings(const StylusSettings());
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reset to Defaults'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for pressure preview
class PressurePreviewPainter extends CustomPainter {
  final StylusSettings settings;

  PressurePreviewPainter(this.settings);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const baseWidth = 4.0;
    const steps = 20;
    
    for (int i = 0; i < steps; i++) {
      final t = i / (steps - 1);
      final x = t * size.width;
      final y = size.height / 2;
      
      // Simulate pressure from 0.1 to 1.0
      final rawPressure = 0.1 + (0.9 * t);
      final adjustedPressure = settings.getPressureValue(rawPressure);
      final strokeWidth = baseWidth * adjustedPressure;
      
      paint.strokeWidth = strokeWidth;
      
      final startPoint = Offset(x, y - strokeWidth / 2);
      final endPoint = Offset(x, y + strokeWidth / 2);
      
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(PressurePreviewPainter oldDelegate) {
    return oldDelegate.settings != settings;
  }
}
