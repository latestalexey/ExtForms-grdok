﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Дата = '2016-01-01';
	
	ДобавитьПроверку("СебестоимостьТоваров");
	ДобавитьПроверку("ПартииНезавершенногоПроизводства");
	ДобавитьПроверку("ПартииПроизводственныхЗатрат");
	ДобавитьПроверку("ПартииПрочихРасходов");
	ДобавитьПроверку("ПрочиеРасходы");
	ДобавитьПроверку("МатериалыИРаботыВПроизводстве");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПроверку(Имя, Пометка = Истина)
	
	НоваяСтрока = Объект.ТаблицаПроверок.Добавить();
	НоваяСтрока.Имя     = Имя;
	НоваяСтрока.Пометка = Пометка;
	
КонецПроцедуры	

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	Для каждого СтрокаТЧ из Объект.ТаблицаПроверок Цикл
		
		Если НЕ СтрокаТЧ.Пометка Тогда
			Продолжить;
		КонецЕсли;	
		
		Если СтрокаТЧ.Имя = "СебестоимостьТоваров" Тогда
			Результат = СебестоимостьТоваров();
			
		ИначеЕсли СтрокаТЧ.Имя = "ПартииНезавершенногоПроизводства" Тогда
			Результат = ПартииНезавершенногоПроизводства();
			
		ИначеЕсли СтрокаТЧ.Имя = "ПартииПроизводственныхЗатрат" Тогда
			Результат = ПартииПроизводственныхЗатрат();
			
		ИначеЕсли СтрокаТЧ.Имя = "ПартииПрочихРасходов" Тогда
			Результат = ПартииПрочихРасходов();
			
		ИначеЕсли СтрокаТЧ.Имя = "ПрочиеРасходы" Тогда
			Результат = ПрочиеРасходы();
			
		ИначеЕсли СтрокаТЧ.Имя = "МатериалыИРаботыВПроизводстве" Тогда
			Результат = МатериалыИРаботыВПроизводстве();
		КонецЕсли;	
		
		Если Результат Тогда
			СтрокаТЧ.Результат = "ОК";
		Иначе
			СтрокаТЧ.Результат = "Есть остатки";
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СебестоимостьТоваров()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Объект.Дата);
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.РазделУчета,
	|	Рег.ВидЗапасов,
	|	Рег.Организация,
	|	Рег.КоличествоОстаток КАК Количество,
	|	Рег.СтоимостьОстаток КАК Стоимость,
	|	Рег.СтоимостьБезНДСОстаток КАК СтоимостьБезНДС,
	|	Рег.СуммаДопРасходовОстаток КАК СуммаДопРасходов,
	|	Рег.СуммаДопРасходовБезНДСОстаток КАК СуммаДопРасходовБезНДС,
	|	Рег.СтоимостьРеглОстаток КАК СтоимостьРегл,
	|	Рег.ПостояннаяРазницаОстаток КАК ПостояннаяРазница,
	|	Рег.ВременнаяРазницаОстаток КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И РазделУчета <> ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)) КАК Рег
	|ГДЕ
	|	Рег.КоличествоОстаток <= 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.РазделУчета,
	|	Рег.ВидЗапасов,
	|	Рег.Организация,
	|	Рег.КоличествоОстаток,
	|	Рег.СтоимостьОстаток,
	|	Рег.СтоимостьБезНДСОстаток,
	|	Рег.СуммаДопРасходовОстаток,
	|	Рег.СуммаДопРасходовБезНДСОстаток,
	|	Рег.СтоимостьРеглОстаток,
	|	Рег.ПостояннаяРазницаОстаток,
	|	Рег.ВременнаяРазницаОстаток
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция ПартииНезавершенногоПроизводства()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Объект.Дата);
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.ВидЗапасов,
	|	Рег.ЗаказНаПроизводство,
	|	Рег.КодСтрокиПродукция,
	|	Рег.ДокументПоступления,
	|	Рег.Этап,
	|	Рег.СтатьяКалькуляции,
	|	Рег.АналитикаУчетаПартий,
	|	Рег.КоличествоОстаток КАК Количество,
	|	Рег.СтоимостьОстаток КАК Стоимость,
	|	Рег.СтоимостьБезНДСОстаток КАК СтоимостьБезНДС,
	|	Рег.СтоимостьРеглОстаток КАК СтоимостьРегл,
	|	Рег.НДСРеглОстаток КАК НДСРегл,
	|	Рег.ПостояннаяРазницаОстаток КАК ПостояннаяРазница,
	|	Рег.ВременнаяРазницаОстаток КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.ПартииНезавершенногоПроизводства.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция ПартииПроизводственныхЗатрат()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Объект.Дата);
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.ВидЗапасов,
	|	Рег.ДокументПоступления,
	|	Рег.АналитикаУчетаПартий,
	|	Рег.КоличествоОстаток,
	|	Рег.СтоимостьОстаток,
	|	Рег.СтоимостьБезНДСОстаток,
	|	Рег.СтоимостьРеглОстаток,
	|	Рег.НДСРеглОстаток,
	|	Рег.ПостояннаяРазницаОстаток,
	|	Рег.ВременнаяРазницаОстаток
	|ИЗ
	|	РегистрНакопления.ПартииПроизводственныхЗатрат.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция ПартииПрочихРасходов()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Объект.Дата);
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.Подразделение,
	|	Рег.СтатьяРасходов,
	|	Рег.АналитикаРасходов,
	|	Рег.ДокументПоступленияРасходов,
	|	Рег.АналитикаУчетаПартий,
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.СтоимостьОстаток КАК Стоимость,
	|	Рег.СтоимостьБезНДСОстаток КАК СтоимостьБезНДС,
	|	Рег.СтоимостьРеглОстаток КАК СтоимостьРегл,
	|	Рег.НДСРеглОстаток КАК НДСРегл,
	|	Рег.ПостояннаяРазницаОстаток КАК ПостояннаяРазница,
	|	Рег.ВременнаяРазницаОстаток КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.ПартииПрочихРасходов.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция ПрочиеРасходы()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Объект.Дата);
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.Подразделение,
	|	Рег.СтатьяРасходов,
	|	Рег.АналитикаРасходов,
	|	Рег.СуммаОстаток КАК Сумма,
	|	Рег.СуммаБезНДСОстаток КАК СуммаБезНДС,
	|	Рег.СуммаРеглОстаток КАК СуммаРегл,
	|	Рег.ПостояннаяРазницаОстаток КАК ПостояннаяРазница,
	|	Рег.ВременнаяРазницаОстаток КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И НЕ СтатьяРасходов.ВариантРаспределенияРасходов В (&ВариантыРаспределения)) КАК Рег";
	
	ВариантыРаспределения = Новый Массив;
	ВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы);
	ВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов);
	Запрос.Параметры.Вставить("ВариантыРаспределения", ВариантыРаспределения);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция МатериалыИРаботыВПроизводстве()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Объект.Дата);
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Рег.Организация,
	|	Рег.Номенклатура,
	|	Рег.Характеристика,
	|	Рег.Подразделение,
	|	Рег.Серия,
	|	Рег.Назначение,
	|	Рег.УдалитьАналитикаУчетаНоменклатуры,
	|	Рег.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаКлиенте
Процедура ТаблицаПроверокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТЧ = Объект.ТаблицаПроверок.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	АдресХранилища = "";
	Описание = Новый ОписаниеОповещения("ПомещениеФайлаОкончание", ЭтотОбъект, СтрокаТЧ.Имя);
	НачатьПомещениеФайла(Описание, АдресХранилища, ИмяКаталога() + "\" + СтрокаТЧ.Имя + ".erf", Ложь, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаОкончание(Результат, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
    ИмяОтчета = ПодключитьВнешнийОтчет(АдресХранилища);
	
    // Откроем форму подключенной внешней обработки
    ОткрытьФорму("ВнешнийОтчет."+ ИмяОтчета +".Форма");	//
	
КонецПроцедуры

&НаСервере
Функция ИмяКаталога()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ФайлОбработки = ОбработкаОбъект.ИспользуемоеИмяФайла;
	Файл = Новый Файл(ФайлОбработки);
	
	Возврат Файл.Путь;
	
КонецФункции	

&НаСервере
Функция ПодключитьВнешнийОтчет(АдресХранилища)
	
	Возврат ВнешниеОтчеты.Подключить(АдресХранилища);
	
КонецФункции	

&НаКлиенте
Процедура ВклВсе(Команда)
	
	Для каждого СтрокаТЧ из Объект.ТаблицаПроверок Цикл
		СтрокаТЧ.Пометка = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыклВсе(Команда)
	
	Для каждого СтрокаТЧ из Объект.ТаблицаПроверок Цикл
		СтрокаТЧ.Пометка = Ложь;
	КонецЦикла;	
	
КонецПроцедуры
