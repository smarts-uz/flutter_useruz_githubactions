import 'package:image_picker/image_picker.dart';
import 'package:youdu/src/database/database_helper.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/api_model/guest/performers/performers_filter_model.dart';
import 'package:youdu/src/model/api_model/tasks/product_model.dart';
import '../model/api/create/create_route_model.dart';
import '../model/api/create/send_address_model.dart';
import 'api_provider.dart';
import 'package:youdu/src/model/http_result.dart';

class Repository {
  final _apiProvider = ApiProvider();
  final _database = DatabaseHelper();

  ///database
  Future<int> saveCategory(CategoryModel item) => _database.saveCategory(item);

  Future<List<CategoryModel>> getCategory(String search) =>
      _database.getCategory(search);

  ///API
  Future<HttpResult> login(String email, String password) =>
      _apiProvider.login(email, password);

  Future<HttpResult> getCategoryId(int id) => _apiProvider.getCategoryById(id);

  Future<HttpResult> addressToLocation(String address) =>
      _apiProvider.addressToLocation(address);

  Future<HttpResult> sendFirebaseToken(
    String token,
    String deviceId,
    String deviceName,
  ) =>
      _apiProvider.sendFirebaseToken(
        token,
        deviceId,
        deviceName,
      );

  Future<HttpResult> getTask({
    required String category,
    required String categoryChild,
    required String budget,
    required String isRemote,
    required String withoutResponse,
    required String long,
    required String lat,
    required String difference,
    required String search,
    required int page,
  }) =>
      _apiProvider.getTask(
        category,
        categoryChild,
        budget,
        isRemote,
        withoutResponse,
        long,
        lat,
        difference,
        search,
        page,
      );

  Future<HttpResult> register(String name, String email, String phoneNumber,
          String password, String confirm) =>
      _apiProvider.register(name, email, phoneNumber, password, confirm);

  Future<HttpResult> allCategory() => _apiProvider.allCategory();

  Future<HttpResult> getUserTasks(int userId, int status) =>
      _apiProvider.getUserTasks(userId, status);

  Future<HttpResult> allNotification() => _apiProvider.allNotification();

  Future<HttpResult> sendReview(
          int status, int like, String description, int id) =>
      _apiProvider.sendReview(status, like, description, id);

  Future<HttpResult> allNotificationId(int id) =>
      _apiProvider.allNotificationId(id);

  Future<HttpResult> readAllNotifications() =>
      _apiProvider.readAllNotifications();

  Future<HttpResult> getNotificationsCount() =>
      _apiProvider.getNotificationsCount();

  Future<HttpResult> getAllCategoriesChilds() =>
      _apiProvider.getAllCategoriesChilds();

  Future<HttpResult> getSupportNumber() => _apiProvider.getSupportNumber();

  Future<HttpResult> allChat() => _apiProvider.allChat();

  Future<HttpResult> allChatSearch(String search) =>
      _apiProvider.allChatSearch(search);

  Future<HttpResult> selectPerform(int id) => _apiProvider.selectPerform(id);

  Future<HttpResult> allChatMessage(int id) => _apiProvider.allChatMessage(id);

  Future<HttpResult> allChatSendMessage(int id, String msg) =>
      _apiProvider.allChatSendMessage(id, msg);

  Future<HttpResult> changeLanguage(String lang, String version) =>
      _apiProvider.changeLanguage(lang, version);

  Future<HttpResult> allChatSendImage(int id, String file) =>
      _apiProvider.allChatSendImage(id, file);

  Future<HttpResult> allSubCategory(int id) => _apiProvider.allSubCategory(id);

  Future<HttpResult> allPerformers(bool online, int page) =>
      _apiProvider.allPerformers(online, page);

  Future<HttpResult> getPerformers(String search, String category,
          PerformersFilterModel filter, bool online, int page) =>
      _apiProvider.getPerformers(search, category, filter, online, page);

  Future<HttpResult> getPerformCount(int id) =>
      _apiProvider.getPerformCount(id);

  Future<HttpResult> getPerformImage(int id) =>
      _apiProvider.getPerformImage(id);

  Future<HttpResult> getInfoTask(int id) => _apiProvider.getInfoTask(id);

  Future<HttpResult> getNews() => _apiProvider.getNews();

  Future<HttpResult> getNewsDt(int id) => _apiProvider.getNewsDt(id);

  Future<HttpResult> activeSession() => _apiProvider.activeSession();

  Future<HttpResult> getSupport() => _apiProvider.getSupport();

  Future<HttpResult> deleteSession(String session) =>
      _apiProvider.deleteSession(session);

  Future<HttpResult> getSameTasks(int id) => _apiProvider.getSameTasks(id);

  Future<HttpResult> getOtklikById(int id, String filter, int page) =>
      _apiProvider.getOtklikById(id, filter, page);

  Future<HttpResult> getMyTaskCount(int id) => _apiProvider.getMyTaskCount(id);

  Future<HttpResult> getAllTasksById(int id) =>
      _apiProvider.getAllTasksById(id);

  Future<HttpResult> getMyTasks(int status, int performer, int page) =>
      _apiProvider.getMyTasks(status, performer, page);

  Future<HttpResult> getProfile(int id) => _apiProvider.getProfile(id);

  Future<HttpResult> getStatus() => _apiProvider.getStatus();

  Future<HttpResult> deleteVideo() => _apiProvider.deleteVideo();

  Future<HttpResult> deletePostCode(String code) =>
      _apiProvider.deletePostCode(code);

  ///report user
  Future<HttpResult> reportUser(int id, String msg) =>
      _apiProvider.reportUser(id, msg);

  Future<HttpResult> getSettingsData() => _apiProvider.getSettingsData();
  Future<HttpResult> getAppVersion() => _apiProvider.getAppVersion();

  Future<HttpResult> jaloba(int typeId, int taskId, String text) =>
      _apiProvider.jaloba(typeId, taskId, text);

  Future<HttpResult> giveTask(int perform, int task) =>
      _apiProvider.giveTask(perform, task);

  Future<HttpResult> getVerify(String type, String number) =>
      _apiProvider.getVerify(type, number);

  Future<HttpResult> getAllSettings() => _apiProvider.getAllSettings();

  Future<HttpResult> verifySms(String sms) => _apiProvider.verifySms(sms);

  Future<HttpResult> logout(String device) => _apiProvider.logout(device);

  Future<HttpResult> updateSettings(String email, int age, String location,
          int gender, DateTime bornDate, String name) =>
      _apiProvider.updateSettings(email, age, location, gender, bornDate, name);

  Future<HttpResult> changePassword(
          String oldPassword, String password, String passwordConfirmation) =>
      _apiProvider.changePassword(oldPassword, password, passwordConfirmation);

  Future<HttpResult> changeImage(XFile image, String url) =>
      _apiProvider.changeImage(image, url);

  Future<HttpResult> changeStatus(int id) => _apiProvider.changeStatus(id);

  Future<HttpResult> changeTaskStatus(int id) =>
      _apiProvider.changeTaskStatus(id);

  Future<HttpResult> getTaskInfo(int id) => _apiProvider.getTaskInfo(id);

  Future<HttpResult> otklik(
          int id, String price, String description, int free) =>
      _apiProvider.otklik(id, price, description, free);

  /// create
  Future<HttpResult> createName(
    String name,
    int categoryId,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createName(
        name,
        categoryId,
        taskModel,
      );

  Future<HttpResult> createCustom(
    List<CreateRouteCustomField> customFields,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createCustom(
        customFields,
        taskId,
        taskModel,
      );

  Future<HttpResult> createRemote(
    String radio,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createRemote(
        radio,
        taskId,
        taskModel,
      );

  Future<HttpResult> createAddress(
    SendAddressModel data,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createAddress(
        data,
        taskModel,
      );

  Future<HttpResult> createDate(
    String startDate,
    String endDate,
    int dateType,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createDate(
        startDate,
        endDate,
        dateType,
        taskId,
        taskModel,
      );

  Future<HttpResult> createBudget(
    int amount,
    int budgetType,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createBudget(
        amount,
        budgetType,
        taskId,
        taskModel,
      );

  Future<HttpResult> createNotes(
    String description,
    String docs,
    int taskId,
    List<String> images,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createNotes(
        description,
        docs,
        taskId,
        images,
        taskModel,
      );

  Future<HttpResult> createNumber(
    String phoneNumber,
    int taskId,
    TaskModel? taskModel,
  ) =>
      _apiProvider.createNumber(
        phoneNumber,
        taskId,
        taskModel,
      );

  Future<HttpResult> createNumberVerification(
    String phoneNumber,
    String smsOtp,
    String taskId,
    bool uppdate,
  ) =>
      _apiProvider.createNumberVerification(
        phoneNumber,
        smsOtp,
        taskId,
        update: uppdate,
      );

  Future<HttpResult> deleteTask(int id, int userID) =>
      _apiProvider.deleteTask(id, userID);

  Future<HttpResult> deletePortfolio(int id) =>
      _apiProvider.deletePortfolio(id);

  Future<HttpResult> deleteTemplate(int id) => _apiProvider.deleteTemplate(id);

  Future<HttpResult> popularCategory(String search) =>
      _apiProvider.popularCategory(search);

  Future<HttpResult> setView(int id) => _apiProvider.setView(id);

  Future<HttpResult> deleteUSer() => _apiProvider.deleteUSer();

  Future<HttpResult> initialData(String name, String location, String born) =>
      _apiProvider.initialData(name, location, born);

  Future<HttpResult> postEmail(String email, String phone) =>
      _apiProvider.postEmail(email, phone);

  Future<HttpResult> postCategoryId(String id) =>
      _apiProvider.postCategoryId(id);

  Future<HttpResult> changeCategory(int sms, int email, List<int> category) =>
      _apiProvider.changeCategory(sms, email, category);

  Future<HttpResult> getBalance(
          int type, int page, DateTime startTime, DateTime endTime) =>
      _apiProvider.getBalance(type, page, startTime, endTime);

  Future<HttpResult> getPortfolio(int user) => _apiProvider.getPortfolio(user);
  Future<HttpResult> getResponseTemplate() =>
      _apiProvider.getResponseTemplate();

  Future<HttpResult> getBlockedUsersList() =>
      _apiProvider.getBlockedUsersList();

  Future<HttpResult> getFaqGuides() => _apiProvider.getFaqGuides();

  Future<HttpResult> getFaqGuideById(int id) =>
      _apiProvider.getFaqGuideById(id);

  Future<HttpResult> editDescription(String text) =>
      _apiProvider.editDescription(text);

  Future<HttpResult> createTemplate(String title, String text) =>
      _apiProvider.createTemplate(title, text);

  Future<HttpResult> editTemplate(int id, String title, String text) =>
      _apiProvider.editTemplate(id, title, text);

  Future<HttpResult> editExparience(int text) =>
      _apiProvider.editExparience(text);

  Future<HttpResult> notification(int id) => _apiProvider.notification(id);

  Future<HttpResult> setNotification(String notificationOff, bool notifTime,
          DateTime notificationFrom, DateTime notificationTo) =>
      _apiProvider.setNotification(
          notificationOff, notifTime, notificationFrom, notificationTo);

  Future<HttpResult> notComplete(String reason, int id) =>
      _apiProvider.notComplete(reason, id);

  Future<HttpResult> addLink(String text) => _apiProvider.addLink(text);

  Future<HttpResult> socialLogin(String type, String token) =>
      _apiProvider.loginSocial(type, token);

  Future<HttpResult> editPhone(String text) => _apiProvider.editPhone(text);

  Future<HttpResult> reset(String number) => _apiProvider.reset(number);

  Future<HttpResult> blockUser(int id) => _apiProvider.blockUser(id);

  Future<HttpResult> chatDelete(int id) => _apiProvider.chatDelete(id);

  Future<HttpResult> resetCode(String number, String code) =>
      _apiProvider.resetCode(number, code);

  Future<HttpResult> verifyEmail(String code) => _apiProvider.verifyEmail(code);

  Future<HttpResult> resetPassword(String number, String pass1, String pass2) =>
      _apiProvider.resetPassword(number, pass1, pass2);

  Future<HttpResult> getReviews(int perform, int user, String review) =>
      _apiProvider.getReviews(perform, user, review);

  Future<HttpResult> otmenitTask(int id) => _apiProvider.otmenitTask(id);

  Future<HttpResult> deleteImage(int id, String name) =>
      _apiProvider.deleteImage(id, name);

  Future<HttpResult> deletePortImg(int id, String name) =>
      _apiProvider.deletePortImg(id, name);

  Future<HttpResult> createPortfolio(
          List<XFile> image, String title, String content) =>
      _apiProvider.createPortfolio(image, title, content);

  Future<HttpResult> updatePortfolio(
          int id, List<XFile> image, String title, String content) =>
      _apiProvider.updatePortfolio(id, image, title, content);

  Future<HttpResult> createFavoriteTask(int id) =>
      _apiProvider.createFavoriteTask(id);

  Future<HttpResult> deleteFavoriteTask(int id) =>
      _apiProvider.deleteFavoriteTask(id);

  Future<HttpResult> getAllFavoriteTask(int page) =>
      _apiProvider.getAllFavoriteTask(page);
}
