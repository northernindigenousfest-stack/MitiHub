import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/openai_service.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/quick_reply_widget.dart';
import './widgets/settings_bottom_sheet_widget.dart';

class MitiBotChat extends StatefulWidget {
  const MitiBotChat({Key? key}) : super(key: key);

  @override
  State<MitiBotChat> createState() => _MitiBotChatState();
}

class _MitiBotChatState extends State<MitiBotChat>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final OpenAIService _openAIService = OpenAIService();

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;

  bool _isOnline = false;
  bool _isRecording = false;
  bool _isTyping = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  XFile? _capturedImage;

  // Chat history
  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "message":
          "Hello! I'm MitiBot, your AI assistant for tree care and environmental conservation in Northern Kenya. How can I help you today?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "quickReplies": [
        "Tree species for arid areas",
        "Watering schedule",
        "Soil preparation",
        "Climate advice"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _checkConnectivity();
    await _initializeCamera();
    _listenToConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
          await _cameraController!.initialize();
          await _applySettings();
        }
      }
    } catch (e) {
      // Silent fail - camera not critical for chat functionality
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported on this device
        }
      }
    } catch (e) {
      // Settings not supported
    }
  }

  Future<void> _capturePhoto() async {
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _capturedImage = photo;
        });
        _analyzeTreePhoto(photo);
      } else {
        // Fallback to image picker
        final XFile? image =
            await _imagePicker.pickImage(source: ImageSource.camera);
        if (image != null) {
          setState(() {
            _capturedImage = image;
          });
          _analyzeTreePhoto(image);
        }
      }
    } catch (e) {
      _showErrorMessage('Unable to capture photo. Please try again.');
    }
  }

  void _analyzeTreePhoto(XFile photo) {
    _addMessage(
      "I've uploaded a photo for analysis. Can you help identify this tree?",
      isUser: true,
    );

    // Enhanced AI photo analysis simulation
    _generateBotResponse(
        "I've uploaded a photo of a tree. Can you help me identify it and provide care instructions? The tree has green leaves and appears to be growing in an arid environment.");
  }

  Future<void> _startVoiceRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'recording.wav');
        } else {
          await _audioRecorder.start(const RecordConfig(),
              path: 'recording.m4a');
        }
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorMessage(
          'Unable to start recording. Please check microphone permissions.');
    }
  }

  Future<void> _stopVoiceRecording() async {
    try {
      final String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // Simulate speech-to-text conversion
        _processVoiceMessage();
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorMessage('Unable to process voice message.');
    }
  }

  void _processVoiceMessage() {
    // Simulate voice-to-text conversion
    final voiceMessages = [
      "What trees grow well in dry areas?",
      "How often should I water my seedlings?",
      "Tell me about baobab trees",
      "What's the best soil for planting?"
    ];

    final randomMessage =
        voiceMessages[DateTime.now().millisecond % voiceMessages.length];
    _addMessage(randomMessage, isUser: true);
    _generateBotResponse(randomMessage);
  }

  void _handleVoiceMessage() {
    if (_isRecording) {
      _stopVoiceRecording();
    } else {
      _startVoiceRecording();
    }
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _addMessage(message, isUser: true);
    _generateBotResponse(message);
  }

  void _addMessage(String message, {required bool isUser}) {
    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "message": message,
        "isUser": isUser,
        "timestamp": DateTime.now(),
        "quickReplies": <String>[]
      });
    });
    _scrollToBottom();
  }

  void _generateBotResponse(String userMessage) async {
    setState(() {
      _isTyping = true;
    });

    // Add typing indicator
    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "message": "",
        "isUser": false,
        "timestamp": DateTime.now(),
        "isTyping": true,
        "quickReplies": <String>[]
      });
    });
    _scrollToBottom();

    try {
      // Use OpenAI service for response
      final response = await _openAIService.getChatCompletion(
        message: userMessage,
        systemPrompt: _openAIService.systemPrompt,
      );

      // Remove typing indicator
      setState(() {
        _messages.removeLast();
        _isTyping = false;
      });

      final aiResponse = response ??
          "I apologize, but I'm having trouble responding right now. Please try again.";
      final quickReplies = _openAIService.getQuickReplies(userMessage);

      _addBotResponse(aiResponse, quickReplies: quickReplies);
    } catch (e) {
      // Remove typing indicator
      setState(() {
        _messages.removeLast();
        _isTyping = false;
      });

      _addBotResponse(
          "I apologize, but I'm experiencing some technical difficulties. Please try again in a moment.",
          quickReplies: ["Tree species", "Care tips", "Help"]);
    }
  }

  void _addBotResponse(String response,
      {List<String> quickReplies = const []}) {
    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "message": response,
        "isUser": false,
        "timestamp": DateTime.now(),
        "quickReplies": quickReplies
      });
    });
    _scrollToBottom();
  }

  void _handleQuickReply(String reply) {
    _sendMessage(reply);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsBottomSheetWidget(
        notificationsEnabled: _notificationsEnabled,
        selectedLanguage: _selectedLanguage,
        onNotificationToggle: (value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
        onLanguageChange: (language) {
          setState(() {
            _selectedLanguage = language;
          });
        },
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          ChatHeaderWidget(
            isOnline: _isOnline,
            onSettingsTap: _showSettings,
            onBackTap: () => Navigator.pop(context),
          ),
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isTyping = message['isTyping'] == true;

                return Column(
                  children: [
                    ChatMessageWidget(
                      message: message['message'] as String,
                      isUser: message['isUser'] as bool,
                      timestamp: message['timestamp'] as DateTime,
                      isTyping: isTyping,
                    ),
                    if (!isTyping &&
                        !(message['isUser'] as bool) &&
                        (message['quickReplies'] as List).isNotEmpty)
                      QuickReplyWidget(
                        quickReplies: (message['quickReplies'] as List<dynamic>)
                            .cast<String>(),
                        onReplyTap: _handleQuickReply,
                      ),
                  ],
                );
              },
            ),
          ),
          // Input area
          ChatInputWidget(
            controller: _messageController,
            onSendMessage: _sendMessage,
            onVoiceMessage: _handleVoiceMessage,
            onCameraCapture: _capturePhoto,
            isRecording: _isRecording,
          ),
        ],
      ),
    );
  }
}
