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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarTitle),
        actions: [
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
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: const Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      return ListTile(
                        title: _MessageView(m, _viewModel.host, l10n),
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
