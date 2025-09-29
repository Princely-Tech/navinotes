import 'package:flutter/material.dart';
import '../vm.dart';
import '../models/stylus_settings.dart';
import 'stylus_settings_dialog.dart';

/// Simple widget to test and enable stylus functionality
class StylusTestWidget extends StatelessWidget {
  final NoteCreationVm vm;

  const StylusTestWidget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.draw, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Stylus System Test',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Status
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isActive() ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isActive() ? 'Stylus System Active' : 'Stylus System Inactive',
                style: TextStyle(
                  fontSize: 12,
                  color: _isActive() ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _enableStylus(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Enable Stylus'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showSettings(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Settings'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Info text
          Text(
            _isActive() 
                ? 'Pressure-sensitive drawing is now active!'
                : 'Enable stylus to use pressure sensitivity and advanced features.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isActive() {
    return vm.stylusSettings.pressureSensitivityEnabled || vm.isStylusConnected;
  }

  void _enableStylus() {
    // Enable pressure sensitivity to activate the stylus system
    final enabledSettings = vm.stylusSettings.copyWith(
      pressureSensitivityEnabled: true,
    );
    vm.updateStylusSettings(enabledSettings);
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StylusSettingsDialog(
        initialSettings: vm.stylusSettings,
        onSettingsChanged: (settings) {
          vm.updateStylusSettings(settings);
          vm.saveStylusSettings();
        },
      ),
    );
  }
}
