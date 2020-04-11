import '../abstract/abstract.dart';
import '../models/models.dart';
import 'base_model.dart';

class MessageModel extends BaseModel {
  MessageRepositoryAbs _repository;
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  UserApp _currentUser;

  bool _isBusy = false;

  bool get isBusy => _isBusy;

  setBusy(isBusy) {
    _isBusy = isBusy;
    notifyListeners();
  }

  set repository(repo) {
    _repository = repo;
  }

  set currentUser(UserApp user) {
    if (_currentUser != user) {
      _currentUser = user;
    }
  }

  UserApp get currentUser => _currentUser;

  fetchMessages(String flagId) async {
    _repository.livechatMessages(flagId).listen((livechatMessages) {
      _messages = livechatMessages;
      notifyListeners();
    });
  }

  sendMessage(UserApp _user, String flagId, Message newMessage) async {
    if (!newMessage.text.trim().isNotEmpty) return;
    setBusy(true);
    // generate video thumbnail

    await _repository.sendMessage(_user, flagId, newMessage);
    setBusy(false);
  }

  @override
  void dispose() {
    _messages = [];
    super.dispose();
  }
}
