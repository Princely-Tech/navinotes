import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'professional_drawing_toolbar.dart';
import 'pressure_drawing_widget.dart';
import 'stylus_settings_dialog.dart';
import '../models/stylus_settings.dart';

Widget buildDrawingBoard(
  NoteCreationVm vm,
  double inputWidth,
  double inputHeight,
) {
  // Validate dimensions to prevent "Invalid image dimensions" error
  final validWidth =
      inputWidth.isFinite && inputWidth > 10 ? inputWidth : 595.0;
  final validHeight =
      inputHeight.isFinite && inputHeight > 10 ? inputHeight : 842.0;

  // Additional safety check - if dimensions are still invalid, return empty container
  if (validWidth < 10 ||
      validHeight < 10 ||
      !validWidth.isFinite ||
      !validHeight.isFinite) {
    debugPrint(
      'buildDrawingBoard: Invalid dimensions $validWidth x $validHeight, returning empty container',
    );
    return Container(width: 100, height: 100, color: Colors.transparent);
  }

  debugPrint('buildDrawingBoard: Using dimensions $validWidth x $validHeight');

  // Use pressure-sensitive drawing widget if stylus settings are enabled
  if (vm.stylusSettings.pressureSensitivityEnabled || vm.isStylusConnected) {
    return PressureDrawingWidget(
      controller: vm.getCurrentPagePressureController(),
      width: validWidth,
      height: validHeight,
      vm: vm,
    );
  }

  // Fallback to regular drawing board
  return IgnorePointer(
    ignoring: vm.currentMode != NoteMode.drawing,
    child: Container(
      width: validWidth,
      height: validHeight,
      child: DrawingBoardWithCursor(
        controller: vm.getCurrentPageDrawingController(),
        width: validWidth,
        height: validHeight,
        vm: vm,
      ),
    ),
  );
}

Widget buildDrawingToolbar({required NoteCreationVm vm}) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Column(
      children: [
        ProfessionalDrawingToolbar(vm: vm),
        if (vm.isStylusConnected) _buildStylusToolbar(vm),
      ],
    ),
  );
}

Widget _buildStylusToolbar(NoteCreationVm vm) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stylus indicator
        Icon(
          vm.detectedStylusType.icon,
          size: 16,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Text(
          vm.detectedStylusType.displayName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        
        // Pressure sensitivity indicator
        if (vm.stylusSettings.pressureSensitivityEnabled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'PRESSURE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        
        const SizedBox(width: 8),
        
        // Settings button
        GestureDetector(
          onTap: () => _showStylusSettings(vm),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.settings,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showStylusSettings(NoteCreationVm vm) {
  // This would be called from a context where we have access to BuildContext
  // For now, we'll call the VM method
  vm.showStylusSettings();
}

class DrawingBoardWithCursor extends StatefulWidget {
  final DrawingController controller;
  final double width;
  final double height;
  final NoteCreationVm vm;

  const DrawingBoardWithCursor({
    required this.controller,
    required this.width,
    required this.height,
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  State<DrawingBoardWithCursor> createState() => _DrawingBoardWithCursorState();
}

class _DrawingBoardWithCursorState extends State<DrawingBoardWithCursor> {
  Offset? _cursorPos;

  @override
  void initState() {
    super.initState();
    // Don't add listeners to avoid rebuilds during drawing
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Validate dimensions to prevent rendering issues
    final validWidth =
        widget.width.isFinite && widget.width > 10 ? widget.width : 595.0;
    final validHeight =
        widget.height.isFinite && widget.height > 10 ? widget.height : 842.0;

    // Additional safety check for very small dimensions that could cause rendering issues
    if (validWidth < 10 ||
        validHeight < 10 ||
        !validWidth.isFinite ||
        !validHeight.isFinite) {
      debugPrint(
        'DrawingBoardWithCursor: Invalid dimensions $validWidth x $validHeight, returning empty container',
      );
      return Container(width: 100, height: 100, color: Colors.transparent);
    }

    debugPrint(
      'DrawingBoardWithCursor: Using dimensions $validWidth x $validHeight',
    );

    return Listener(
      onPointerHover: (e) {
        if (mounted) {
          setState(() => _cursorPos = e.localPosition);
        }
      },
      onPointerMove: (e) {
        if (mounted) {
          setState(() => _cursorPos = e.localPosition);
        }
      },
      onPointerDown: (e) {
        if (mounted) {
          setState(() => _cursorPos = e.localPosition);
        }
      },
      onPointerUp: (e) {
        if (mounted) {
          setState(() => _cursorPos = null);
        }
      },
      child: RepaintBoundary(
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                try {
                  return DrawingBoard(
                    controller: widget.controller,
                    background: Container(
                      width: validWidth,
                      height: validHeight,
                      color: Colors.transparent,
                    ),
                    showDefaultActions: false,
                    showDefaultTools: false,
                  );
                } catch (e) {
                  debugPrint('Error creating DrawingBoard: $e');
                  return Container(
                    width: validWidth,
                    height: validHeight,
                    color: Colors.grey.withOpacity(0.1),
                    child: const Center(child: Text('Drawing unavailable')),
                  );
                }
              },
            ),
            if (_cursorPos != null)
              ValueListenableBuilder<DrawConfig>(
                valueListenable: widget.controller.drawConfig,
                builder: (_, drawConfig, __) {
                  return Positioned(
                    left: _cursorPos!.dx - drawConfig.strokeWidth / 2,
                    top: _cursorPos!.dy - drawConfig.strokeWidth / 2,
                    child: IgnorePointer(
                      child: Container(
                        width: drawConfig.strokeWidth,
                        height: drawConfig.strokeWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show stylus settings dialog
void showStylusSettingsDialog(BuildContext context, NoteCreationVm vm) {
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
