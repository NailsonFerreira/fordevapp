import 'package:faker/faker.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/usecases/usecases.dart';





class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParams? params;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
  });

  test("Should throw UnecpectedError if HttpClient returns 400", () async {
    when(httpClient?.request(url: anyNamed("url"), method:anyNamed("method"), body: anyNamed("body")))
    .thenThrow(HttpError.badRequest);
    

    final future =  sut?.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
}
