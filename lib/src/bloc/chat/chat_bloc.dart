// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api/chat/chat_history_model.dart';
import 'package:youdu/src/model/api/chat/chat_message_model.dart';
import 'package:youdu/src/model/api/chat/chat_search_model.dart';
import 'package:youdu/src/model/http_result.dart';

import '../../widget/dialog/center_dialog.dart';

class ChatBloc {
  final Repository _repository = Repository();
  final _fetchChatHistory = PublishSubject<List<CharHistoryResult>>();
  final _fetchChatSearch = PublishSubject<List<SearchResult>>();
  final _fetchChatMessage = PublishSubject<List<ChatMessageResult>>();

  Stream<List<CharHistoryResult>> get getChatHistory =>
      _fetchChatHistory.stream;

  Stream<List<SearchResult>> get getChatSearch => _fetchChatSearch.stream;

  Stream<List<ChatMessageResult>> get getChatMessage =>
      _fetchChatMessage.stream;

  Future<bool> allChatHistory(BuildContext context) async {
    HttpResult response = await _repository.allChat();
    if (response.isSuccess) {
      ChatHistoryModel data = ChatHistoryModel.fromJson(response.result);
      _fetchChatHistory.sink.add(data.data.contacts);
      return true;
    } else {
      if (response.status == -1) {
        CenterDialog.networkErrorDialog(context, onTap: () {
          allChatHistory(context);
        });
      }
      return false;
    }
  }

  String searchData = "";

  allChatSearch(String search) async {
    searchData = search;
    HttpResult response = await _repository.allChatSearch(search);
    if (response.isSuccess) {
      SearchChatModel data = SearchChatModel.fromJson(response.result);
      _fetchChatSearch.sink.add(data.data);
    }
  }

  List<ChatMessageResult> chatData = [];

  allChatMessage(int id) async {
    HttpResult response = await _repository.allChatMessage(id);
    if (response.isSuccess) {
      ChatMessageModel data = ChatMessageModel.fromJson(response.result);
      chatData = data.data;
      _fetchChatMessage.sink.add(chatData);
    }
  }

  addData(ChatMessageResult data) {
    if (chatData.isNotEmpty) {
      if (data.fromId == chatData.first.fromId ||
          data.fromId == chatData.first.toId ||
          data.toId == chatData.first.fromId ||
          data.toId == chatData.first.toId) {
        chatData.insert(0, data);
        _fetchChatMessage.sink.add(chatData);
      }
    }
  }

  allSendMessage(int id, String msg, BuildContext context) async {
    ChatMessageResult data = ChatMessageResult(
      seen: 0,
      fromId: 0,
      toId: id,
      message: msg,
      createdAt: DateTime.now(),
      attachment: Attachment.fromJson({}),
      id: 0,
    );
    chatData.insert(0, data);
    _fetchChatMessage.sink.add(chatData);
    HttpResult response = await _repository.allChatSendMessage(id, msg);
    if (response.isSuccess) {
      allChatHistory(context);
      allChatSearch(searchData);
    }
  }

  allChatSendImage(int id, File image, BuildContext context) async {
    ChatMessageResult data = ChatMessageResult(
      seen: 0,
      fromId: 0,
      toId: id,
      message: "",
      createdAt: DateTime.now(),
      attachment: Attachment(
        type: "file",
        path: "",
      ),
      file: image,
      id: 0,
    );
    chatData.insert(0, data);
    _fetchChatMessage.sink.add(chatData);
    HttpResult response = await _repository.allChatSendImage(id, image.path);
    if (response.isSuccess) {
      allChatHistory(context);
      allChatSearch(searchData);
    }
  }
}

final chatBloc = ChatBloc();
