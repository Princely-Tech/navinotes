import 'package:flutter/material.dart';
import '../vm.dart';
import '../models/stylus_settings.dart';
import 'stylus_settings_dialog.dart';

/// Demo widget to showcase stylus functionality
class StylusDemoWidget extends StatefulWidget {
  final NoteCreationVm vm;

  const StylusDemoWidget({Key? key, required this.vm}) : super(key: key);

  @override
  State<StylusDemoWidget> createState() => _StylusDemoWidgetState();
}

class _StylusDemoWidgetState extends State<StylusDemoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.draw, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Stylus & Pressure Sensitivity',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showStylusSettings(),
                icon: const Icon(Icons.settings),
                tooltip: 'Stylus Settings',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status indicators
          _buildStatusIndicators(),

          const SizedBox(height: 16),

          // Feature highlights
          _buildFeatureHighlights(),

          const SizedBox(height: 16),

          // Quick actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Column(
      children: [
        _buildStatusRow(
          'Stylus Connected',
          widget.vm.isStylusConnected,
          widget.vm.detectedStylusType.displayName,
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'Pressure Sensitivity',
          widget.vm.stylusSettings.pressureSensitivityEnabled,
          widget.vm.stylusSettings.pressureCurve.displayName,
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'Palm Rejection',
          widget.vm.stylusSettings.palmRejectionLevel != PalmRejectionLevel.off,
          widget.vm.stylusSettings.palmRejectionLevel.displayName,
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'Tilt Sensitivity',
          widget.vm.stylusSettings.tiltSensitivityEnabled,
          widget.vm.stylusSettings.tiltBehavior.name.toUpperCase(),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, bool isEnabled, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isEnabled ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildFeatureHighlights() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enhanced Drawing Features',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('• Pressure-sensitive stroke width'),
          _buildFeatureItem('• Tilt-based opacity and width control'),
          _buildFeatureItem('• Advanced palm rejection'),
          _buildFeatureItem('• Double-tap gestures'),
          _buildFeatureItem('• Hover preview with cursor'),
          _buildFeatureItem('• Stroke smoothing and prediction'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.blue[700]),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showStylusSettings(),
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _resetToDefaults(),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _testPressure(),
            icon: const Icon(Icons.touch_app, size: 16),
            label: const Text('Test'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _showStylusSettings() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StylusSettingsDialog(
            initialSettings: widget.vm.stylusSettings,
            onSettingsChanged: (settings) {
              widget.vm.updateStylusSettings(settings);
              widget.vm.saveStylusSettings();
              setState(() {}); // Refresh the demo widget
            },
          ),
    );
  }

  void _resetToDefaults() {
    widget.vm.resetStylusSettings();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stylus settings reset to defaults'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _testPressure() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Pressure Test'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Draw on the canvas to test pressure sensitivity.'),
                const SizedBox(height: 16),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Pressure Test Area\n(Implementation needed)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
