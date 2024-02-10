## Решение кейса. Реализация регулярного ETL-потока [Apache NIFI](https://nifi.apache.org/). Lookup csv файла с обращением к API стороннего сервиса.  
### Сама азадача звучит следующим образом:  
"  
Вы работаете в компании, которая производит и продаёт фигурки персонажей Гарри Поттера.
В файле [sales.csv](sales.csv) сгенерирована история продаж. Этот файл можно пополнять при помощи python скриптов ([genOneDay.py](genOneDay.py), [genFewDays.py](genFewDays.py), [genManyDays.py](genManyDays.py)), имитируя поступление свежих данных (генерация идёт целыми днями, по 1 или по нескольку дней за 1 запуск).
Кроме того, имеется [сторонняя база данных](https://hp-api.onrender.com/), которая предоставляет REST API интерфейс, и имитирует расширенный набор мастер данных, детально описывающий каждую SKU.

Неободимо реализовать ETL поток в среде Nifi, который позволит считывать факт продаж из [sales.csv](sales.csv), группировать его до детализации sale_date - house - amount - last_verstamp, и запишет результаты в файл [house_sales](house_sales). 
House - атрибут персонажа, характеризующий Факультет, к которому тот относится, и информация о котором есть только в API.

Реализация должна учитывать, что при поступлении свежих данных в [sales.csv](sales.csv), поток при очередном запуске должен забирать только новую информацию, и дозаписывать её в [house_sales](house_sales) (допускается вариант с генерацией нового файла при каждом запуске, рядом с уже существующими, но заполнение нового файла должно происходить только теми данными, которых не было во всех предыдущих запусках). 
Кроме того, мастер данные по SKU могут меняться (как бы это не было нелепо в контексте тематики, но представим себе, что операторы, заполняющие мастер данные, могут ошибиться, и в какой-то момент поменять атрибут персонажа), а значит обращаться в REST API нужно при каждом запуске потока. 
"  

### [Мое решение](case_v4.xml)

Повествование будет представлено по шагам последовательности котороая должна соблюдаться для корректной работы потока.  
![Flow_of_case_with_steps.png](PNG%2FFlow_of_case_with_steps.png)  
[Файл](case_v4.xml) самого Flow.  
1. Выгрузка файла  
2. Присвоение атрибута key_verstamp для FlowFile, прибегнул к ExecuteScript, сам скрипт представлен в файле [ExecuteScript.py](ExecuteScript%2FExecuteScript.py). Значение атрибута извлекается из [key_verstamp.csv](key_verstamp%2Fkey_verstamp.csv) (при первом запуске, значение атрибута будет "0").  
3. Присвоение атрибутов filename и schema.text  
4. Создание SQL запросов к выгруженному файлу. CSV_lookup_file - необходим для выделения уникальных character_id и пустого столбца house. fresh_rows - выделение из выгруженного файла новых строк по признаку атрибута key_verstamp. last_verstamp - выделение значения verstamp последней строки в выгруженном файле шага 1.  
5. Короткий Flow который создает файл с [key_verstamp.csv](key_verstamp%2Fkey_verstamp.csv) выгружая туда значение SQL запроса last_verstamp шага 4.  
6. Разбиение результата запроса CSV_lookup_file на отдельные строки из шага 4.  
7. Создание атрибута character_id путем извлечения значения из текста регулярным выражением "(........-....-....-....-............)".  
8. Присвоение атрибутов filename и schema.text.  
9. Обогащение Flowfiles значения столбца house для каждого character_id путем обращения к API через Lookup Service "RestLookupService_look". В URL этого "RestLookupService_look" подставляется значение character_id из шага 7 https://hp-api.onrender.com/api/character/${character_id}  
10. Оъединение всех Flowfiles в один файл.  
11. Выгрузка результатов в [CSV_lookup_file.csv](CSV_lookup_file%2FCSV_lookup_file.csv)  
12. Шаг выполняет задачу "задержки" Flowfile по времени, до окончания формирования [CSV_lookup_file.csv](CSV_lookup_file%2FCSV_lookup_file.csv)  
13. fresh_rows через Lookup Service "CSVRecordLookupService_look" обогащается столбцом house из [CSV_lookup_file.csv](CSV_lookup_file%2FCSV_lookup_file.csv) по ключевому столбцу character_id.  
14. SQL запрос приводящий данные к финальному запрашиваемому виду "sale_date - house - amount - last_verstamp".  
15. Выгрузка в файловую систему.  
### Полезные ссылки которые пригодились при выполнении задания 
[How to run Custom Scripts in Apache NiFi](https://github.com/InsightByte/ApacheNifi/tree/main/Custom-Scripts)  
[Регулярные выражения, онлайн](https://regex101.com/)  
[Обращение к контенту JSON](https://github.com/json-path/JsonPath)  
[JSONPath Online Evaluator](https://jsonpath.com/)  
[Apache NiFi Expression Language Guide](https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html)
