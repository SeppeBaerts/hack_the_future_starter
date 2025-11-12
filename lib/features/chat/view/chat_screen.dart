import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:hack_the_future_starter/l10n/app_localizations.dart';

import '../models/chat_message.dart';
import '../viewmodel/chat_view_model.dart';
import '../widgets/agent_log_panel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatViewModel _viewModel;
  bool _showAgentLog = true;

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
    _textController.clear();
    _viewModel.send(text);
    _scrollToBottom();
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

  void _showFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.pink),
            SizedBox(width: 8),
            Text('Favorites'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: AnimatedBuilder(
            animation: _viewModel.favoritesService,
            builder: (context, _) {
              final favorites = _viewModel.favoritesService.favorites;
              
              if (favorites.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No favorites yet.\nMark interesting queries as favorite!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              
              return ListView.builder(
                shrinkWrap: true,
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.pink),
                      title: Text(
                        favorite.query,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _formatTimestamp(favorite.timestamp),
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          _viewModel.favoritesService.removeFavorite(favorite.id);
                        },
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _textController.text = favorite.query;
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_viewModel.favoritesService.favorites.isNotEmpty) {
                _viewModel.favoritesService.clear();
              }
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              _showFavoritesDialog(context);
            },
          ),
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
                if (_showAgentLog)
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blueGrey.shade50,
                          Colors.grey.shade100,
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.psychology,
                                  size: 20,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Agent Activity Log',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _viewModel.messages.length,
                    itemBuilder: (_, i) {
                      final m = _viewModel.messages[i];
                      return _MessageView(
                        model: m,
                        host: _viewModel.host,
                        l10n: l10n,
                        viewModel: _viewModel,
                      );
                    },
                  ),
                ),
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
                            onPressed: _viewModel.isAborting
                                ? null
                                : () {
                                    _viewModel.abort();
                                  },
                            icon: const Icon(Icons.stop),
                            label: Text(_viewModel.isAborting ? 'Stopping...' : 'Stop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey,
                              disabledForegroundColor: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Query History - show above input field when not processing
                if (_viewModel.queryHistoryService.history.isNotEmpty &&
                    !_viewModel.isProcessing.value)
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _viewModel.queryHistoryService.history.length,
                      itemBuilder: (context, index) {
                        final query =
                            _viewModel.queryHistoryService.history[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: Text(
                              query.query.length > 30
                                  ? '${query.query.substring(0, 30)}...'
                                  : query.query,
                              style: const TextStyle(fontSize: 12),
                            ),
                            avatar: const Icon(Icons.history, size: 16),
                            onPressed: () {
                              _textController.text = query.query;
                            },
                            backgroundColor: Colors.blue.shade50,
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: l10n.hintTypeMessage,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.white,
                            onPressed: _send,
                          ),
                        ),
                      ],
                    ),
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
  const _MessageView({
    required this.model,
    required this.host,
    required this.l10n,
    required this.viewModel,
  });

  final ChatMessageModel model;
  final GenUiHost host;
  final AppLocalizations l10n;
  final ChatViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final surfaceId = model.surfaceId;

    if (surfaceId == null) {
      final label = model.isError
          ? l10n.labelError
          : (model.isUser ? l10n.labelYou : l10n.labelAI);
      final content = model.text ?? '';
      return ListTile(
        title: Text('$label: $content'),
      );
    }

    // For AI responses with surfaces, add action buttons
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GenUiSurface(host: host, surfaceId: surfaceId),
        // Action buttons for AI responses
        if (!model.isUser)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Share button - for now, show a simple message
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Screenshot feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                // Favorite button
                AnimatedBuilder(
                  animation: viewModel.favoritesService,
                  builder: (context, _) {
                    // Try to get associated query from previous user message
                    final messageIndex = viewModel.messages.indexOf(model);
                    String? associatedQuery;
                    if (messageIndex > 0) {
                      final prevMessage = viewModel.messages[messageIndex - 1];
                      if (prevMessage.isUser) {
                        associatedQuery = prevMessage.text;
                      }
                    }
                    
                    final isFavorited = associatedQuery != null &&
                        viewModel.favoritesService.isFavorited(associatedQuery);
                    
                    return TextButton.icon(
                      onPressed: associatedQuery != null
                          ? () {
                              viewModel.toggleFavorite(
                                associatedQuery,
                                surfaceId: surfaceId,
                              );
                            }
                          : null,
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFavorited ? Colors.pink : null,
                      ),
                      label: Text(
                        isFavorited ? 'Favorited' : 'Favorite',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
