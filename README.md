# webalive

Тестовое задание для бэкенд разработчика.

Реализовать CRUD проект проверки доступности веб ресурсов,
используя: postgres, docker compose, git, perl, DBI::Pg, Mojo::Base 'Mojolicious', Mojo::UserAgent.

Проект должен лежать в git репозитории и подниматься с помощью команды docker-compose up.

Проект должен состоять из двух сервисов: http server для CRUD и daemon для запросов к веб ресурсам.

HTTP Server по индексу должен показывать таблицу со следующими полями:
url веб ресурса, дата получения, http status, три первых http заголовка.

Перепроверка доступности всех веб ресурсов должна осуществляться каждые 5 минут,
при добавление нового веб ресурса, получение статуса его доступности должно быть произведено сразу же.
