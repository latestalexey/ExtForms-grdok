﻿Функция ДопсоглашениеВнешняяТекстЗапросаШапки()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОсновныеДанныеКонтрактаДоговораСотрудникаСрезПоследних.НомерДоговораКонтракта,
	|	ОсновныеДанныеКонтрактаДоговораСотрудникаСрезПоследних.ДатаДоговораКонтракта,
	|	ОсновныеДанныеКонтрактаДоговораСотрудникаСрезПоследних.ПоступлениеНаСлужбуВпервые,
	|	Сотрудники.Ссылка,
	|	ФИОФизическихЛицСрезПоследних.Фамилия,
	|	ФИОФизическихЛицСрезПоследних.Имя,
	|	ФИОФизическихЛицСрезПоследних.Отчество,
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо,
	|	ДокументыФизическихЛицСрезПоследних.Серия,
	|	ДокументыФизическихЛицСрезПоследних.Номер,
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
	|	ДокументыФизическихЛицСрезПоследних.КемВыдан,
	|	ОрганизацииКонтактнаяИнформация.Представление,
	|	ОрганизацииКонтактнаяИнформация.Город,
	|	Сотрудники.Ссылка КАК Сотрудник,
	|	Сотрудники.Наименование КАК СотрудникНаименование,
	|	Сотрудники.ГоловнаяОрганизация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	Сотрудники.ГоловнаяОрганизация КАК Организация,
	|	Сотрудники.ГоловнаяОрганизация.ИНН КАК ОрганизацияИНН,
	|	Сотрудники.ГоловнаяОрганизация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
	|	Сотрудники.ГоловнаяОрганизация.ОГРН КАК ОрганизацияОГРН,
	|	Сотрудники.ГоловнаяОрганизация.РегистрацияВНалоговомОргане.КПП КАК ОрганизацияРегистрацияВНалоговомОрганеКПП,
	|	ОсновныеДанныеКонтрактаДоговораСотрудникаСрезПоследних.ФизическоеЛицо.ИНН КАК ФизическоеЛицоИНН
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации.КонтактнаяИнформация КАК ОрганизацииКонтактнаяИнформация
	|		ПО (ОрганизацииКонтактнаяИнформация.Ссылка = Сотрудники.ГоловнаяОрганизация)
	|			И (ОрганизацииКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеДанныеКонтрактаДоговораСотрудника.СрезПоследних КАК ОсновныеДанныеКонтрактаДоговораСотрудникаСрезПоследних
	|		ПО (ОсновныеДанныеКонтрактаДоговораСотрудникаСрезПоследних.Сотрудник = Сотрудники.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
	|		ПО Сотрудники.ФизическоеЛицо = ФИОФизическихЛицСрезПоследних.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних КАК ДокументыФизическихЛицСрезПоследних
	|		ПО Сотрудники.ФизическоеЛицо = ДокументыФизическихЛицСрезПоследних.Физлицо
	|ГДЕ
	|	Сотрудники.Ссылка В(&МассивОбъектов)";	
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПечатьДопсоглашениеВнешняя(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб			= Истина;
	ТабДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_" + ИмяМакета;
	
	//   НаименованиеСокращенное
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ДопсоглашениеВнешняяТекстЗапросаШапки();
	
	Шапка = Запрос.Выполнить().Выбрать();
	//Макет = ПолучитьМакет("Допсоглашение");
	Макет = ПолучитьМакет(ИмяМакета);
	
	Пока Шапка.Следующий() Цикл
		
		ДД = Формат(Шапка.ДатаДоговораКонтракта , "ДЛФ=DD; ДП='""___"" ____________ 20___ г.'");	
		НД = Шапка.НомерДоговораКонтракта	;
		
		Организация	                       = Шапка.Организация;//.НаименованиеСокращенное;
		ОрганизацияНаименованиеПолное      = Шапка.ОрганизацияНаименованиеПолное;
		ОрганизацияГородФактическогоАдреса = СтрЗаменить(Шапка.Город," г","") ;
		ОрганизацияАдресЮридический        = Шапка.Представление;
		ОрганизацияИНН	                   = Шапка.ОрганизацияИНН;
		
		КПП  		= Шапка.ОрганизацияРегистрацияВНалоговомОрганеКПП;
		ОКПО	    = Шапка.ОрганизацияКодПоОКПО ;
		ОГРН	    = Шапка.ОрганизацияОГРН;
		СотрудникФИО	    = Шапка.СотрудникНаименование ;
		ДатаДС	            = Формат('2016-10-03' , "ДЛФ=DD; ДП='""___"" ____________ 20___ г.'");
		
		ТрудовойДоговорДата = """___"" ____________ 20___ г.";
		
		ФамилияИО   = Строка(Шапка.Фамилия) +" "+Лев(Строка(Шапка.Имя),1)+"."+Лев(Строка(Шапка.Отчество),1)+".";
		
		ФИОПолные	 = СотрудникФИО;	
		
		ДокументПредставление	 = Строка(Шапка.Серия) +" №"+Строка(Шапка.Номер)+" выдан "+Строка(Шапка.КемВыдан)+" "+
		Формат(Шапка.ДатаВыдачи , "ДЛФ=DD;");			
		АдресПоПропискеПредставление  = "";
		
		СведенияПоРуководителю = ОтветственныеЛицаСервер.ПолучитьДанныеОтветственногоЛица(Шапка.Организация, ТекущаяДатаСеанса(), 
		Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
		
		РуководительДолжность    = СведенияПоРуководителю.Должность;
		
		РуководительФИОПолные    = СведенияПоРуководителю.ФизическоеЛицо.Наименование;
		
		РезультатСклонения = "";
		Если ФизическиеЛицаЗарплатаКадры.Просклонять(РуководительФИОПолные, 2, РезультатСклонения, СведенияПоРуководителю.ФизическоеЛицо.Пол) Тогда
			РуководительФИОПолные_РП = РезультатСклонения
		КонецЕсли;
		
		Фамилия=Лев(РуководительФИОПолные,Найти(РуководительФИОПолные," "));
		РуководительФИОПолные2=СокрЛП(СтрЗаменить(РуководительФИОПолные,Фамилия,""));
		Имя=   Лев(РуководительФИОПолные2,Найти(РуководительФИОПолные2," "));
		Отчество=СокрЛП(СтрЗаменить(РуководительФИОПолные2,Имя,""));
		
		РуководительФамилияИО   = Строка(Фамилия) +" "+Строка(Лев(Имя,1))+"."+Строка(Лев(Отчество,1))+".";
		
		Запрос1 = Новый Запрос;
		Запрос1.Текст =
		"ВЫБРАТЬ
		|	ФизическиеЛицаКонтактнаяИнформация.Ссылка,
		|	ФизическиеЛицаКонтактнаяИнформация.НомерСтроки,
		|	ФизическиеЛицаКонтактнаяИнформация.Тип,
		|	ФизическиеЛицаКонтактнаяИнформация.Вид,
		|	ФизическиеЛицаКонтактнаяИнформация.Представление,
		|	ФизическиеЛицаКонтактнаяИнформация.ЗначенияПолей,
		|	ФизическиеЛицаКонтактнаяИнформация.Страна,
		|	ФизическиеЛицаКонтактнаяИнформация.Регион,
		|	ФизическиеЛицаКонтактнаяИнформация.Город,
		|	ФизическиеЛицаКонтактнаяИнформация.АдресЭП,
		|	ФизическиеЛицаКонтактнаяИнформация.ДоменноеИмяСервера,
		|	ФизическиеЛицаКонтактнаяИнформация.НомерТелефона,
		|	ФизическиеЛицаКонтактнаяИнформация.НомерТелефонаБезКодов
		|ИЗ
		|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|ГДЕ
		|	ФизическиеЛицаКонтактнаяИнформация.Ссылка = &Ссылка
		|	И ФизическиеЛицаКонтактнаяИнформация.Вид = &Вид";
		
		Запрос1.УстановитьПараметр("Ссылка",Шапка.ФизическоеЛицо);
		Адреспопрописке	= Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица;
		Запрос1.УстановитьПараметр("Вид",Адреспопрописке);
		Выборка1 = Запрос1.Выполнить().Выбрать();
		Выборка1.Следующий();
		АдресПоПропискеПредставление =	Выборка1.Представление;
		
		Параметры = Новый Структура;
		Параметры.Вставить("РаботникИНН",  Шапка.Сотрудник.ФизическоеЛицо.ИНН);
		Параметры.Вставить("РаботникПФР",  Шапка.Сотрудник.ФизическоеЛицо.СтраховойНомерПФР);
		Параметры.Вставить("Пол",          Шапка.Сотрудник.ФизическоеЛицо.Пол);
		Параметры.Вставить("ДокументПредставление", ДокументПредставление);
		Параметры.Вставить("ФИОПолные", ФИОПолные);
		Параметры.Вставить("ФамилияИО", ФамилияИО);
		Параметры.Вставить("РуководительФамилияИО", РуководительФамилияИО);
		Параметры.Вставить("НД", НД);
		Параметры.Вставить("ДД", ДД);
		Параметры.Вставить("ОрганизацияНаименованиеПолное", ОрганизацияНаименованиеПолное);
		Параметры.Вставить("ОрганизацияГородФактическогоАдреса", ОрганизацияГородФактическогоАдреса);
		Параметры.Вставить("ОрганизацияАдресЮридический", ОрганизацияАдресЮридический);
		Параметры.Вставить("ОрганизацияИНН", ОрганизацияИНН);
		Параметры.Вставить("КПП", КПП);
		Параметры.Вставить("ОКПО", ОКПО);
		Параметры.Вставить("ОГРН", ОГРН);
		Параметры.Вставить("ДатаДС", ДатаДС);
		Параметры.Вставить("ТрудовойДоговорДата", ТрудовойДоговорДата);
		Параметры.Вставить("РуководительДолжность", РуководительДолжность);
		Параметры.Вставить("РуководительФИОПолные", РуководительФИОПолные);
		Параметры.Вставить("РуководительФИОПолные_РП", РуководительФИОПолные_РП);
		Параметры.Вставить("АдресПоПропискеПредставление", АдресПоПропискеПредставление);
		
		Макет.Параметры.Заполнить(Параметры);
		ТабДокумент.Вывести(Макет);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
	ТабДокумент.ТолькоПросмотр=Истина;
	ТабДокумент.АвтоМасштаб = Истина;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДокумент.ОтображатьГруппировки = ложь;
	ТабДокумент.ОтображатьЗаголовки = ложь;
	ТабДокумент.ОтображатьСетку = ложь;
	
	Возврат ТабДокумент;
	
КонецФункции

// Сервисная экспортная функция. Вызывается в основной программе при регистрации обработки в информационной базе
// Возвращает структуру с параметрами регистрации
//
// Возвращаемое значение:
//		Структура с полями:
//			Вид - строка, вид обработки, один из возможных: "ДополнительнаяОбработка", "ДополнительныйОтчет", 
//					"ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов"
//			Назначение - Массив строк имен объектов метаданных в формате: 
//					<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
//					Например, "Документ.СчетЗаказ" или "Справочник.*". Параметр имеет смысл только для назначаемых обработок, для глобальных может не задаваться.
//			Наименование - строка - Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию.
//			Информация  - строка - Краткая информация или описание по обработке.
//			Версия - строка - Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу.
//			БезопасныйРежим - булево - Принимает значение Истина или Ложь, в зависимости от того, требуется ли устанавливать или отключать безопасный режим 
//							исполнения обработок. Если истина, обработка будет запущена в безопасном режиме. 
//
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	//Инициализируем структуру с параметрами регистрации
	
	//Определяем список объектов, вызывающих обработку
	ОбъектыНазначенияФормы = Новый Массив;
	ОбъектыНазначенияФормы.Добавить("Справочник.Сотрудники");
	
	ПараметрыРегистрации = ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы);
	ПараметрыРегистрации.Версия = "1.0";
	
	//Определяем команды для печати формы
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
	"Допсоглашение п. 4.4 (Внешняя печ. форма)", // Представление команды в пользовательском интерфейсе
	"ДопсоглашениеП44",				// Уникальный идентификатор команды
	);
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Формирует структуру с параметрами регистрации регистрации обработки в информационной базе
//
// Параметры:
//	ОбъектыНазначенияФормы - Массив - Массив строк имен объектов метаданных в формате: 
//					<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
//					или строка с именем объекта метаданных 
//	НаименованиеОбработки - строка - Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию.
//							Необязательно, по умолчанию синоним или представление объекта
//	Информация  - строка - Краткая информация или описание обработки.
//							Необязательно, по умолчанию комментарий объекта
//	Версия - строка - Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу.
//
//
// Возвращаемое значение:
//		Структура
//
Функция ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы = Неопределено, НаименованиеОбработки = "", Информация = "", Версия = "1.0")
	
	Если ТипЗнч(ОбъектыНазначенияФормы) = Тип("Строка") Тогда
		ОбъектНазначенияФормы = ОбъектыНазначенияФормы;
		ОбъектыНазначенияФормы = Новый Массив;
		ОбъектыНазначенияФормы.Добавить(ОбъектНазначенияФормы);
	КонецЕсли; 
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Назначение", ОбъектыНазначенияФормы);
	
	Если Не ЗначениеЗаполнено(НаименованиеОбработки) Тогда
		НаименованиеОбработки = ЭтотОбъект.Метаданные().Представление();
	КонецЕсли; 
	ПараметрыРегистрации.Вставить("Наименование", НаименованиеОбработки);
	
	Если Не ЗначениеЗаполнено(Информация) Тогда
		Информация = ЭтотОбъект.Метаданные().Комментарий;
	КонецЕсли; 
	ПараметрыРегистрации.Вставить("Информация", Информация);
	
	ПараметрыРегистрации.Вставить("Версия", Версия);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Вспомогательная процедура.
//
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование = "ВызовСерверногоМетода", ПоказыватьОповещение = Ложь, Модификатор = "ПечатьMXL")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

// Формирует таблицу значений с командами печати
//	
// Возвращаемое значение:
//		ТаблицаЗначений
//
Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	
	//Представление команды в пользовательском интерфейсе
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	//Уникальный идентификатор команды или имя макета печати
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	
	//Способ вызова команды: "ОткрытиеФормы", "ВызовКлиентскогоМетода", "ВызовСерверногоМетода"
	// "ОткрытиеФормы" - применяется только для отчетов и дополнительных отчетов
	// "ВызовКлиентскогоМетода" - вызов процедуры Печать(), определённой в модуле формы обработки
	// "ВызовСерверногоМетода" - вызов процедуры Печать(), определённой в модуле объекта обработки
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	
	//Показывать оповещение.
	//Если Истина, требуется показать оповещение при начале и при завершении работы обработки. 
	//Имеет смысл только при запуске обработки без открытия формы
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	
	//Дополнительный модификатор команды. 
	//Используется для дополнительных обработок печатных форм на основе табличных макетов.
	//Для таких команд должен содержать строку ПечатьMXL
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

// Экспортная процедура печати, вызываемая из основной программы
//
// Параметры:
// ВХОДЯЩИЕ:
//  МассивОбъектовНазначения - Массив - список объектов ссылочного типа для печати документа
//                 Как правило, содержит один элемент с ссылкой на вызвавший форму объект (документ, справочник)
//
// ИСХОДЯЩИЕ:
//  КоллекцияПечатныхФорм - ТаблицаЗначений - таблица сформированных табличных документов.
//                 Как правило, содержит одну строку с именем текущей печатной формы
//  ОбъектыПечати - СписокЗначений - список объектов печати. 
//  ПараметрыВывода - Структура - Параметры сформированных табличных документов. Содержит поля:
//  						ДоступнаПечатьПоКомплектно - булево - по умолчанию Ложь
//							ПолучательЭлектронногоПисьма
//							ОтправительЭлектронногоПисьма
//
Процедура Печать(МассивОбъектовНазначения, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДопсоглашениеП44") Тогда
		
		ТабличныйДокумент = ПечатьДопсоглашениеВнешняя(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_ДополнительноеСоглашениеП44");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ДопсоглашениеП44",
		"Допсоглашение п. 4.4 (Внешняя печ. форма)",
		ТабличныйДокумент
		);
		
	КонецЕсли;
	
КонецПроцедуры

