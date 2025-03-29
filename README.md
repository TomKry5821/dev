# Dev

Repozytorium zawiera pliki konfiguracyjna dla środowiska deweloperskiego projektu SERW.

## Przygotowanie środowiska

W ramach przygotowania należy:

1. Zainstalowanie wtyczki dla grafana/loki-docker-driver:

```sh
   docker plugin install grafana/loki-docker-driver:3.1.2 --alias loki --grant-all-permissions
```

2. Dodanie konfiguracji sterownika w pliku _/etc/docker/deamon.json_:

```json
 {
  "debug": "true",
  "log-driver": "loki",
  "log-opts": {
    "loki-url": "http://localhost:3100/loki/api/v1/push",
    "loki-retries": "5",
    "loki-batch-size": "400"
  }
}
```

3. Restart docker:

```shell
  sudo systemctl restart docker
```

4. Uzupełnienie plików .env wartościami potrzebnymi do prawidłowego działania środowiska.
5. Uruchomić środowisko poleceniem:

```bash
  docker compose -p dev up -d
``` 

6. Dodać schemat keycloak na bazie danych (lub uzupełnić właściwość w pliku .env nazwą schematu, który już istnieje w
   danej bazie):

```postgresql
create schema keycloak;
alter schema keycloak owner to postgres;
```

7. Po uruchomieniu Keycloak należy zalogować się na panel admina, utworzyć lub zaimportować realm, utworzyć w dodanym
   realm klienta (client) uzupełnić zmienne
   środowiskowe powiązane z Keycloak w pliku env modułu reservation:
    1. JWT_ISSUER_URI - adres URI utworzonego realmu np. http://keycloak:8080/realms/dev dla realmu o nazwie dev,
    2. KEYCLOAK_SERVER_URL - adres Keycloak, dla środowiska deweloperskiego będzie to http://keycloak:8080/
    3. KEYCLOAK_REALM - nazwa realmu np. dev,
    4. KEYCLOAK_RESOURCE - nazwa utworzonego w realmie klienta np. dev-client,
    5. KEYCLOAK_CREDENTIALS_SECRET - sekret klienta, który należy skopiować ze szczegółów klienta w panelu Keycloak.
2. W utworzonym kliencie należy dodać rolę **employee**.
3. Dodać użytkownika z rolą **employee** w utworzonym kliencie.

Po wykonaniu wszystkich kroków środowisko będzie gotowe do pracy.

Dostępne usługi:

1. Keycloak pod adresem http://localhost:8030
2. Traefik pod adresem https://localhost/dashboard/#/
3. Grafana pod adresem https://localhost/grafana/

## Dodanie pulpitów w Grafanie

Aby móc monitorować działanie środowiska z poziomu Grafany należy w serwisie grafany:

1. Dodać źródło danych Loki, przy dodawaniu należy uzupełnić parametr **URL** w zakładce **Connection** wartością *
   *http://loki:3100**.
2. Dodać źródło danych prometheus, przy dodawaniu należy uzupełnić parametr **URL** w zakładce **Connection** wartością
   **http://prometheus:9090**.
3. Zaimportować szablonu w postaci plików json z katalogu [dashboards](config/grafana/dashboards) - należy zwrócić uwagę
   na wybranie odpowiednich źródeł danych, które będą wykorzystywane w pulpitach.