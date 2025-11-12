import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:hack_the_future_starter/features/chat/services/theme_provider.dart';
import 'package:hack_the_future_starter/l10n/app_localizations.dart';

import '../models/chat_message.dart';
import '../viewmodel/chat_view_model.dart';
import '../widgets/agent_log_panel.dart';
import '../widgets/query_history_panel.dart';
import '../widgets/favorites_panel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.themeProvider,
    super.key,
  });

  final ThemeProvider themeProvider;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatViewModel _viewModel;
  bool _showAgentLog = true;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel()..init();
  }

  @override
  void dispose() {
    _viewModel.disposeConversation();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _currentQuery = text;
    _textController.clear();
    _viewModel.send(text);
    _scrollToBottom();
  }

  void _sendQuery(String query) {
    _textController.text = query;
    _send();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showFavoritesDrawer() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  const Text(
                    'Favorite Queries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: FavoritesPanel(
                favoritesService: _viewModel.favoritesService,
                onQuerySelected: (query) {
                  Navigator.of(context).pop();
                  _sendQuery(query);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarTitle),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
              widget.themeProvider.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: widget.themeProvider.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
            onPressed: () {
              widget.themeProvider.toggleTheme();
            },
          ),
          // Favorite current query
          if (_currentQuery.isNotEmpty)
            AnimatedBuilder(
              animation: _viewModel.favoritesService,
              builder: (context, _) {
                final isFavorite =
                    _viewModel.favoritesService.isFavorite(_currentQuery);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.amber : null,
                  ),
                  tooltip: isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: () {
                    _viewModel.favoritesService.toggleFavorite(_currentQuery);
                  },
                );
              },
            ),
          // Show favorites drawer
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'View Favorites',
            onPressed: _showFavoritesDrawer,
          ),
          // Agent log toggle
          IconButton(
            icon: Icon(_showAgentLog ? Icons.visibility_off : Icons.visibility),
            tooltip: _showAgentLog ? 'Hide Agent Log' : 'Show Agent Log',
            onPressed: () {
              setState(() {
                _showAgentLog = !_showAgentLog;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return Column(
              children: [
                // Query History Panel
                QueryHistoryPanel(
                  historyService: _viewModel.queryHistoryService,
                  onQuerySelected: _sendQuery,
                ),
                // Agent Log Panel
                if (_showAgentLog)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.psychology, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Agent Activity Log',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () {
                                  _viewModel.agentLogService.clear();
                                },
                                icon: const Icon(Icons.clear_all, size: 16),
                                label: const Text('Clear'),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: AgentLogPanel(
                            logService: _viewModel.agentLogService,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Chat Messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _viewModel.messages.length,
                    itemBuilder: (_, i) {
                      final m = _viewModel.messages[i];
                      return ListTile(
                        title: _MessageView(m, _viewModel.host, l10n),
                      );
                    },
                  ),
                ),
                // Processing Indicator with Stop Button
                ValueListenableBuilder<bool>(
                  valueListenable: _viewModel.isProcessing,
                  builder: (_, isProcessing, __) {
                    if (!isProcessing) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              _viewModel.abort();
                            },
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: l10n.hintTypeMessage,
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _send,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView(this.model, this.host, this.l10n);

  final ChatMessageModel model;
  final GenUiHost host;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final surfaceId = model.surfaceId;

    if (surfaceId == null) {
      final label = model.isError
          ? l10n.labelError
          : (model.isUser ? l10n.labelYou : l10n.labelAI);
      final content = model.text ?? '';
      return Text('$label: $content');
    }

    return GenUiSurface(host: host, surfaceId: surfaceId);
  }
}
