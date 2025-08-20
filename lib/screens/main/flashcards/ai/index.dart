import 'package:flutter/material.dart';

class FlashCardCreationScreen extends StatelessWidget {
  const FlashCardCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 65,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Logo and title
                        Container(
                          width: 105.75,
                          height: 28,
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 16,
                                color: Colors.transparent,
                                // Add your logo here
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'NaviNotes',
                                style: TextStyle(
                                  color: Color(0xFF00555A),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          '| Create FlashCards',
                          style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // User actions
                    Container(
                      width: 80,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              // Add icon here
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 32,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              // Add icon here
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left sidebar
                Container(
                  width: 288,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Column(
                    children: [
                      _buildCreationModeSection(),
                      _buildAIContentSourceSection(),
                      _buildSelectNotesSection(),
                      _buildGenerationSettingsSection(),
                      _buildDeckManagementSection(),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        _buildAIStatusSection(),
                        _buildFlashCardPreviewSection(),
                        _buildCardActionsSection(),
                        _buildBulkActionsSection(),
                        _buildAISuggestionSection(),
                      ],
                    ),
                  ),
                ),

                // Right sidebar
                Container(
                  width: 320,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Column(
                    children: [
                      _buildCardsInDeckSection(),
                      _buildAnalyticsSection(),
                      _buildActionButtonsSection(),
                    ],
                  ),
                ),
              ],
            ),

            // Footer
            Container(
              width: double.infinity,
              height: 67,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildFooterButton(
                          'Regenerate Deck',
                          const Color(0xFFF0FDFA),
                          const Color(0xFF0F766E),
                        ),
                        const SizedBox(width: 16),
                        _buildFooterButton(
                          'Generate More',
                          Colors.white,
                          const Color(0xFF374151),
                        ),
                        const SizedBox(width: 16),
                        _buildFooterButton(
                          'Fill Gaps',
                          Colors.white,
                          const Color(0xFF374151),
                        ),
                        const SizedBox(width: 16),
                        _buildFooterButton(
                          'Analyze Coverage',
                          Colors.white,
                          const Color(0xFF374151),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildFooterButton(
                          'Deck Settings',
                          Colors.white,
                          const Color(0xFF374151),
                        ),
                        const SizedBox(width: 16),
                        _buildFooterButton(
                          'Save Deck',
                          Colors.white,
                          const Color(0xFF374151),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              // Add icon here
                              SizedBox(width: 8),
                              Text(
                                'Study Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for building sections (simplified for brevity)
  Widget _buildCreationModeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CREATION MODE',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildMenuOption('Manual Creation', false),
              _buildMenuOption('AI-Assisted', true),
              _buildMenuOption('Import from Notes', false),
              _buildMenuOption('Batch Creation', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(String title, bool isSelected) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0FDFA) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          // Add icon here based on selection
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color:
                  isSelected
                      ? const Color(0xFF0F766E)
                      : const Color(0xFF374151),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIContentSourceSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildSelectNotesSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildGenerationSettingsSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildDeckManagementSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildAIStatusSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildFlashCardPreviewSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildCardActionsSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildBulkActionsSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildAISuggestionSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildCardsInDeckSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildAnalyticsSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildActionButtonsSection() {
    // Similar implementation pattern
    return Container();
  }

  Widget _buildFooterButton(String text, Color bgColor, Color textColor) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              bgColor == const Color(0xFFF0FDFA)
                  ? const Color(0xFF99F6E4)
                  : const Color(0xFFD1D5DB),
        ),
      ),
      child: Row(
        children: [
          // Add icon here
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: textColor, fontSize: 16)),
        ],
      ),
    );
  }
}
