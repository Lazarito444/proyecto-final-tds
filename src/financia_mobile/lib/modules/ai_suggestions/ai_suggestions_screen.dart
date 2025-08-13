import 'package:financia_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/models/ai_suggestions_model.dart';
import 'package:financia_mobile/services/ai_suggestions_service.dart';

class AISuggestionsScreen extends ConsumerStatefulWidget {
  const AISuggestionsScreen({super.key});

  @override
  ConsumerState<AISuggestionsScreen> createState() =>
      _AISuggestionsScreenState();
}

class _AISuggestionsScreenState extends ConsumerState<AISuggestionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AiSuggestionsService _aiService = AiSuggestionsService();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  AiSuggestionsResponse? _suggestions;
  AiPredictionsResponse? _predictions;
  final List<ChatMessage> _chatMessages = [];

  bool _isLoadingSuggestions = false;
  bool _isLoadingPredictions = false;
  bool _isLoadingChat = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadSuggestions(), _loadPredictions()]);
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _isLoadingSuggestions = true;
    });

    try {
      final suggestions = await _aiService.getSuggestions();
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${S.of(context).error_loading_suggestions}: ${e.toString()}",
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  Future<void> _loadPredictions() async {
    setState(() {
      _isLoadingPredictions = true;
    });

    try {
      final predictions = await _aiService.getPredictions();
      setState(() {
        _predictions = predictions;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${S.of(context).error_loading_predictions}: ${e.toString()}",
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingPredictions = false;
      });
    }
  }

  Future<void> _sendChatMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty || _isLoadingChat) return;

    // Agregar mensaje del usuario
    setState(() {
      _chatMessages.add(
        ChatMessage(message: message, isUser: true, timestamp: DateTime.now()),
      );
      _isLoadingChat = true;
    });

    _chatController.clear();
    _scrollToBottom();

    try {
      final request = ChatWithAiRequest(prompt: message);
      final response = await _aiService.chatWithAi(request);

      setState(() {
        _chatMessages.add(
          ChatMessage(
            message: response.aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _chatMessages.add(
          ChatMessage(
            message: S.of(context).chat_processing_error,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } finally {
      setState(() {
        _isLoadingChat = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          S.of(context).financial_ai,
          style: context.textStyles.titleMedium,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: S.of(context).suggestions_tab),
            Tab(text: S.of(context).predictions_tab),
            Tab(text: S.of(context).ai_chat_tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSuggestionsTab(),
          _buildPredictionsTab(),
          _buildChatTab(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    return RefreshIndicator(
      onRefresh: _loadSuggestions,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoadingSuggestions)
              const Center(child: CircularProgressIndicator())
            else if (_suggestions != null) ...[
              _buildMainSuggestionCard(context, _suggestions!.mainSuggestion),
              const SizedBox(height: 24),
              Text(
                S.of(context).additional_suggestions,
                style: context.textStyles.titleMedium,
              ),
              const SizedBox(height: 16),
              ..._suggestions!.sideSuggestions.map(
                (suggestion) => _buildSideSuggestionCard(context, suggestion),
              ),
            ] else
              Center(child: Text(S.of(context).no_suggestions_loaded)),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionsTab() {
    return RefreshIndicator(
      onRefresh: _loadPredictions,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoadingPredictions)
              const Center(child: CircularProgressIndicator())
            else if (_predictions != null) ...[
              _buildMainPredictionCard(context, _predictions!.mainPrediction),
              const SizedBox(height: 24),
              Text(
                S.of(context).additional_predictions,
                style: context.textStyles.titleMedium,
              ),
              const SizedBox(height: 16),
              ..._predictions!.sidePredictions.map(
                (prediction) => _buildSidePredictionCard(context, prediction),
              ),
            ] else
              Center(child: Text(S.of(context).no_predictions_loaded)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _chatMessages.length + (_isLoadingChat ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _chatMessages.length && _isLoadingChat) {
                return _buildTypingIndicator();
              }

              final message = _chatMessages[index];
              return _buildChatMessage(message);
            },
          ),
        ),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildMainSuggestionCard(BuildContext context, String suggestion) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.surfaceContainerLowest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                S.of(context).main_ai_suggestion,
                style: context.textStyles.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            suggestion,
            style: context.textStyles.labelMedium?.copyWith(
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPredictionCard(BuildContext context, String prediction) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.secondary,
            context.colors.surfaceContainerLowest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                S.of(context).main_prediction,
                style: context.textStyles.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prediction,
            style: context.textStyles.labelMedium?.copyWith(
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideSuggestionCard(BuildContext context, String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.lightbulb,
              color: context.colors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              suggestion,
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.onSurface,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePredictionCard(BuildContext context, String prediction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.secondary),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.secondaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.analytics,
              color: context.colors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              prediction,
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.onSurface,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: context.colors.primary,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? context.colors.primary
                    : context.colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.message,
                style: context.textStyles.labelSmall?.copyWith(
                  color: message.isUser
                      ? Colors.white
                      : context.colors.onSurface,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: context.colors.secondary,
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: context.colors.primary,
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              width: 40,
              height: 20,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: S.of(context).ask_about_finances_hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendChatMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isLoadingChat ? null : _sendChatMessage,
            icon: Icon(
              Icons.send,
              color: _isLoadingChat
                  ? context.colors.outline
                  : context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
