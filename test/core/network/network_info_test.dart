
import 'package:clean_tdd_trivia_app/src/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InternetConnectionCheckerPlus>()
])

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionCheckerPlus mockInternetConnectionCheckerPlus;

  setUp(() {
    mockInternetConnectionCheckerPlus = MockInternetConnectionCheckerPlus();
    networkInfo = NetworkInfoImpl(mockInternetConnectionCheckerPlus);
  });

  group('is connected:', () {

    test(
      "should forward the call to InternetConnectionCheckerPlus.hasConnection",
      () async {
        var tHasConnection = Future.value(true);
        when(mockInternetConnectionCheckerPlus.hasConnection).thenAnswer((realInvocation) => tHasConnection);

        final response = networkInfo.isConnected;

        verify(mockInternetConnectionCheckerPlus.hasConnection);

        expect(response, tHasConnection);
      },
    );
  });
}