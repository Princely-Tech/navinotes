import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

class ModernVoiceNoteItem extends StatefulWidget {
  final VoiceNote voiceNote;
  final int index;
  final NoteCreationVm vm;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const ModernVoiceNoteItem({
    Key? key,
    required this.voiceNote,
    required this.index,
    required this.vm,
    required this.isPlaying,
    required this.onPlay,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ModernVoiceNoteItem> createState() => _ModernVoiceNoteItemState();
}

class _ModernVoiceNoteItemState extends State<ModernVoiceNoteItem>
    with TickerProviderStateMixin {
  bool _isEditingName = false;
  late TextEditingController _nameController;
  late AnimationController _waveAnimationController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.voiceNote.name);

    _waveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _waveAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isPlaying) {
      _waveAnimationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ModernVoiceNoteItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _waveAnimationController.repeat(reverse: true);
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _waveAnimationController.stop();
      _waveAnimationController.reset();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _waveAnimationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _togglePlaybackSpeed() {
    double newSpeed;
    if (widget.vm.playbackSpeed == 1.0) {
      newSpeed = 1.5;
    } else if (widget.vm.playbackSpeed == 1.5) {
      newSpeed = 2.0;
    } else {
      newSpeed = 1.0;
    }
    widget.vm.setPlaybackSpeed(newSpeed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and actions
          Row(
            children: [
              Expanded(
                child:
                    _isEditingName
                        ? TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _isEditingName = false;
                            });
                            if (value.trim().isNotEmpty &&
                                value.trim() != widget.voiceNote.name) {
                              widget.vm.updateVoiceNoteName(
                                widget.index,
                                value.trim(),
                              );
                            }
                          },
                          autofocus: true,
                        )
                        : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingName = true;
                            });
                          },
                          child: Text(
                            widget.voiceNote.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
              ),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isPlaying) ...[
                    // Speed control
                    GestureDetector(
                      onTap: _togglePlaybackSpeed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.vm.playbackSpeed}x',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // Delete button
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Playback controls
          Row(
            children: [
              // Play/Pause button
              GestureDetector(
                onTap: widget.onPlay,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Waveform and progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Waveform visualization
                    Container(
                      height: 32,
                      child:
                          widget.isPlaying
                              ? _buildAnimatedWaveform()
                              : _buildStaticWaveform(),
                    ),
                    const SizedBox(height: 4),

                    // Progress slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value:
                            widget.isPlaying &&
                                    widget.vm.currentlyPlayingIndex ==
                                        widget.index
                                ? (widget.vm.totalDuration.inMilliseconds > 0
                                    ? (widget
                                                .vm
                                                .currentPosition
                                                .inMilliseconds /
                                            widget
                                                .vm
                                                .totalDuration
                                                .inMilliseconds)
                                        .clamp(0.0, 1.0)
                                    : 0.0)
                                : 0.0,
                        onChanged: (value) {
                          if (widget.isPlaying &&
                              widget.vm.currentlyPlayingIndex == widget.index) {
                            final position = Duration(
                              milliseconds:
                                  (value *
                                          widget
                                              .vm
                                              .totalDuration
                                              .inMilliseconds)
                                      .round(),
                            );
                            widget.vm.seekToPosition(position);
                          }
                        },
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Duration
              Text(
                widget.isPlaying &&
                        widget.vm.currentlyPlayingIndex == widget.index
                    ? '${_formatDuration(widget.vm.currentPosition)} / ${_formatDuration(widget.vm.totalDuration)}'
                    : '${_formatDuration(Duration.zero)} / ${_formatDuration(widget.voiceNote.duration ?? Duration.zero)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),

          // Metadata
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                DateTime.fromMillisecondsSinceEpoch(
                  widget.voiceNote.createdAt * 1000,
                ).toString().substring(0, 16),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const Spacer(),
              Text(
                widget.voiceNote.formattedFileSize,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaticWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(20, (index) {
        final heights = [
          0.3,
          0.7,
          0.4,
          0.8,
          0.5,
          0.9,
          0.6,
          0.3,
          0.7,
          0.4,
          0.8,
          0.5,
          0.6,
          0.9,
          0.3,
          0.7,
          0.4,
          0.8,
          0.5,
          0.6,
        ];
        return Container(
          width: 2,
          height: 32 * heights[index % heights.length],
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  Widget _buildAnimatedWaveform() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(20, (index) {
            final heights = [
              0.3,
              0.7,
              0.4,
              0.8,
              0.5,
              0.9,
              0.6,
              0.3,
              0.7,
              0.4,
              0.8,
              0.5,
              0.6,
              0.9,
              0.3,
              0.7,
              0.4,
              0.8,
              0.5,
              0.6,
            ];
            final animatedHeight =
                heights[index % heights.length] *
                (0.5 + 0.5 * _waveAnimation.value);
            return Container(
              width: 2,
              height: 32 * animatedHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        );
      },
    );
  }
}
