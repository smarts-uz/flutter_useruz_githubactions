import 'package:rxdart/subjects.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/model/api/search_to_location_model.dart';
import 'package:youdu/src/model/http_result.dart';

class SearchAddressBloc {
  final Repository _repository = Repository();

  final _fetchAddress = PublishSubject<SearchToLocationModel>();

  Stream<SearchToLocationModel> get getAddressSearch => _fetchAddress.stream;

  allAddressSearch(String address) async {
    HttpResult response = await _repository.addressToLocation(address);
    if (response.isSuccess) {
      SearchToLocationModel data =
          SearchToLocationModel.fromJson(response.result);
      _fetchAddress.sink.add(data);
    }
  }
}

final searchAddressBloc = SearchAddressBloc();
