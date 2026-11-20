// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'EduSnap';

  @override
  String get list => '清單';

  @override
  String get settings => '設定';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get save => '儲存';

  @override
  String get back => '返回';

  @override
  String get title => '標題';

  @override
  String get note => '筆記';

  @override
  String get addPhoto => '新增照片';

  @override
  String get changePhoto => '更換照片';

  @override
  String get gallery => '相簿';

  @override
  String get camera => '相機';

  @override
  String get cameraAccessNeeded => '需要相機權限才能拍照。';

  @override
  String get photoLibraryAccessNeeded => '需要相簿權限才能選擇照片。';

  @override
  String get notNow => '暫時不要';

  @override
  String get openSettings => '開啟設定';

  @override
  String get titleMissing => '請輸入標題';

  @override
  String get ok => '確定';

  @override
  String get noPhoto => '沒有照片';

  @override
  String get emptyValue => '-';

  @override
  String get noEntries => '尚無日記，點擊右上角 + 新增。';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }

  @override
  String get language => '語言';

  @override
  String get storageUsage => '儲存空間使用量';

  @override
  String storageUsed(String size) {
    return '已使用 $size KB';
  }

  @override
  String get formatData => '格式化 / 清除所有資料';

  @override
  String get confirmClearTitle1 => '清除所有資料？';

  @override
  String get confirmClearMsg1 => '這將會刪除所有的日記與相片。';

  @override
  String get confirmClearTitle2 => '確定要執行嗎？';

  @override
  String get confirmClearMsg2 => '此操作無法復原，所有資料將永久消失。';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定清除';

  @override
  String get version => '版本';

  @override
  String get buildNumber => '建置編號';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appName => 'EduSnap';

  @override
  String get list => '清單';

  @override
  String get settings => '設定';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get save => '儲存';

  @override
  String get back => '返回';

  @override
  String get title => '標題';

  @override
  String get note => '筆記';

  @override
  String get addPhoto => '新增照片';

  @override
  String get changePhoto => '更換照片';

  @override
  String get gallery => '相簿';

  @override
  String get camera => '相機';

  @override
  String get cameraAccessNeeded => '需要相機權限才能拍照。';

  @override
  String get photoLibraryAccessNeeded => '需要相簿權限才能選擇照片。';

  @override
  String get notNow => '暫時不要';

  @override
  String get openSettings => '開啟設定';

  @override
  String get titleMissing => '請輸入標題';

  @override
  String get ok => '確定';

  @override
  String get noPhoto => '沒有照片';

  @override
  String get emptyValue => '-';

  @override
  String get noEntries => '尚無日記，點擊右上角 + 新增。';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }

  @override
  String get language => '語言';

  @override
  String get storageUsage => '儲存空間使用量';

  @override
  String storageUsed(String size) {
    return '已使用 $size KB';
  }

  @override
  String get formatData => '格式化 / 清除所有資料';

  @override
  String get confirmClearTitle1 => '清除所有資料？';

  @override
  String get confirmClearMsg1 => '這將會刪除所有的日記與相片。';

  @override
  String get confirmClearTitle2 => '確定要執行嗎？';

  @override
  String get confirmClearMsg2 => '此操作無法復原，所有資料將永久消失。';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定清除';

  @override
  String get version => '版本';

  @override
  String get buildNumber => '建置編號';
}
