# Dev

Repozytorium zawiera pliki konfiguracyjna dla środowiska deweloperskiego projektu SERW.

## Przygotowanie środowiska

W ramach przygotowania należy:

1. Wywołać skrypty:

```bash
  bash prepare_directories.sh 
```

odpowiadający za utworzenie potrzebnych katalogów i nadanie im
odpowiednich uprawnień.

1. Uzupełnić utworzone pliki .env wartościami potrzebnymi do prawidłowego działania środowiska.
2. Uruchomić środowisko poleceniem:

```bash
  docker compose -p dev up -d
``` 

1. Dodać schemat keycloak na bazie danych:

```postgresql
create schema keycloak;
alter schema keycloak owner to postgres;
```

1. Po uruchomieniu Keycloak należy zalogować się na panel admina, utworzyć lub zaimportować realm, utworzyć w dodanym
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
2. Traefik pod adresem http://localhost:8085/dashboard/#/
3. cAdvisor pod adresem http://localhost:8084/docker/