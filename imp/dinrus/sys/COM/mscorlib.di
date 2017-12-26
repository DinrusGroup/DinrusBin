// mscorlib.dll
// Version 2.4

/*[ууид("bed7f4ea-1a96-11d2-8f08-00a0c9a6186d")]*/
module sys.COM.mscorlib;

/*[importlib("stdole2.tlb")]*/

package import dinrus,tpl.com, sys.WinStructs, sys.WinIfaces;

version = ОМО;
// Enums


alias СравнениеТекста StringComparison;
enum СравнениеТекста
 {
  ТекущаяКультура				 = 0x00000000,
  ТекущаяКультураИгнорРег 		= 0x00000001,
  ИнвариантКультура				= 0x00000002,
  ИнвариантКультураИгнорРег		= 0x00000003,
  Порядковый 					= 0x00000004,
  ПорядковыйИгнорРег 			= 0x00000005,

}

alias ВидДатыВремени DateTimeKind ;
enum ВидДатыВремени
{
  Нет 		= 0x00000000,
  Утс 				= 0x00000001,
  Локальный 		= 0x00000002,
}

alias ОпцииИнициализацииМенеджераДоменаПрил AppDomainManagerInitializationOptions ;
enum ОпцииИнициализацииМенеджераДоменаПрил
 {
  Нет							= 0x00000000,
  РегистрироватьПоХосту 		= 0x00000001,
}

alias ОптимизацияЗагрузчика LoaderOptimization ;
enum ОптимизацияЗагрузчика
 {
  Нет				= 0x00000000,
  ОдинДомен			= 0x00000001,
  МногоДомен		= 0x00000002,
  МногоДоменХост	= 0x00000003,
  МаскаДомена		= 0x00000003,
  ЗапретПодвязок	= 0x00000004,
}

alias ЦелиАтрибутов AttributeTargets ;
enum ЦелиАтрибутов
 {

  Сборка		= 0x00000001,
  Модуль		= 0x00000002,
  Класс			= 0x00000004,
  Структура		= 0x00000008,
  Перечень		= 0x00000010,
  Конструктор	=  0x00000020,
  Метод			= 0x00000040,
  Свойство		= 0x00000080,
  Поле			= 0x00000100,
  Событие		= 0x00000200,
  Интерфейс		= 0x00000400,
  Параметр		= 0x00000800,
  Делегат		= 0x00001000,
  ЗначениеВозврата	= 0x00002000,
  ГенерныйПараметр	= 0x00004000,
  Все				= 0x00007FFF,
}

alias ДеньНедели DayOfWeek ;
enum ДеньНедели
 {
  Воскресенье			= 0x00000000,
  Понедельник			= 0x00000001,
  Вторник				= 0x00000002,
  Среда					= 0x00000003,
  Четверг				= 0x00000004,
  Пятница				= 0x00000005,
  Суббота				= 0x00000006,

}

alias ЦельПеременнойСреды EnvironmentVariableTarget ;
enum ЦельПеременнойСреды
 {
  Процесс			= 0x00000000,
  Пользователь		= 0x00000001,
  Машина			= 0x00000002,
}

alias СпецПапка SpecialFolder ;
enum СпецПапка
 {
  ДанныеПриложений			= 0x0000001A,
  ОбщиеДанныеПриложений		 = 0x00000023,
  ЛокальныеДанныеПриложений	 = 0x0000001C,
  Куки						 = 0x00000021,
  РабочийСтол				 = 0x00000000,
  Избранное					 = 0x00000006,
  История					 = 0x00000022,
  КэшИнтернета				 = 0x00000020,
  Программы					 = 0x00000002,
  МойКомпьютер				 = 0x00000011,
  МояМузыка					 = 0x0000000D,
  МоиКартинки				 = 0x00000027,
  Недавнее					 = 0x00000008,
  ОтправитьК				 = 0x00000009,
  МенюСтарт					 = 0x0000000B,
  Пуск						 = 0x00000007,
  Система					 = 0x00000025,
  Шаблоны					 = 0x00000015,
  ПапкаРабочегоСтола		 = 0x00000010,
  Личное					 = 0x00000005,
  МоиДокументы				 = 0x00000005,
  ПрограммныеФайлы			 = 0x00000026,
  ОбщиеПрограммныеФайлы		 = 0x0000002B,
  СредстваАдмина			 = 0x00000030,
  ЗаписьДиска				 = 0x0000003B,
  ОбщиеСредстваАдмина		 = 0x0000002F,
  ОбщиеДокументы			 = 0x0000002E,
  ОбщаяМузыка				 = 0x00000035,
 /* CommonOemLinks = 0x0000003A,
  CommonPictures = 0x00000036,
  CommonStartMenu = 0x00000016,
  CommonPrograms = 0x00000017,
  CommonStartup = 0x00000018,
  CommonDesktopDirectory = 0x00000019,
  CommonTemplates = 0x0000002D,
  CommonVideos = 0x00000037,*/
  Шрифты					 = 0x00000014,
  МоёВидео					 = 0x0000000E,
  /*NetworkShortcuts = 0x00000013,
  PrinterShortcuts = 0x0000001B,
  UserProfile = 0x00000028,
  CommonProgramFilesX86 = 0x0000002C,
  ProgramFilesX86 = 0x0000002A,
  Resources = 0x00000038,
  LocalizedResources = 0x00000039,
  SystemX86 = 0x00000029,
  Windows = 0x00000024,*/
}

alias ОкруглениеДоСреднего MidpointRounding ;
enum ОкруглениеДоСреднего
 {
   ДоЧётного = 0x00000000,
  ОтНуля = 0x00000001,
}

alias ИдПлатформы PlatformID ;
enum ИдПлатформы {

  Win32S = 0x00000000,
  Win32Windows = 0x00000001,
  Win32NT = 0x00000002,
  WinCE = 0x00000003,
  Unix = 0x00000004,
  Xbox = 0x00000005,
  MacOSX = 0x00000006,
}

alias КодТипа TypeCode ;
enum КодТипа
 {
  Пустой			 = 0x00000000,
  Объект			 = 0x00000001,
  НульБД			 = 0x00000002,
  Булев				 = 0x00000003,
  Символ			 = 0x00000004,
  СБайт				 = 0x00000005,
  Байт				 = 0x00000006,
  Цел16				 = 0x00000007,
  БЦел16			 = 0x00000008,
  Цел32				 = 0x00000009,
  БЦел32			 = 0x0000000A,
  Цел64				 = 0x0000000B,
  БЦел64			 = 0x0000000C,
  Единый			 = 0x0000000D,
  Двойной			 = 0x0000000E,
  Десятичный		 = 0x0000000F,
  ДатаВремя			 = 0x00000010,
  Текст				 = 0x00000012,
}
alias ПриоритетНити ThreadPriority ;
enum ПриоритетНити
 {
  Низкий					 = 0x00000000,
  НижеНормы					 = 0x00000001,
  Норма						 = 0x00000002,
  ВышеНормы					 = 0x00000003,
  Высокий					 = 0x00000004,
}

alias СостояниеНити ThreadState ;
enum СостояниеНити
 {
  Выполняется				 = 0x00000000,
  ЗапросОстановки			 = 0x00000001,
  ЗапросПриостановки		 = 0x00000002,
  Фон						 = 0x00000004,
  Непущена					 = 0x00000008,
  Остановлена				 = 0x00000010,
  ЖдатьСонОбединить			 = 0x00000020,
  Приостановлена			 = 0x00000040,
  ЗапросАборта				 = 0x00000080,
  ВАборте					 = 0x00000100,

}

alias СостояниеКупе ApartmentState ;
enum СостояниеКупе
 {
  ОНК = 0x00000000,
  МНК = 0x00000001,
  Неизвестно = 0x00000002,
}

alias РежимыОтладки DebuggingModes ;
enum РежимыОтладки
{
  Нет = 0x00000000,
  Дефолт = 0x00000001,
  ОтключитьОптимизации = 0x00000100,
  ИгнорироватьТочкиПоследовательностиСохраненияСимволов = 0x00000002,
  ВключитьРедактироватьИПродолжить = 0x00000004,

}

alias ВидимоеСостояниеОтладчика DebuggerBrowsableState ;
enum ВидимоеСостояниеОтладчика
 {
  Никогда = 0x00000000,
  Развернутое = 0x00000002,
  СкрытоеВКорне = 0x00000003,
}

alias ВидАдресаСим SymAddressKind ;
enum ВидАдресаСим
 {
  СмещениеПЯ = 0x00000001, //ПЯ - Промежуточный Язык (IL)
  ИсконныйОВА = 0x00000002,//ОВА - Относительный Виртуальный Адрес (RVA)
  ИсконныйРегистр = 0x00000003,
  ОтноситИсконногоРегистра = 0x00000004,
  ИсконноеСмещение = 0x00000005,
  РегистрИсконногоРегистра = 0x00000006,
  СтекИсконногоРегистра = 0x00000007,
  РегистрИсконногоСтека = 0x00000008,
  ПолеБит = 0x00000009,
  СмещениеИсконнойСекции = 0x0000000A,
}

alias ФлагиИмениСборки AssemblyNameFlags ;
enum ФлагиИмениСборки
 {
  Нет = 0x00000000,
  ПубличныйКлюч = 0x00000001,
  ВклОптимизаторКомпиляцииДжИТ = 0x00004000,
  ВклТрекингКомпиляцииДжИТ = 0x00008000,
  Перенацеливаемый = 0x00000100,
}

alias АрхитектураПроцессора ProcessorArchitecture ;
enum АрхитектураПроцессора
 {
  Нет = 0x00000000,
  МСПЯ = 0x00000001,//MSIL
  X86 = 0x00000002,
  IA64 = 0x00000003,
  Amd64 = 0x00000004,
}

alias ФлагиПодвязки BindingFlags ;
enum ФлагиПодвязки
 {
  Дефолт = 0x00000000,
  ИгнорироватьРегистр = 0x00000001,
  ТолькоДекларированные = 0x00000002,
  Экземпляр = 0x00000004,
  Статическая = 0x00000008,
  Публичная = 0x00000010,
  НеПубличная = 0x00000020,
  //FlattenHierarchy = 0x00000040,
  МетодВызова = 0x00000100,
  СоздатьЭкземпляр = 0x00000200,
  ДатьПоле = 0x00000400,
  УстановитьПоле = 0x00000800,
  ДатьСвойство = 0x00001000,
  УстановитьСвойство = 0x00002000,
 // PutDispProperty = 0x00004000,
 // PutRefDispProperty = 0x00008000,
  ТочнаяПодвязка = 0x00010000,
  //SuppressChangeType = 0x00020000,
  ПодвязкаНеобязатПарам = 0x00040000,
  ИгнорироватьВозврат = 0x01000000,
}

alias КонвенцииВызова CallingConventions ;
enum КонвенцииВызова
 {
  Стандарт = 0x00000001,
  ВарАрги = 0x00000002,
  Любая = 0x00000003,
  С_Зис = 0x00000020,
  С_ЯвнымЗис = 0x00000040,
}

alias  АтрибутыСобытия EventAttributes;
enum АтрибутыСобытия
 {

  Нет = 0x00000000,
  ОсобоеИмя = 0x00000200,
  РезервированнаяМаска = 0x00000400,
  ОсобоеИмяРТ = 0x00000400,
}

alias АтрибутыПоля FieldAttributes ;
enum АтрибутыПоля
 {
  МаскаДоступаКПолю = 0x00000007,
  ПриватныйМасштаб = 0x00000000,
  Приватное = 0x00000001,
 // FamANDAssem = 0x00000002,
  Сборка = 0x00000003,
  Семейство = 0x00000004,
  //FamORAssem = 0x00000005,
  Публичное = 0x00000006,
  Статическое = 0x00000010,
  ТолькоИниц = 0x00000020,
  Литеральное = 0x00000040,
  НеСериализуемое = 0x00000080,
  ОсобоеИмя = 0x00000200,
  //PinvokeImpl = 0x00002000,
  РезервированнаяМаска = 0x00009500,
  ОсобоеИмяРТ = 0x00000400,
  //HasFieldMarshal = 0x00001000,
  //HasDefault = 0x00008000,
  //HasFieldRVA = 0x00000100,
}

alias РазмещениеРесурса ResourceLocation ;
enum РазмещениеРесурса
 {
  Внедренное = 0x00000001,
  ВДругойСборке = 0x00000002,
  ВФайлеМанифеста = 0x00000004,
}

alias ТипЧлена MemberTypes ;
enum ТипЧлена
{
  Конструктор = 0x00000001,
  Событие = 0x00000002,
  Поле = 0x00000004,
  Метод = 0x00000008,
  Свойство = 0x00000010,
  ИнфОТипе = 0x00000020,
  Частное = 0x00000040,
  ГнездовойТип = 0x00000080,
  Все = 0x000000BF,
}

alias АтрибутыМетода MethodAttributes ;
enum АтрибутыМетода
 {
   МаскаДоступаКЧлену = 0x00000007,
  ПриватныйМасштаб = 0x00000000,
  Приватный = 0x00000001,
 // FamANDAssem = 0x00000002,
  Сборка = 0x00000003,
  Семейство = 0x00000004,
  //FamORAssem = 0x00000005,
  Публичный = 0x00000006,
  Статический = 0x00000010,
  Финальный = 0x00000020,
  Виртуальный = 0x00000040,
  СкрытьПоСиг = 0x00000080,
  ПроверкаДоступаПриПерезаписи = 0x00000200,
  МаскаРаскладкиВТабл = 0x00000100,
  ПереиспользоватьСлот = 0x00000000,
  НовыйСлот = 0x00000100,
  Абстрактный = 0x00000400,
  ОсобоеИмя = 0x00000800,
  РеализПВызова = 0x00002000,
  НеобрабатываемыйЭкспорт = 0x00000008,
  ОсобоеИмяРТ = 0x00001000,
  РезервированнаяМаска = 0x0000D000,
  С_Безопасностью = 0x00004000,
  ТребуетОбъектБезоп = 0x00008000,
}

enum MethodImplAttributes {
  CodeTypeMask = 0x00000003,
  IL = 0x00000000,
  Native = 0x00000001,
  OPTIL = 0x00000002,
  Runtime = 0x00000003,
  ManagedMask = 0x00000004,
  Unmanaged = 0x00000004,
  Managed = 0x00000000,
  ForwardRef = 0x00000010,
  PreserveSig = 0x00000080,
  InternalCall = 0x00001000,
  Synchronized = 0x00000020,
  NoInlining = 0x00000008,
  NoOptimization = 0x00000040,
  MaxMethodImplVal = 0x0000FFFF,
}


alias ВидыПортируемыхИсполнимых PortableExecutableKinds ;
enum ВидыПортируемыхИсполнимых
 {
  ОбразНепортируемогоИсп = 0x00000000,
  ТолькоПЯ = 0x00000001,
  Требует32Бит = 0x00000002,
  ПИ32Плюс = 0x00000004,//ПИ - Портируемый Исполнимый (PE)
  Неуправляемый32Бит = 0x00000008,
}

alias МашинаСФайломОбразом ImageFileMachine ;
enum МашинаСФайломОбразом
 {
  I386 = 0x0000014C,
  IA64 = 0x00000200,
  AMD64 = 0x00008664,
}

alias ОпцииОборотовОбработкиИскл ExceptionHandlingClauseOptions ;
enum ОпцииОборотовОбработкиИскл
 {
  Оборот = 0x00000000, //Clause
  Фильтр = 0x00000001,
  Наконец = 0x00000002,//Finally
  Сбой = 0x00000004,
}

alias АтрибутыПараметра ParameterAttributes ;
enum АтрибутыПараметра
{
  Нет = 0x00000000,
  Вхо = 0x00000001,
  Вых = 0x00000002,
  Лкид = 0x00000004,
  Возврзнач = 0x00000008,
  Опционал = 0x00000010,
  РезервированнаяМаска = 0x0000F000,
  СДефолтом = 0x00001000,
  СМаршалПолем = 0x00002000,
  Резерв3 = 0x00004000,
  Резерв4 = 0x00008000,

}

enum PropertyAttributes {
  None = 0x00000000,
  SpecialName = 0x00000200,
  ReservedMask = 0x0000F400,
  RTSpecialName = 0x00000400,
  HasDefault = 0x00001000,
  Reserved2 = 0x00002000,
  Reserved3 = 0x00004000,
  Reserved4 = 0x00008000,
}

enum ResourceAttributes {
  Public = 0x00000001,
  Private = 0x00000002,
}

enum TypeAttributes {
  VisibilityMask = 0x00000007,
  NotPublic = 0x00000000,
  Public = 0x00000001,
  NestedPublic = 0x00000002,
  NestedPrivate = 0x00000003,
  NestedFamily = 0x00000004,
  NestedAssembly = 0x00000005,
  NestedFamANDAssem = 0x00000006,
  NestedFamORAssem = 0x00000007,
  LayoutMask = 0x00000018,
  AutoLayout = 0x00000000,
  SequentialLayout = 0x00000008,
  ExplicitLayout = 0x00000010,
  ClassSemanticsMask = 0x00000020,
  Class = 0x00000000,
  Interface = 0x00000020,
  Abstract = 0x00000080,
  Sealed = 0x00000100,
  SpecialName = 0x00000400,
  Import = 0x00001000,
  Serializable = 0x00002000,
  StringFormatMask = 0x00030000,
  AnsiClass = 0x00000000,
  UnicodeClass = 0x00010000,
  AutoClass = 0x00020000,
  CustomFormatClass = 0x00030000,
  CustomFormatMask = 0x00C00000,
  BeforeFieldInit = 0x00100000,
  ReservedMask = 0x00040800,
  RTSpecialName = 0x00000800,
  HasSecurity = 0x00040000,
}

enum StreamingContextStates {
  CrossProcess = 0x00000001,
  CrossMachine = 0x00000002,
  File = 0x00000004,
  Persistence = 0x00000008,
  Remoting = 0x00000010,
  Other = 0x00000020,
  Clone = 0x00000040,
  CrossAppDomain = 0x00000080,
  All = 0x000000FF,
}

enum CalendarAlgorithmType {
  Unknown = 0x00000000,
  SolarCalendar = 0x00000001,
  LunarCalendar = 0x00000002,
  LunisolarCalendar = 0x00000003,
}

enum CalendarWeekRule {
  FirstDay = 0x00000000,
  FirstFullWeek = 0x00000001,
  FirstFourDayWeek = 0x00000002,
}

enum CompareOptions {
  None = 0x00000000,
  IgnoreCase = 0x00000001,
  IgnoreNonSpace = 0x00000002,
  IgnoreSymbols = 0x00000004,
  IgnoreKanaType = 0x00000008,
  IgnoreWidth = 0x00000010,
  OrdinalIgnoreCase = 0x10000000,
  StringSort = 0x20000000,
  Ordinal = 0x40000000,
}

enum CultureTypes {
  NeutralCultures = 0x00000001,
  SpecificCultures = 0x00000002,
  InstalledWin32Cultures = 0x00000004,
  AllCultures = 0x00000007,
  UserCustomCulture = 0x00000008,
  ReplacementCultures = 0x00000010,
  WindowsOnlyCultures = 0x00000020,
  FrameworkCultures = 0x00000040,
}

enum DateTimeStyles {
  None = 0x00000000,
  AllowLeadingWhite = 0x00000001,
  AllowTrailingWhite = 0x00000002,
  AllowInnerWhite = 0x00000004,
  AllowWhiteSpaces = 0x00000007,
  NoCurrentDateDefault = 0x00000008,
  AdjustToUniversal = 0x00000010,
  AssumeLocal = 0x00000020,
  AssumeUniversal = 0x00000040,
  RoundTripKind = 0x00000080,
}

enum DigitShapes {
  Context = 0x00000000,
  None = 0x00000001,
  NativeNational = 0x00000002,
}

enum GregorianCalendarTypes {
  Localized = 0x00000001,
  USEnglish = 0x00000002,
  MiddleEastFrench = 0x00000009,
  Arabic = 0x0000000A,
  TransliteratedEnglish = 0x0000000B,
  TransliteratedFrench = 0x0000000C,
}

enum NumberStyles {
  None = 0x00000000,
  AllowLeadingWhite = 0x00000001,
  AllowTrailingWhite = 0x00000002,
  AllowLeadingSign = 0x00000004,
  AllowTrailingSign = 0x00000008,
  AllowParentheses = 0x00000010,
  AllowDecimalPoint = 0x00000020,
  AllowThousands = 0x00000040,
  AllowExponent = 0x00000080,
  AllowCurrencySymbol = 0x00000100,
  AllowHexSpecifier = 0x00000200,
  Integer = 0x00000007,
  HexNumber = 0x00000203,
  Number = 0x0000006F,
  Float = 0x000000A7,
  Currency = 0x0000017F,
  Any = 0x000001FF,
}

enum UnicodeCategory {
  UppercaseLetter = 0x00000000,
  LowercaseLetter = 0x00000001,
  TitlecaseLetter = 0x00000002,
  ModifierLetter = 0x00000003,
  OtherLetter = 0x00000004,
  NonSpacingMark = 0x00000005,
  SpacingCombiningMark = 0x00000006,
  EnclosingMark = 0x00000007,
  DecimalDigitNumber = 0x00000008,
  LetterNumber = 0x00000009,
  OtherNumber = 0x0000000A,
  SpaceSeparator = 0x0000000B,
  LineSeparator = 0x0000000C,
  ParagraphSeparator = 0x0000000D,
  Control = 0x0000000E,
  Format = 0x0000000F,
  Surrogate = 0x00000010,
  PrivateUse = 0x00000011,
  ConnectorPunctuation = 0x00000012,
  DashPunctuation = 0x00000013,
  OpenPunctuation = 0x00000014,
  ClosePunctuation = 0x00000015,
  InitialQuotePunctuation = 0x00000016,
  FinalQuotePunctuation = 0x00000017,
  OtherPunctuation = 0x00000018,
  MathSymbol = 0x00000019,
  CurrencySymbol = 0x0000001A,
  ModifierSymbol = 0x0000001B,
  OtherSymbol = 0x0000001C,
  OtherNotAssigned = 0x0000001D,
}

enum NormalizationForm {
  FormC = 0x00000001,
  FormD = 0x00000002,
  FormKC = 0x00000005,
  FormKD = 0x00000006,
}

enum UltimateResourceFallbackLocation {
  MainAssembly = 0x00000000,
  Satellite = 0x00000001,
}

enum RegistryHive {
  ClassesRoot = 0x80000000,
  CurrentUser = 0x80000001,
  LocalMachine = 0x80000002,
  Users = 0x80000003,
  PerformanceData = 0x80000004,
  CurrentConfig = 0x80000005,
  DynData = 0x80000006,
}

enum RegistryValueKind {
  String = 0x00000001,
  ExpandString = 0x00000002,
  Binary = 0x00000003,
  DWord = 0x00000004,
  MultiString = 0x00000007,
  QWord = 0x0000000B,
  Unknown = 0x00000000,
}

enum ApplicationVersionMatch {
  MatchExactVersion = 0x00000000,
  MatchAllVersions = 0x00000001,
}

enum TrustManagerUIContext {
  Install = 0x00000000,
  Upgrade = 0x00000001,
  Run = 0x00000002,
}

enum PolicyStatementAttribute {
  Nothing = 0x00000000,
  Exclusive = 0x00000001,
  LevelFinal = 0x00000002,
  All = 0x00000003,
}

enum PrincipalPolicy {
  UnauthenticatedPrincipal = 0x00000000,
  NoPrincipal = 0x00000001,
  WindowsPrincipal = 0x00000002,
}

enum WindowsAccountType {
  Normal = 0x00000000,
  Guest = 0x00000001,
  System = 0x00000002,
  Anonymous = 0x00000003,
}

enum TokenImpersonationLevel {
  None = 0x00000000,
  Anonymous = 0x00000001,
  Identification = 0x00000002,
  Impersonation = 0x00000003,
  Delegation = 0x00000004,
}

enum TokenAccessLevels {
  AssignPrimary = 0x00000001,
  Duplicate = 0x00000002,
  Impersonate = 0x00000004,
  Query = 0x00000008,
  QuerySource = 0x00000010,
  AdjustPrivileges = 0x00000020,
  AdjustGroups = 0x00000040,
  AdjustDefault = 0x00000080,
  AdjustSessionId = 0x00000100,
  Read = 0x00020008,
  Write = 0x000200E0,
  AllAccess = 0x000F01FF,
  MaximumAllowed = 0x02000000,
}

enum WindowsBuiltInRole {
  Administrator = 0x00000220,
  User = 0x00000221,
  Guest = 0x00000222,
  PowerUser = 0x00000223,
  AccountOperator = 0x00000224,
  SystemOperator = 0x00000225,
  PrintOperator = 0x00000226,
  BackupOperator = 0x00000227,
  Replicator = 0x00000228,
}

enum ComInterfaceType {
  InterfaceIsDual = 0x00000000,
  InterfaceIsIUnknown = 0x00000001,
  InterfaceIsIDispatch = 0x00000002,
}

enum ClassInterfaceType {
  None = 0x00000000,
  AutoDispatch = 0x00000001,
  AutoDual = 0x00000002,
}

enum IDispatchImplType {
  SystemDefinedImpl = 0x00000000,
  InternalImpl = 0x00000001,
  CompatibleImpl = 0x00000002,
}

enum TypeLibTypeFlags {
  FAppObject = 0x00000001,
  FCanCreate = 0x00000002,
  FLicensed = 0x00000004,
  FPreDeclId = 0x00000008,
  FHidden = 0x00000010,
  FControl = 0x00000020,
  FDual = 0x00000040,
  FNonExtensible = 0x00000080,
  FOleAutomation = 0x00000100,
  FRestricted = 0x00000200,
  FAggregatable = 0x00000400,
  FReplaceable = 0x00000800,
  FDispatchable = 0x00001000,
  FReverseBind = 0x00002000,
}

enum TypeLibFuncFlags {
  FRestricted = 0x00000001,
  FSource = 0x00000002,
  FBindable = 0x00000004,
  FRequestEdit = 0x00000008,
  FDisplayBind = 0x00000010,
  FDefaultBind = 0x00000020,
  FHidden = 0x00000040,
  FUsesGetLastError = 0x00000080,
  FDefaultCollelem = 0x00000100,
  FUiDefault = 0x00000200,
  FNonBrowsable = 0x00000400,
  FReplaceable = 0x00000800,
  FImmediateBind = 0x00001000,
}

enum TypeLibVarFlags {
  FReadOnly = 0x00000001,
  FSource = 0x00000002,
  FBindable = 0x00000004,
  FRequestEdit = 0x00000008,
  FDisplayBind = 0x00000010,
  FDefaultBind = 0x00000020,
  FHidden = 0x00000040,
  FRestricted = 0x00000080,
  FDefaultCollelem = 0x00000100,
  FUiDefault = 0x00000200,
  FNonBrowsable = 0x00000400,
  FReplaceable = 0x00000800,
  FImmediateBind = 0x00001000,
}

enum VarEnum {
  VT_EMPTY = 0x00000000,
  VT_NULL = 0x00000001,
  VT_I2 = 0x00000002,
  VT_I4 = 0x00000003,
  VT_R4 = 0x00000004,
  VT_R8 = 0x00000005,
  VT_CY = 0x00000006,
  VT_DATE = 0x00000007,
  VT_BSTR = 0x00000008,
  VT_DISPATCH = 0x00000009,
  VT_ERROR = 0x0000000A,
  VT_BOOL = 0x0000000B,
  VT_VARIANT = 0x0000000C,
  VT_UNKNOWN = 0x0000000D,
  VT_DECIMAL = 0x0000000E,
  VT_I1 = 0x00000010,
  VT_UI1 = 0x00000011,
  VT_UI2 = 0x00000012,
  VT_UI4 = 0x00000013,
  VT_I8 = 0x00000014,
  VT_UI8 = 0x00000015,
  VT_INT = 0x00000016,
  VT_UINT = 0x00000017,
  VT_VOID = 0x00000018,
  VT_HRESULT = 0x00000019,
  VT_PTR = 0x0000001A,
  VT_SAFEARRAY = 0x0000001B,
  VT_CARRAY = 0x0000001C,
  VT_USERDEFINED = 0x0000001D,
  VT_LPSTR = 0x0000001E,
  VT_LPWSTR = 0x0000001F,
  VT_RECORD = 0x00000024,
  VT_FILETIME = 0x00000040,
  VT_BLOB = 0x00000041,
  VT_STREAM = 0x00000042,
  VT_STORAGE = 0x00000043,
  VT_STREAMED_OBJECT = 0x00000044,
  VT_STORED_OBJECT = 0x00000045,
  VT_BLOB_OBJECT = 0x00000046,
  VT_CF = 0x00000047,
  VT_CLSID = 0x00000048,
  VT_VECTOR = 0x00001000,
  VT_ARRAY = 0x00002000,
  VT_BYREF = 0x00004000,
}

enum UnmanagedType {
  Bool = 0x00000002,
  I1 = 0x00000003,
  U1 = 0x00000004,
  I2 = 0x00000005,
  U2 = 0x00000006,
  I4 = 0x00000007,
  U4 = 0x00000008,
  I8 = 0x00000009,
  U8 = 0x0000000A,
  R4 = 0x0000000B,
  R8 = 0x0000000C,
  Currency = 0x0000000F,
  BStr = 0x00000013,
  LPStr = 0x00000014,
  LPWStr = 0x00000015,
  LPTStr = 0x00000016,
  ByValTStr = 0x00000017,
  IUnknown = 0x00000019,
  IDispatch = 0x0000001A,
  Struct = 0x0000001B,
  Interface = 0x0000001C,
  SafeArray = 0x0000001D,
  ByValArray = 0x0000001E,
  SysInt = 0x0000001F,
  SysUInt = 0x00000020,
  VBByRefStr = 0x00000022,
  AnsiBStr = 0x00000023,
  TBStr = 0x00000024,
  VariantBool = 0x00000025,
  FunctionPtr = 0x00000026,
  AsAny = 0x00000028,
  LPArray = 0x0000002A,
  LPStruct = 0x0000002B,
  CustomMarshaler = 0x0000002C,
  Error = 0x0000002D,
}

enum CallingConvention {
  Winapi = 0x00000001,
  Cdecl = 0x00000002,
  StdCall = 0x00000003,
  ThisCall = 0x00000004,
  FastCall = 0x00000005,
}

enum CharSet {
  None = 0x00000001,
  Ansi = 0x00000002,
  Unicode = 0x00000003,
  Auto = 0x00000004,
}

enum GCHandleType {
  Weak = 0x00000000,
  WeakTrackResurrection = 0x00000001,
  Normal = 0x00000002,
  Pinned = 0x00000003,
}

enum LayoutKind {
  Sequential = 0x00000000,
  Explicit = 0x00000002,
  Auto = 0x00000003,
}

enum ComMemberType {
  Method = 0x00000000,
  PropGet = 0x00000001,
  PropSet = 0x00000002,
}

enum AssemblyRegistrationFlags {
  None = 0x00000000,
  SetCodeBase = 0x00000001,
}

enum TypeLibImporterFlags {
  None = 0x00000000,
  PrimaryInteropAssembly = 0x00000001,
  UnsafeInterfaces = 0x00000002,
  SafeArrayAsSystemArray = 0x00000004,
  TransformDispRetVals = 0x00000008,
  PreventClassMembers = 0x00000010,
  SerializableValueClasses = 0x00000020,
  ImportAsX86 = 0x00000100,
  ImportAsX64 = 0x00000200,
  ImportAsItanium = 0x00000400,
  ImportAsAgnostic = 0x00000800,
  ReflectionOnlyLoading = 0x00001000,
  NoDefineVersionResource = 0x00002000,
}

enum TypeLibExporterFlags {
  None = 0x00000000,
  OnlyReferenceRegistered = 0x00000001,
  CallerResolvedReferences = 0x00000002,
  OldNames = 0x00000004,
  ExportAs32Bit = 0x00000010,
  ExportAs64Bit = 0x00000020,
}

enum ImporterEventKind {
  NOTIF_TYPECONVERTED = 0x00000000,
  NOTIF_CONVERTWARNING = 0x00000001,
  ERROR_REFTOINVALIDTYPELIB = 0x00000002,
}

enum ExporterEventKind {
  NOTIF_TYPECONVERTED = 0x00000000,
  NOTIF_CONVERTWARNING = 0x00000001,
  ERROR_REFTOINVALIDASSEMBLY = 0x00000002,
}

enum SearchOption {
  TopDirectoryOnly = 0x00000000,
  AllDirectories = 0x00000001,
}

enum DriveType {
  Unknown = 0x00000000,
  NoRootDirectory = 0x00000001,
  Removable = 0x00000002,
  Fixed = 0x00000003,
  Network = 0x00000004,
  CDRom = 0x00000005,
  Ram = 0x00000006,
}

enum FileAccess {
  Read = 0x00000001,
  Write = 0x00000002,
  ReadWrite = 0x00000003,
}

enum FileMode {
  CreateNew = 0x00000001,
  Create = 0x00000002,
  Open = 0x00000003,
  OpenOrCreate = 0x00000004,
  Truncate = 0x00000005,
  Append = 0x00000006,
}

enum FileOptions {
  None = 0x00000000,
  WriteThrough = 0x80000000,
  Asynchronous = 0x40000000,
  RandomAccess = 0x10000000,
  DeleteOnClose = 0x04000000,
  SequentialScan = 0x08000000,
  Encrypted = 0x00004000,
}

enum FileShare {
  None = 0x00000000,
  Read = 0x00000001,
  Write = 0x00000002,
  ReadWrite = 0x00000003,
  Delete = 0x00000004,
  Inheritable = 0x00000010,
}

enum FileAttributes {
  ReadOnly = 0x00000001,
  Hidden = 0x00000002,
  System = 0x00000004,
  Directory = 0x00000010,
  Archive = 0x00000020,
  Device = 0x00000040,
  Normal = 0x00000080,
  Temporary = 0x00000100,
  SparseFile = 0x00000200,
  ReparsePoint = 0x00000400,
  Compressed = 0x00000800,
  Offline = 0x00001000,
  NotContentIndexed = 0x00002000,
  Encrypted = 0x00004000,
}

enum SeekOrigin {
  Begin = 0x00000000,
  Current = 0x00000001,
  End = 0x00000002,
}

enum CompilationRelaxations {
  NoStringInterning = 0x00000008,
}

enum MethodImplOptions {
  Unmanaged = 0x00000004,
  ForwardRef = 0x00000010,
  PreserveSig = 0x00000080,
  InternalCall = 0x00001000,
  Synchronized = 0x00000020,
  NoInlining = 0x00000008,
  NoOptimization = 0x00000040,
}

enum MethodCodeType {
  IL = 0x00000000,
  Native = 0x00000001,
  OPTIL = 0x00000002,
  Runtime = 0x00000003,
}

enum EnvironmentPermissionAccess {
  NoAccess = 0x00000000,
  Read = 0x00000001,
  Write = 0x00000002,
  AllAccess = 0x00000003,
}

enum FileDialogPermissionAccess {
  None = 0x00000000,
  Open = 0x00000001,
  Save = 0x00000002,
  OpenSave = 0x00000003,
}

enum FileIOPermissionAccess {
  NoAccess = 0x00000000,
  Read = 0x00000001,
  Write = 0x00000002,
  Append = 0x00000004,
  PathDiscovery = 0x00000008,
  AllAccess = 0x0000000F,
}

enum HostProtectionResource {
  None = 0x00000000,
  Synchronization = 0x00000001,
  SharedState = 0x00000002,
  ExternalProcessMgmt = 0x00000004,
  SelfAffectingProcessMgmt = 0x00000008,
  ExternalThreading = 0x00000010,
  SelfAffectingThreading = 0x00000020,
  SecurityInfrastructure = 0x00000040,
  UI = 0x00000080,
  MayLeakOnAbort = 0x00000100,
  All = 0x000001FF,
}

enum IsolatedStorageContainment {
  None = 0x00000000,
  DomainIsolationByUser = 0x00000010,
  ApplicationIsolationByUser = 0x00000015,
  AssemblyIsolationByUser = 0x00000020,
  DomainIsolationByMachine = 0x00000030,
  AssemblyIsolationByMachine = 0x00000040,
  ApplicationIsolationByMachine = 0x00000045,
  DomainIsolationByRoamingUser = 0x00000050,
  AssemblyIsolationByRoamingUser = 0x00000060,
  ApplicationIsolationByRoamingUser = 0x00000065,
  AdministerIsolatedStorageByUser = 0x00000070,
  UnrestrictedIsolatedStorage = 0x000000F0,
}

enum PermissionState {
  Unrestricted = 0x00000001,
  None = 0x00000000,
}

enum SecurityAction {
  Demand = 0x00000002,
  Assert = 0x00000003,
  Deny = 0x00000004,
  PermitOnly = 0x00000005,
  LinkDemand = 0x00000006,
  InheritanceDemand = 0x00000007,
  RequestMinimum = 0x00000008,
  RequestOptional = 0x00000009,
  RequestRefuse = 0x0000000A,
}

enum ReflectionPermissionFlag {
  NoFlags = 0x00000000,
  TypeInformation = 0x00000001,
  MemberAccess = 0x00000002,
  ReflectionEmit = 0x00000004,
  AllFlags = 0x00000007,
}

enum SecurityPermissionFlag {
  NoFlags = 0x00000000,
  Assertion = 0x00000001,
  UnmanagedCode = 0x00000002,
  SkipVerification = 0x00000004,
  Execution = 0x00000008,
  ControlThread = 0x00000010,
  ControlEvidence = 0x00000020,
  ControlPolicy = 0x00000040,
  SerializationFormatter = 0x00000080,
  ControlDomainPolicy = 0x00000100,
  ControlPrincipal = 0x00000200,
  ControlAppDomain = 0x00000400,
  RemotingConfiguration = 0x00000800,
  Infrastructure = 0x00001000,
  BindingRedirects = 0x00002000,
  AllFlags = 0x00003FFF,
}

enum UIPermissionWindow {
  NoWindows = 0x00000000,
  SafeSubWindows = 0x00000001,
  SafeTopLevelWindows = 0x00000002,
  AllWindows = 0x00000003,
}

enum UIPermissionClipboard {
  NoClipboard = 0x00000000,
  OwnClipboard = 0x00000001,
  AllClipboard = 0x00000002,
}

enum KeyContainerPermissionFlags {
  NoFlags = 0x00000000,
  Create = 0x00000001,
  Open = 0x00000002,
  Delete = 0x00000004,
  Import = 0x00000010,
  Export = 0x00000020,
  Sign = 0x00000100,
  Decrypt = 0x00000200,
  ViewAcl = 0x00001000,
  ChangeAcl = 0x00002000,
  AllFlags = 0x00003337,
}

enum RegistryPermissionAccess {
  NoAccess = 0x00000000,
  Read = 0x00000001,
  Write = 0x00000002,
  Create = 0x00000004,
  AllAccess = 0x00000007,
}

enum HostSecurityManagerOptions {
  None = 0x00000000,
  HostAppDomainEvidence = 0x00000001,
  HostPolicyLevel = 0x00000002,
  HostAssemblyEvidence = 0x00000004,
  HostDetermineApplicationTrust = 0x00000008,
  HostResolvePolicy = 0x00000010,
  AllFlags = 0x0000001F,
}

enum PolicyLevelType {
  User = 0x00000000,
  Machine = 0x00000001,
  Enterprise = 0x00000002,
  AppDomain = 0x00000003,
}

enum SecurityZone {
  MyComputer = 0x00000000,
  Intranet = 0x00000001,
  Trusted = 0x00000002,
  Internet = 0x00000003,
  Untrusted = 0x00000004,
  NoZone = 0xFFFFFFFF,
}

enum WellKnownObjectMode {
  Singleton = 0x00000001,
  SingleCall = 0x00000002,
}

enum ActivatorLevel {
  Construction = 0x00000004,
  Context = 0x00000008,
  AppDomain = 0x0000000C,
  Process = 0x00000010,
  Machine = 0x00000014,
}

enum ServerProcessing {
  Complete = 0x00000000,
  OneWay = 0x00000001,
  Async = 0x00000002,
}

enum LeaseState {
  Null = 0x00000000,
  Initial = 0x00000001,
  Active = 0x00000002,
  Renewing = 0x00000003,
  Expired = 0x00000004,
}

enum SoapOption {
  None = 0x00000000,
  AlwaysIncludeTypes = 0x00000001,
  XsdString = 0x00000002,
  EmbedAll = 0x00000004,
  Option1 = 0x00000008,
  Option2 = 0x00000010,
}

enum XmlFieldOrderOption {
  All = 0x00000000,
  Sequence = 0x00000001,
  Choice = 0x00000002,
}

enum CustomErrorsModes {
  On = 0x00000000,
  Off = 0x00000001,
  RemoteOnly = 0x00000002,
}

enum IsolatedStorageScope {
  None = 0x00000000,
  User = 0x00000001,
  Domain = 0x00000002,
  Assembly = 0x00000004,
  Roaming = 0x00000008,
  Machine = 0x00000010,
  Application = 0x00000020,
}

enum FormatterTypeStyle {
  TypesWhenNeeded = 0x00000000,
  TypesAlways = 0x00000001,
  XsdString = 0x00000002,
}

enum FormatterAssemblyStyle {
  Simple = 0x00000000,
  Full = 0x00000001,
}

enum TypeFilterLevel {
  Low = 0x00000002,
  Full = 0x00000003,
}

enum AssemblyBuilderAccess {
  Run = 0x00000001,
  Save = 0x00000002,
  RunAndSave = 0x00000003,
  ReflectionOnly = 0x00000006,
  RunAndCollect = 0x00000009,
}

enum PEFileKinds {
  Dll = 0x00000001,
  ConsoleApplication = 0x00000002,
  WindowApplication = 0x00000003,
}

enum OpCodeType {
  Annotation = 0x00000000,
  Macro = 0x00000001,
  Nternal = 0x00000002,
  Objmodel = 0x00000003,
  Prefix = 0x00000004,
  Primitive = 0x00000005,
}

enum StackBehaviour {
  Pop0 = 0x00000000,
  Pop1 = 0x00000001,
  Pop1_pop1 = 0x00000002,
  Popi = 0x00000003,
  Popi_pop1 = 0x00000004,
  Popi_popi = 0x00000005,
  Popi_popi8 = 0x00000006,
  Popi_popi_popi = 0x00000007,
  Popi_popr4 = 0x00000008,
  Popi_popr8 = 0x00000009,
  Popref = 0x0000000A,
  Popref_pop1 = 0x0000000B,
  Popref_popi = 0x0000000C,
  Popref_popi_popi = 0x0000000D,
  Popref_popi_popi8 = 0x0000000E,
  Popref_popi_popr4 = 0x0000000F,
  Popref_popi_popr8 = 0x00000010,
  Popref_popi_popref = 0x00000011,
  Push0 = 0x00000012,
  Push1 = 0x00000013,
  Push1_push1 = 0x00000014,
  Pushi = 0x00000015,
  Pushi8 = 0x00000016,
  Pushr4 = 0x00000017,
  Pushr8 = 0x00000018,
  Pushref = 0x00000019,
  Varpop = 0x0000001A,
  Varpush = 0x0000001B,
  Popref_popi_pop1 = 0x0000001C,
}

enum OperandType {
  InlineBrTarget = 0x00000000,
  InlineField = 0x00000001,
  InlineI = 0x00000002,
  InlineI8 = 0x00000003,
  InlineMethod = 0x00000004,
  InlineNone = 0x00000005,
  InlinePhi = 0x00000006,
  InlineR = 0x00000007,
  InlineSig = 0x00000009,
  InlineString = 0x0000000A,
  InlineSwitch = 0x0000000B,
  InlineTok = 0x0000000C,
  InlineType = 0x0000000D,
  InlineVar = 0x0000000E,
  ShortInlineBrTarget = 0x0000000F,
  ShortInlineI = 0x00000010,
  ShortInlineR = 0x00000011,
  ShortInlineVar = 0x00000012,
}

enum FlowControl {
  Branch = 0x00000000,
  Break = 0x00000001,
  Call = 0x00000002,
  Cond_Branch = 0x00000003,
  Meta = 0x00000004,
  Next = 0x00000005,
  Phi = 0x00000006,
  Return = 0x00000007,
  Throw = 0x00000008,
}

enum PackingSize {
  Unspecified = 0x00000000,
  Size1 = 0x00000001,
  Size2 = 0x00000002,
  Size4 = 0x00000004,
  Size8 = 0x00000008,
  Size16 = 0x00000010,
  Size32 = 0x00000020,
  Size64 = 0x00000040,
  Size128 = 0x00000080,
}

enum AssemblyHashAlgorithm {
  None = 0x00000000,
  MD5 = 0x00008003,
  SHA1 = 0x00008004,
}

enum AssemblyVersionCompatibility {
  SameMachine = 0x00000001,
  SameProcess = 0x00000002,
  SameDomain = 0x00000003,
}

enum CipherMode {
  CBC = 0x00000001,
  ECB = 0x00000002,
  OFB = 0x00000003,
  CFB = 0x00000004,
  CTS = 0x00000005,
}

enum PaddingMode {
  None = 0x00000001,
  PKCS7 = 0x00000002,
  Zeros = 0x00000003,
  ANSIX923 = 0x00000004,
  ISO10126 = 0x00000005,
}

enum FromBase64TransformMode {
  IgnoreWhiteSpaces = 0x00000000,
  DoNotIgnoreWhiteSpaces = 0x00000001,
}

enum CspProviderFlags {
  NoFlags = 0x00000000,
  UseMachineKeyStore = 0x00000001,
  UseDefaultKeyContainer = 0x00000002,
  UseNonExportableKey = 0x00000004,
  UseExistingKey = 0x00000008,
  UseArchivableKey = 0x00000010,
  UseUserProtectedKey = 0x00000020,
  NoPrompt = 0x00000040,
  CreateEphemeralKey = 0x00000080,
}

enum CryptoStreamMode {
  Read = 0x00000000,
  Write = 0x00000001,
}

enum KeyNumber {
  Exchange = 0x00000001,
  Signature = 0x00000002,
}

enum X509ContentType {
  Unknown = 0x00000000,
  Cert = 0x00000001,
  SerializedCert = 0x00000002,
  Pfx = 0x00000003,
  Pkcs12 = 0x00000003,
  SerializedStore = 0x00000004,
  Pkcs7 = 0x00000005,
  Authenticode = 0x00000006,
}

enum X509KeyStorageFlags {
  DefaultKeySet = 0x00000000,
  UserKeySet = 0x00000001,
  MachineKeySet = 0x00000002,
  Exportable = 0x00000004,
  UserProtected = 0x00000008,
  PersistKeySet = 0x00000010,
}
// Structs

struct Boolean {
  mixin(ууид("c3008e12-9b16-36ec-b731-73257f25be7a"));
  int m_value;
}

struct Byte {
  mixin(ууид("9b957340-adba-3234-91ea-46a5c9bff530"));
  ubyte m_value;
}

struct Char {
  mixin(ууид("6ee96102-3657-3d66-867a-26b63aaaaf78"));
  ubyte m_value;
}

struct Decimal {
  mixin(ууид("6fb370d8-4f72-3ac1-9a32-3875f336ecb5"));
  int flags;
  int hi;
  int lo;
  int mid;
}

struct Double {
  mixin(ууид("0f4f147f-4369-3388-8e4b-71e20c96f9ad"));
  double m_value;
}

struct Guid {
  mixin(ууид("9c5923e9-de52-33ea-88de-7ebc8633b9cc"));
  int _a;
  short _b;
  short _c;
  ubyte _d;
  ubyte _e;
  ubyte _f;
  ubyte _g;
  ubyte _h;
  ubyte _i;
  ubyte _j;
  ubyte _k;
}

struct Int16 {
  mixin(ууид("206daf34-5ba5-3504-8a19-d57699561886"));
  short m_value;
}

struct Int32 {
  mixin(ууид("a310fadd-7c33-377c-9d6b-599b0317d7f2"));
  int m_value;
}

struct Int64 {
  mixin(ууид("ad1cecf5-5fad-3ecf-ad89-2febd6521fa9"));
  long m_value;
}

struct IntPtr {
  mixin(ууид("a1cb710c-8d50-3181-bb38-65ce2e98f9a6"));
  void* m_value;
}

struct RuntimeArgumentHandle {
  mixin(ууид("3613a9b6-c23b-3b54-ae02-6ec764d69e70"));
  int m_ptr;
}

struct RuntimeTypeHandle {
  mixin(ууид("78c18a10-c00e-3c09-b000-411c38900c2c"));
  IUnknown m_type;
}

struct RuntimeMethodHandle {
  mixin(ууид("f8fc5d7c-8215-3e65-befb-11e8172606fe"));
  IUnknown m_value;
}

struct RuntimeFieldHandle {
  mixin(ууид("27b33bd9-e6f7-3148-911d-f67340a5353f"));
  IUnknown m_ptr;
}

struct ModuleHandle {
  mixin(ууид("8531f85a-746b-3db5-a45f-9bac4bd02d8b"));
  IUnknown m_ptr;
}

struct SByte {
  mixin(ууид("ca2bcdb4-3a7e-33e8-80ed-d32475adef33"));
  byte m_value;
}

struct Single {
  mixin(ууид("23d4a35b-c997-3401-8372-736025b17744"));
  float m_value;
}

struct TimeSpan {
  mixin(ууид("94942670-4acf-3572-92d1-0916cd777e00"));
  long _ticks;
}

struct TypedReference {
  mixin(ууид("06ad02b5-c5a4-3eec-b7ba-b0af7860d36a"));
  int value;
  int Type;
}

struct UInt16 {
  mixin(ууид("0f0928b7-11dd-31dd-a0d5-bb008ae887bf"));
  ushort m_value;
}

struct UInt32 {
  mixin(ууид("4f854e40-af6d-3d30-860a-e9722c85e9a3"));
  uint m_value;
}

struct UInt64 {
  mixin(ууид("62ad7d6b-52cc-3ed4-a20d-1a32ef6bf1da"));
  ulong m_value;
}

struct UIntPtr {
  mixin(ууид("4f93b8dd-5396-3b65-b16a-11fbc8812a71"));
  void* m_value;
}

struct Void {
  mixin(ууид("ca5c1c2b-61f8-3fc4-b66b-17163a3066a5"));
}

struct LockCookie {
  mixin(ууид("ba0e4cf7-a429-3fe8-abab-183387d05852"));
  int _dwFlags;
  int _dwWriterSeqNum;
  int _wReaderAndWriterLevel;
  int _dwThreadID;
}

struct NativeOverlapped {
  mixin(ууид("a2959123-2f66-35b4-815d-37c83360809b"));
  int InternalLow;
  int InternalHigh;
  int OffsetLow;
  int OffsetHigh;
  int EventHandle;
}

struct DictionaryEntry {
  mixin(ууид("a6cceb32-ec73-3e9b-8852-02783c97d3fa"));
  IUnknown _key;
  IUnknown _value;
}

struct SymbolToken {
  mixin(ууид("709164df-d0e2-3813-a07d-f9f1e99f9a4b"));
  int m_token;
}

struct CustomAttributeNamedArgument {
  mixin(ууид("7fc47a26-aa2e-32ea-bde4-01a490842d87"));
  _MemberInfo m_memberInfo;
  CustomAttributeTypedArgument m_value;
}

struct CustomAttributeTypedArgument {
  mixin(ууид("9dc6ac40-edfa-3e34-9ad1-b7a0a9e3a40a"));
  IUnknown m_value;
  _Type m_argumentType;
}

struct InterfaceMapping {
  mixin(ууид("5f7a2664-4778-3d72-a78f-d38b6b00180d"));
  _Type TargetType;
  _Type interfaceType;
   SAFEARRAY TargetMethods;
   SAFEARRAY InterfaceMethods;
}

struct ParameterModifier {
  mixin(ууид("11d31042-14c0-3b5c-87d0-a2cd40803cb5"));
   SAFEARRAY _byRef;
}

struct SerializationEntry {
  mixin(ууид("3642e7ed-5a69-3a94-98d3-a08877a0d046"));
  _Type m_type;
  IUnknown m_value;
  wchar* m_name;
}

struct StreamingContext {
  mixin(ууид("79179aa0-e14c-35ea-a666-66be968af69f"));
  IUnknown m_additionalContext;
  StreamingContextStates m_state;
}

struct ArrayWithOffset {
  mixin(ууид("8351108f-34e3-3cc9-bf5a-c76c48060835"));
  IUnknown m_array;
  int m_offset;
  int m_count;
}

struct GCHandle {
  mixin(ууид("66e1f723-e57f-35ce-8306-3c09fb68a322"));
  int m_handle;
}

struct HandleRef {
  mixin(ууид("c71dce2b-b87f-37a9-89ed-f1145955bcd6"));
  IUnknown m_wrapper;
  int m_handle;
}

struct EventToken {
  mixin(ууид("4e8b1bb8-6a6f-3b57-8afa-0129550b07be"));
  int m_event;
}

struct FieldToken {
  mixin(ууид("24246833-61eb-329d-bddf-0daf3874062b"));
  int m_fieldTok;
  IUnknown m_class;
}

struct Label {
  mixin(ууид("a419b664-dabd-383d-a0db-991487d41e14"));
  int m_label;
}

struct MethodToken {
  mixin(ууид("0efe423a-a87e-33d9-8bf4-2d212620ee5f"));
  int m_method;
}

struct OpCode {
  mixin(ууид("a7ed05c6-fecf-3c35-ba3b-84163ac1d5e5"));
  wchar* m_stringname;
  StackBehaviour m_pop;
  StackBehaviour m_push;
  OperandType m_operand;
  OpCodeType m_type;
  int m_size;
  ubyte m_s1;
  ubyte m_s2;
  FlowControl m_ctrl;
  int m_endsUncondJmpBlk;
  int m_stackChange;
}

struct ParameterToken {
  mixin(ууид("cfb98ca9-8121-35be-af40-c176c616a16b"));
  int m_tkParameter;
}

struct PropertyToken {
  mixin(ууид("566833c7-f4a0-30ee-bd7e-44752ad570e6"));
  int m_property;
}

struct SignatureToken {
  mixin(ууид("155e1466-0e84-3f2b-b825-f6525523407c"));
  int m_signature;
  _ModuleBuilder m_moduleBuilder;
}

struct StringToken {
  mixin(ууид("8cf0278d-d0ad-307d-be63-a785432e3fdf"));
  int m_string;
}

struct TypeToken {
  mixin(ууид("048fa0c2-8ebb-3bc2-a47f-01f12a32008e"));
  int m_class;
}

struct AssemblyHash {
  mixin(ууид("42a66664-072f-3a67-a189-7d440709a77e"));
  AssemblyHashAlgorithm _Algorithm;
   SAFEARRAY _value;
}

struct DSAParameters {
  mixin(ууид("0c646f46-aa27-350d-88dd-d8c920ce6c2d"));
  SAFEARRAY P;
  SAFEARRAY Q;
  SAFEARRAY G;
  SAFEARRAY y;
  SAFEARRAY J;
  SAFEARRAY x;
  SAFEARRAY Seed;
  int Counter;
}

struct RSAParameters {
  mixin(ууид("094e9135-483d-334a-aae7-8690895ab70a"));
   SAFEARRAY Exponent;
  SAFEARRAY Modulus;
  SAFEARRAY P;
  SAFEARRAY Q;
   SAFEARRAY DP;
   SAFEARRAY DQ;
   SAFEARRAY InverseQ;
   SAFEARRAY D;
}

// Интерфейсы

interface ISerializable : IDispatch {
  mixin(ууид("d0eeaa62-3d30-3ee2-b896-a2f34dda47d8"));
  /*[id(0x60020000)]*/ int GetObjectData(_SerializationInfo info, StreamingContext Context);
}

interface _Exception : IDispatch {
  mixin(ууид("b36b5c63-42ef-38bc-a07e-0b34c98f164a"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT объ, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int get_Message(out wchar* pRetVal);
  /*[id(0x60020005)]*/ int GetBaseException(out _Exception pRetVal);
  /*[id(0x60020006)]*/ int get_StackTrace(out wchar* pRetVal);
  /*[id(0x60020007)]*/ int get_HelpLink(out wchar* pRetVal);
  /*[id(0x60020007)]*/ int put_HelpLink(wchar* pRetVal);
  /*[id(0x60020009)]*/ int get_Source(out wchar* pRetVal);
  /*[id(0x60020009)]*/ int put_Source(wchar* pRetVal);
  /*[id(0x6002000B)]*/ int GetObjectData(_SerializationInfo info, StreamingContext Context);
  /*[id(0x6002000C)]*/ int get_InnerException(out _Exception pRetVal);
  /*[id(0x6002000D)]*/ int get_TargetSite(out _MethodBase pRetVal);
}

interface IComparable : IDispatch {
  mixin(ууид("deb0e770-91fd-3cf6-9a6c-e6a3656f3965"));
  /*[id(0x60020000)]*/ int CompareTo(VARIANT объ, out int pRetVal);
}

interface IFormattable : IDispatch {
  mixin(ууид("9a604ee7-e630-3ded-9444-baae247075ab"));
  /*[id(0x60020000)]*/ int get_ToString(wchar* format, IFormatProvider formatProvider, out wchar* pRetVal);
}

interface IConvertible : IDispatch {
  mixin(ууид("805e3b62-b5e9-393d-8941-377d8bf4556b"));
  /*[id(0x60020000)]*/ int GetTypeCode(out TypeCode pRetVal);
  /*[id(0x60020001)]*/ int ToBoolean(IFormatProvider provider, out short pRetVal);
  /*[id(0x60020002)]*/ int ToChar(IFormatProvider provider, out ushort pRetVal);
  /*[id(0x60020003)]*/ int ToSByte(IFormatProvider provider, out byte pRetVal);
  /*[id(0x60020004)]*/ int ToByte(IFormatProvider provider, out ubyte pRetVal);
  /*[id(0x60020005)]*/ int ToInt16(IFormatProvider provider, out short pRetVal);
  /*[id(0x60020006)]*/ int ToUInt16(IFormatProvider provider, out ushort pRetVal);
  /*[id(0x60020007)]*/ int ToInt32(IFormatProvider provider, out int pRetVal);
  /*[id(0x60020008)]*/ int ToUInt32(IFormatProvider provider, out uint pRetVal);
  /*[id(0x60020009)]*/ int ToInt64(IFormatProvider provider, out long pRetVal);
  /*[id(0x6002000A)]*/ int ToUInt64(IFormatProvider provider, out ulong pRetVal);
  /*[id(0x6002000B)]*/ int ToSingle(IFormatProvider provider, out float pRetVal);
  /*[id(0x6002000C)]*/ int ToDouble(IFormatProvider provider, out double pRetVal);
  /*[id(0x6002000D)]*/ int ToDecimal(IFormatProvider provider, out DECIMAL pRetVal);
  /*[id(0x6002000E)]*/ int ToDateTime(IFormatProvider provider, out double pRetVal);
  /*[id(0x6002000F)]*/ int get_ToString(IFormatProvider provider, out wchar* pRetVal);
  /*[id(0x60020010)]*/ int ToType(_Type conversionType, IFormatProvider provider, out VARIANT pRetVal);
}

interface ICloneable : IDispatch {
  mixin(ууид("0cb251a7-3ab3-3b5c-a0b8-9ddf88824b85"));
  /*[id(0x60020000)]*/ int Clone(out VARIANT pRetVal);
}

interface IEnumerable : IDispatch {
  mixin(ууид("496b0abe-cdee-11d3-88e8-00902754c43a"));
  /*[id(0xFFFFFFFC)]*/ int GetEnumerator(out IEnumVARIANT pRetVal);
}

interface ICollection : IDispatch {
  mixin(ууид("de8db6f8-d101-3a92-8d1c-e72e5f10e992"));
  /*[id(0x60020000)]*/ int CopyTo(_Array Array, int index);
  /*[id(0x60020001)]*/ int get_Count(out int pRetVal);
  /*[id(0x60020002)]*/ int get_SyncRoot(out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int get_IsSynchronized(out short pRetVal);
}

interface IList : IDispatch {
  mixin(ууид("7bcfa00f-f764-3113-9140-3bbd127a96bb"));
  /*[id(0x00000000)]*/ int get_Item(int index, out VARIANT pRetVal);
  /*[id(0x00000000)]*/ int putref_Item(int index, VARIANT pRetVal);
  /*[id(0x60020002)]*/ int Add(VARIANT value, out int pRetVal);
  /*[id(0x60020003)]*/ int Contains(VARIANT value, out short pRetVal);
  /*[id(0x60020004)]*/ int Clear();
  /*[id(0x60020005)]*/ int get_IsReadOnly(out short pRetVal);
  /*[id(0x60020006)]*/ int get_IsFixedSize(out short pRetVal);
  /*[id(0x60020007)]*/ int IndexOf(VARIANT value, out int pRetVal);
  /*[id(0x60020008)]*/ int Insert(int index, VARIANT value);
  /*[id(0x60020009)]*/ int Remove(VARIANT value);
  /*[id(0x6002000A)]*/ int RemoveAt(int index);
}

interface IEnumerator : IDispatch {
  mixin(ууид("496b0abf-cdee-11d3-88e8-00902754c43a"));
  /*[id(0x60020000)]*/ int MoveNext(out short pRetVal);
  /*[id(0x60020001)]*/ int get_Current(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int Reset();
}

interface IDisposable : IDispatch {
  mixin(ууид("805d7a98-d4af-3f0f-967f-e5cf45312d2c"));
  /*[id(0x60020000)]*/ int Dispose();
}

interface IComparer : IDispatch {
  mixin(ууид("c20fd3eb-7022-3d14-8477-760fab54e50d"));
  /*[id(0x60020000)]*/ int Compare(VARIANT x, VARIANT y, out int pRetVal);
}

interface IEqualityComparer : IDispatch {
  mixin(ууид("aab7c6ea-cab0-3adb-82aa-cf32e29af238"));
  /*[id(0x60020000)]*/ int Equals(VARIANT x, VARIANT y, out short pRetVal);
  /*[id(0x60020001)]*/ int GetHashCode(VARIANT объ, out int pRetVal);
}

interface IDeserializationCallback : IDispatch {
  mixin(ууид("ab3f47e4-c227-3b05-bf9f-94649bef9888"));
  /*[id(0x60020000)]*/ int OnDeserialization(VARIANT sender);
}

interface _Activator : IUnknown {
  mixin(ууид("03973551-57a1-3900-a2b5-9083e3ff2943"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _AppDomain : IUnknown {
  mixin(ууид("05f696dc-2b29-3663-ad8b-c4389cf2a713"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int InitializeLifetimeService(out VARIANT pRetVal);
  /*[id(0x60010009)]*/ int GetLifetimeService(out VARIANT pRetVal);
  /*[id(0x6001000A)]*/ int get_Evidence(out _Evidence pRetVal);
  /*[id(0x6001000B)]*/ int add_DomainUnload(_EventHandler value);
  /*[id(0x6001000C)]*/ int remove_DomainUnload(_EventHandler value);
  /*[id(0x6001000D)]*/ int add_AssemblyLoad(_AssemblyLoadEventHandler value);
  /*[id(0x6001000E)]*/ int remove_AssemblyLoad(_AssemblyLoadEventHandler value);
  /*[id(0x6001000F)]*/ int add_ProcessExit(_EventHandler value);
  /*[id(0x60010010)]*/ int remove_ProcessExit(_EventHandler value);
  /*[id(0x60010011)]*/ int add_TypeResolve(_ResolveEventHandler value);
  /*[id(0x60010012)]*/ int remove_TypeResolve(_ResolveEventHandler value);
  /*[id(0x60010013)]*/ int add_ResourceResolve(_ResolveEventHandler value);
  /*[id(0x60010014)]*/ int remove_ResourceResolve(_ResolveEventHandler value);
  /*[id(0x60010015)]*/ int add_AssemblyResolve(_ResolveEventHandler value);
  /*[id(0x60010016)]*/ int remove_AssemblyResolve(_ResolveEventHandler value);
  /*[id(0x60010017)]*/ int add_UnhandledException(_UnhandledExceptionEventHandler value);
  /*[id(0x60010018)]*/ int remove_UnhandledException(_UnhandledExceptionEventHandler value);
  /*[id(0x60010019)]*/ int DefineDynamicAssembly(_AssemblyName name, AssemblyBuilderAccess access, out _AssemblyBuilder pRetVal);
  /*[id(0x6001001A)]*/ int DefineDynamicAssembly_2(_AssemblyName name, AssemblyBuilderAccess access, wchar* dir, out _AssemblyBuilder pRetVal);
  /*[id(0x6001001B)]*/ int DefineDynamicAssembly_3(_AssemblyName name, AssemblyBuilderAccess access, _Evidence Evidence, out _AssemblyBuilder pRetVal);
  /*[id(0x6001001C)]*/ int DefineDynamicAssembly_4(_AssemblyName name, AssemblyBuilderAccess access, _PermissionSet requiredPermissions, _PermissionSet optionalPermissions, _PermissionSet refusedPermissions, out _AssemblyBuilder pRetVal);
  /*[id(0x6001001D)]*/ int DefineDynamicAssembly_5(_AssemblyName name, AssemblyBuilderAccess access, wchar* dir, _Evidence Evidence, out _AssemblyBuilder pRetVal);
  /*[id(0x6001001E)]*/ int DefineDynamicAssembly_6(_AssemblyName name, AssemblyBuilderAccess access, wchar* dir, _PermissionSet requiredPermissions, _PermissionSet optionalPermissions, _PermissionSet refusedPermissions, out _AssemblyBuilder pRetVal);
  /*[id(0x6001001F)]*/ int DefineDynamicAssembly_7(_AssemblyName name, AssemblyBuilderAccess access, _Evidence Evidence, _PermissionSet requiredPermissions, _PermissionSet optionalPermissions, _PermissionSet refusedPermissions, out _AssemblyBuilder pRetVal);
  /*[id(0x60010020)]*/ int DefineDynamicAssembly_8(_AssemblyName name, AssemblyBuilderAccess access, wchar* dir, _Evidence Evidence, _PermissionSet requiredPermissions, _PermissionSet optionalPermissions, _PermissionSet refusedPermissions, out _AssemblyBuilder pRetVal);
  /*[id(0x60010021)]*/ int DefineDynamicAssembly_9(_AssemblyName name, AssemblyBuilderAccess access, wchar* dir, _Evidence Evidence, _PermissionSet requiredPermissions, _PermissionSet optionalPermissions, _PermissionSet refusedPermissions, short IsSynchronized, out _AssemblyBuilder pRetVal);
  /*[id(0x60010022)]*/ int CreateInstance(wchar* AssemblyName, wchar* typeName, out _ObjectHandle pRetVal);
  /*[id(0x60010023)]*/ int CreateInstanceFrom(wchar* assemblyFile, wchar* typeName, out _ObjectHandle pRetVal);
  /*[id(0x60010024)]*/ int CreateInstance_2(wchar* AssemblyName, wchar* typeName,   SAFEARRAY  activationAttributes, out _ObjectHandle pRetVal);
  /*[id(0x60010025)]*/ int CreateInstanceFrom_2(wchar* assemblyFile, wchar* typeName,   SAFEARRAY  activationAttributes, out _ObjectHandle pRetVal);
  /*[id(0x60010026)]*/ int CreateInstance_3(wchar* AssemblyName, wchar* typeName, short ignoreCase, BindingFlags bindingAttr, _Binder Binder,   SAFEARRAY  args, _CultureInfo culture,   SAFEARRAY  activationAttributes, _Evidence securityAttributes, out _ObjectHandle pRetVal);
  /*[id(0x60010027)]*/ int CreateInstanceFrom_3(wchar* assemblyFile, wchar* typeName, short ignoreCase, BindingFlags bindingAttr, _Binder Binder,   SAFEARRAY  args, _CultureInfo culture,   SAFEARRAY  activationAttributes, _Evidence securityAttributes, out _ObjectHandle pRetVal);
  /*[id(0x60010028)]*/ int Load(_AssemblyName assemblyRef, out _Assembly pRetVal);
  /*[id(0x60010029)]*/ int Load_2(wchar* assemblyString, out _Assembly pRetVal);
  /*[id(0x6001002A)]*/ int Load_3(  SAFEARRAY rawAssembly, out _Assembly pRetVal);
  /*[id(0x6001002B)]*/ int Load_4(  SAFEARRAY rawAssembly,   SAFEARRAY rawSymbolStore, out _Assembly pRetVal);
  /*[id(0x6001002C)]*/ int Load_5(  SAFEARRAY rawAssembly,   SAFEARRAY rawSymbolStore, _Evidence securityEvidence, out _Assembly pRetVal);
  /*[id(0x6001002D)]*/ int Load_6(_AssemblyName assemblyRef, _Evidence assemblySecurity, out _Assembly pRetVal);
  /*[id(0x6001002E)]*/ int Load_7(wchar* assemblyString, _Evidence assemblySecurity, out _Assembly pRetVal);
  /*[id(0x6001002F)]*/ int ExecuteAssembly(wchar* assemblyFile, _Evidence assemblySecurity, out int pRetVal);
  /*[id(0x60010030)]*/ int ExecuteAssembly_2(wchar* assemblyFile, out int pRetVal);
  /*[id(0x60010031)]*/ int ExecuteAssembly_3(wchar* assemblyFile, _Evidence assemblySecurity,   SAFEARRAY  args, out int pRetVal);
  /*[id(0x60010032)]*/ int get_FriendlyName(out wchar* pRetVal);
  /*[id(0x60010033)]*/ int get_BaseDirectory(out wchar* pRetVal);
  /*[id(0x60010034)]*/ int get_RelativeSearchPath(out wchar* pRetVal);
  /*[id(0x60010035)]*/ int get_ShadowCopyFiles(out short pRetVal);
  /*[id(0x60010036)]*/ int GetAssemblies( out  SAFEARRAY  pRetVal);
  /*[id(0x60010037)]*/ int AppendPrivatePath(wchar* Path);
  /*[id(0x60010038)]*/ int ClearPrivatePath();
  /*[id(0x60010039)]*/ int SetShadowCopyPath(wchar* s);
  /*[id(0x6001003A)]*/ int ClearShadowCopyPath();
  /*[id(0x6001003B)]*/ int SetCachePath(wchar* s);
  /*[id(0x6001003C)]*/ int SetData(wchar* name, VARIANT data);
  /*[id(0x6001003D)]*/ int GetData(wchar* name, out VARIANT pRetVal);
  /*[id(0x6001003E)]*/ int SetAppDomainPolicy(_PolicyLevel domainPolicy);
  /*[id(0x6001003F)]*/ int SetThreadPrincipal(IPrincipal principal);
  /*[id(0x60010040)]*/ int SetPrincipalPolicy(PrincipalPolicy policy);
  /*[id(0x60010041)]*/ int DoCallBack(_CrossAppDomainDelegate theDelegate);
  /*[id(0x60010042)]*/ int get_DynamicDirectory(out wchar* pRetVal);
}

interface IEvidenceFactory : IDispatch {
  mixin(ууид("35a8f3ac-fe28-360f-a0c0-9a4d50c4682a"));
  /*[id(0x60020000)]*/ int get_Evidence(out _Evidence pRetVal);
}

interface IAppDomainSetup : IUnknown {
  mixin(ууид("27fff232-a7a8-40dd-8d4a-734ad59fcd41"));
  /*[id(0x60010000)]*/ int get_ApplicationBase(out wchar* pRetVal);
  /*[id(0x60010000)]*/ int put_ApplicationBase(wchar* pRetVal);
  /*[id(0x60010002)]*/ int get_ApplicationName(out wchar* pRetVal);
  /*[id(0x60010002)]*/ int put_ApplicationName(wchar* pRetVal);
  /*[id(0x60010004)]*/ int get_CachePath(out wchar* pRetVal);
  /*[id(0x60010004)]*/ int put_CachePath(wchar* pRetVal);
  /*[id(0x60010006)]*/ int get_ConfigurationFile(out wchar* pRetVal);
  /*[id(0x60010006)]*/ int put_ConfigurationFile(wchar* pRetVal);
  /*[id(0x60010008)]*/ int get_DynamicBase(out wchar* pRetVal);
  /*[id(0x60010008)]*/ int put_DynamicBase(wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_LicenseFile(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int put_LicenseFile(wchar* pRetVal);
  /*[id(0x6001000C)]*/ int get_PrivateBinPath(out wchar* pRetVal);
  /*[id(0x6001000C)]*/ int put_PrivateBinPath(wchar* pRetVal);
  /*[id(0x6001000E)]*/ int get_PrivateBinPathProbe(out wchar* pRetVal);
  /*[id(0x6001000E)]*/ int put_PrivateBinPathProbe(wchar* pRetVal);
  /*[id(0x60010010)]*/ int get_ShadowCopyDirectories(out wchar* pRetVal);
  /*[id(0x60010010)]*/ int put_ShadowCopyDirectories(wchar* pRetVal);
  /*[id(0x60010012)]*/ int get_ShadowCopyFiles(out wchar* pRetVal);
  /*[id(0x60010012)]*/ int put_ShadowCopyFiles(wchar* pRetVal);
}

interface _Attribute : IUnknown {
  mixin(ууид("917b14d0-2d9e-38b8-92a9-381acf52f7c0"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _Thread : IUnknown {
  mixin(ууид("c281c7f1-4aa9-3517-961a-463cfed57e75"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface IObjectReference : IDispatch {
  mixin(ууид("6e70ed5f-0439-38ce-83bb-860f1421f29f"));
  /*[id(0x60020000)]*/ int GetRealObject(StreamingContext Context, out VARIANT pRetVal);
}

interface IAsyncResult : IDispatch {
  mixin(ууид("11ab34e7-0176-3c9e-9efe-197858400a3d"));
  /*[id(0x60020000)]*/ int get_IsCompleted(out short pRetVal);
  /*[id(0x60020001)]*/ int get_AsyncWaitHandle(out _WaitHandle pRetVal);
  /*[id(0x60020002)]*/ int get_AsyncState(out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int get_CompletedSynchronously(out short pRetVal);
}

interface ICustomFormatter : IDispatch {
  mixin(ууид("2b130940-ca5e-3406-8385-e259e68ab039"));
  /*[id(0x60020000)]*/ int format(wchar* format, VARIANT арг, IFormatProvider formatProvider, out wchar* pRetVal);
}

interface IFormatProvider : IDispatch {
  mixin(ууид("c8cb1ded-2814-396a-9cc0-473ca49779cc"));
  /*[id(0x60020000)]*/ int GetFormat(_Type formatType, out VARIANT pRetVal);
}

interface ICustomAttributeProvider : IDispatch {
  mixin(ууид("b9b91146-d6c2-3a62-8159-c2d1794cdeb0"));
  /*[id(0x60020000)]*/ int GetCustomAttributes(_Type attributeType, short inherit, out  SAFEARRAY pRetVal);
  /*[id(0x60020001)]*/ int GetCustomAttributes_2(short inherit, out  SAFEARRAY pRetVal);
  /*[id(0x60020002)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
}

interface _MemberInfo : IUnknown {
  mixin(ууид("f7102fa9-cabb-3a74-a6da-b4567ef1b079"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
}

interface _Type : IUnknown {
  mixin(ууид("bca8b44d-aad6-3a86-8ab7-03349f4f2da2"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int get_Guid(out GUID pRetVal);
  /*[id(0x60010010)]*/ int get_Module(out _Module pRetVal);
  /*[id(0x60010011)]*/ int get_Assembly(out _Assembly pRetVal);
  /*[id(0x60010012)]*/ int get_TypeHandle(out RuntimeTypeHandle pRetVal);
  /*[id(0x60010013)]*/ int get_FullName(out wchar* pRetVal);
  /*[id(0x60010014)]*/ int get_Namespace(out wchar* pRetVal);
  /*[id(0x60010015)]*/ int get_AssemblyQualifiedName(out wchar* pRetVal);
  /*[id(0x60010016)]*/ int GetArrayRank(out int pRetVal);
  /*[id(0x60010017)]*/ int get_BaseType(out _Type pRetVal);
  /*[id(0x60010018)]*/ int GetConstructors(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010019)]*/ int GetInterface(wchar* name, short ignoreCase, out _Type pRetVal);
  /*[id(0x6001001A)]*/ int GetInterfaces( out  SAFEARRAY  pRetVal);
  /*[id(0x6001001B)]*/ int FindInterfaces(_TypeFilter filter, VARIANT filterCriteria,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001001C)]*/ int GetEvent(wchar* name, BindingFlags bindingAttr, out _EventInfo pRetVal);
  /*[id(0x6001001D)]*/ int GetEvents( out  SAFEARRAY  pRetVal);
  /*[id(0x6001001E)]*/ int GetEvents_2(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001001F)]*/ int GetNestedTypes(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010020)]*/ int GetNestedType(wchar* name, BindingFlags bindingAttr, out _Type pRetVal);
  /*[id(0x60010021)]*/ int GetMember(wchar* name, MemberTypes Type, BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010022)]*/ int GetDefaultMembers( out  SAFEARRAY  pRetVal);
  /*[id(0x60010023)]*/ int FindMembers(MemberTypes MemberType, BindingFlags bindingAttr, _MemberFilter filter, VARIANT filterCriteria,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010024)]*/ int GetElementType(out _Type pRetVal);
  /*[id(0x60010025)]*/ int IsSubclassOf(_Type c, out short pRetVal);
  /*[id(0x60010026)]*/ int IsInstanceOfType(VARIANT o, out short pRetVal);
  /*[id(0x60010027)]*/ int IsAssignableFrom(_Type c, out short pRetVal);
  /*[id(0x60010028)]*/ int GetInterfaceMap(_Type interfaceType, out InterfaceMapping pRetVal);
  /*[id(0x60010029)]*/ int GetMethod(wchar* name, BindingFlags bindingAttr, _Binder Binder,   SAFEARRAY types,   SAFEARRAY modifiers, out _MethodInfo pRetVal);
  /*[id(0x6001002A)]*/ int GetMethod_2(wchar* name, BindingFlags bindingAttr, out _MethodInfo pRetVal);
  /*[id(0x6001002B)]*/ int GetMethods(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001002C)]*/ int GetField(wchar* name, BindingFlags bindingAttr, out _FieldInfo pRetVal);
  /*[id(0x6001002D)]*/ int GetFields(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001002E)]*/ int GetProperty(wchar* name, BindingFlags bindingAttr, out _PropertyInfo pRetVal);
  /*[id(0x6001002F)]*/ int GetProperty_2(wchar* name, BindingFlags bindingAttr, _Binder Binder, _Type returnType,   SAFEARRAY types,   SAFEARRAY modifiers, out _PropertyInfo pRetVal);
  /*[id(0x60010030)]*/ int GetProperties(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010031)]*/ int GetMember_2(wchar* name, BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010032)]*/ int GetMembers(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010033)]*/ int InvokeMember(wchar* name, BindingFlags invokeAttr, _Binder Binder, VARIANT Target,   SAFEARRAY  args,   SAFEARRAY modifiers, _CultureInfo culture,  SAFEARRAY namedParameters, out VARIANT pRetVal);
  /*[id(0x60010034)]*/ int get_UnderlyingSystemType(out _Type pRetVal);
  /*[id(0x60010035)]*/ int InvokeMember_2(wchar* name, BindingFlags invokeAttr, _Binder Binder, VARIANT Target,   SAFEARRAY  args, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60010036)]*/ int InvokeMember_3(wchar* name, BindingFlags invokeAttr, _Binder Binder, VARIANT Target,   SAFEARRAY  args, out VARIANT pRetVal);
  /*[id(0x60010037)]*/ int GetConstructor(BindingFlags bindingAttr, _Binder Binder, CallingConventions callConvention,   SAFEARRAY types,   SAFEARRAY modifiers, out _ConstructorInfo pRetVal);
  /*[id(0x60010038)]*/ int GetConstructor_2(BindingFlags bindingAttr, _Binder Binder,   SAFEARRAY types,   SAFEARRAY modifiers, out _ConstructorInfo pRetVal);
  /*[id(0x60010039)]*/ int GetConstructor_3(  SAFEARRAY types, out _ConstructorInfo pRetVal);
  /*[id(0x6001003A)]*/ int GetConstructors_2( out  SAFEARRAY  pRetVal);
  /*[id(0x6001003B)]*/ int get_TypeInitializer(out _ConstructorInfo pRetVal);
  /*[id(0x6001003C)]*/ int GetMethod_3(wchar* name, BindingFlags bindingAttr, _Binder Binder, CallingConventions callConvention,   SAFEARRAY types,   SAFEARRAY modifiers, out _MethodInfo pRetVal);
  /*[id(0x6001003D)]*/ int GetMethod_4(wchar* name,   SAFEARRAY types,   SAFEARRAY modifiers, out _MethodInfo pRetVal);
  /*[id(0x6001003E)]*/ int GetMethod_5(wchar* name,   SAFEARRAY types, out _MethodInfo pRetVal);
  /*[id(0x6001003F)]*/ int GetMethod_6(wchar* name, out _MethodInfo pRetVal);
  /*[id(0x60010040)]*/ int GetMethods_2( out  SAFEARRAY  pRetVal);
  /*[id(0x60010041)]*/ int GetField_2(wchar* name, out _FieldInfo pRetVal);
  /*[id(0x60010042)]*/ int GetFields_2( out  SAFEARRAY  pRetVal);
  /*[id(0x60010043)]*/ int GetInterface_2(wchar* name, out _Type pRetVal);
  /*[id(0x60010044)]*/ int GetEvent_2(wchar* name, out _EventInfo pRetVal);
  /*[id(0x60010045)]*/ int GetProperty_3(wchar* name, _Type returnType,   SAFEARRAY types,   SAFEARRAY modifiers, out _PropertyInfo pRetVal);
  /*[id(0x60010046)]*/ int GetProperty_4(wchar* name, _Type returnType,   SAFEARRAY types, out _PropertyInfo pRetVal);
  /*[id(0x60010047)]*/ int GetProperty_5(wchar* name,   SAFEARRAY types, out _PropertyInfo pRetVal);
  /*[id(0x60010048)]*/ int GetProperty_6(wchar* name, _Type returnType, out _PropertyInfo pRetVal);
  /*[id(0x60010049)]*/ int GetProperty_7(wchar* name, out _PropertyInfo pRetVal);
  /*[id(0x6001004A)]*/ int GetProperties_2( out  SAFEARRAY  pRetVal);
  /*[id(0x6001004B)]*/ int GetNestedTypes_2( out  SAFEARRAY  pRetVal);
  /*[id(0x6001004C)]*/ int GetNestedType_2(wchar* name, out _Type pRetVal);
  /*[id(0x6001004D)]*/ int GetMember_3(wchar* name,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001004E)]*/ int GetMembers_2( out  SAFEARRAY  pRetVal);
  /*[id(0x6001004F)]*/ int get_Attributes(out TypeAttributes pRetVal);
  /*[id(0x60010050)]*/ int get_IsNotPublic(out short pRetVal);
  /*[id(0x60010051)]*/ int get_IsPublic(out short pRetVal);
  /*[id(0x60010052)]*/ int get_IsNestedPublic(out short pRetVal);
  /*[id(0x60010053)]*/ int get_IsNestedPrivate(out short pRetVal);
  /*[id(0x60010054)]*/ int get_IsNestedFamily(out short pRetVal);
  /*[id(0x60010055)]*/ int get_IsNestedAssembly(out short pRetVal);
  /*[id(0x60010056)]*/ int get_IsNestedFamANDAssem(out short pRetVal);
  /*[id(0x60010057)]*/ int get_IsNestedFamORAssem(out short pRetVal);
  /*[id(0x60010058)]*/ int get_IsAutoLayout(out short pRetVal);
  /*[id(0x60010059)]*/ int get_IsLayoutSequential(out short pRetVal);
  /*[id(0x6001005A)]*/ int get_IsExplicitLayout(out short pRetVal);
  /*[id(0x6001005B)]*/ int get_IsClass(out short pRetVal);
  /*[id(0x6001005C)]*/ int get_IsInterface(out short pRetVal);
  /*[id(0x6001005D)]*/ int get_IsValueType(out short pRetVal);
  /*[id(0x6001005E)]*/ int get_IsAbstract(out short pRetVal);
  /*[id(0x6001005F)]*/ int get_IsSealed(out short pRetVal);
  /*[id(0x60010060)]*/ int get_IsEnum(out short pRetVal);
  /*[id(0x60010061)]*/ int get_IsSpecialName(out short pRetVal);
  /*[id(0x60010062)]*/ int get_IsImport(out short pRetVal);
  /*[id(0x60010063)]*/ int get_IsSerializable(out short pRetVal);
  /*[id(0x60010064)]*/ int get_IsAnsiClass(out short pRetVal);
  /*[id(0x60010065)]*/ int get_IsUnicodeClass(out short pRetVal);
  /*[id(0x60010066)]*/ int get_IsAutoClass(out short pRetVal);
  /*[id(0x60010067)]*/ int get_IsArray(out short pRetVal);
  /*[id(0x60010068)]*/ int get_IsByRef(out short pRetVal);
  /*[id(0x60010069)]*/ int get_IsPointer(out short pRetVal);
  /*[id(0x6001006A)]*/ int get_IsPrimitive(out short pRetVal);
  /*[id(0x6001006B)]*/ int get_IsCOMObject(out short pRetVal);
  /*[id(0x6001006C)]*/ int get_HasElementType(out short pRetVal);
  /*[id(0x6001006D)]*/ int get_IsContextful(out short pRetVal);
  /*[id(0x6001006E)]*/ int get_IsMarshalByRef(out short pRetVal);
  /*[id(0x6001006F)]*/ int Equals_2(_Type o, out short pRetVal);
}

interface IReflect : IDispatch {
  mixin(ууид("afbf15e5-c37c-11d2-b88e-00a0c9b471b8"));
  /*[id(0x60020000)]*/ int GetMethod(wchar* name, BindingFlags bindingAttr, _Binder Binder,   SAFEARRAY types,   SAFEARRAY modifiers, out _MethodInfo pRetVal);
  /*[id(0x60020001)]*/ int GetMethod_2(wchar* name, BindingFlags bindingAttr, out _MethodInfo pRetVal);
  /*[id(0x60020002)]*/ int GetMethods(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020003)]*/ int GetField(wchar* name, BindingFlags bindingAttr, out _FieldInfo pRetVal);
  /*[id(0x60020004)]*/ int GetFields(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020005)]*/ int GetProperty(wchar* name, BindingFlags bindingAttr, out _PropertyInfo pRetVal);
  /*[id(0x60020006)]*/ int GetProperty_2(wchar* name, BindingFlags bindingAttr, _Binder Binder, _Type returnType,   SAFEARRAY types,   SAFEARRAY modifiers, out _PropertyInfo pRetVal);
  /*[id(0x60020007)]*/ int GetProperties(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020008)]*/ int GetMember(wchar* name, BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020009)]*/ int GetMembers(BindingFlags bindingAttr,  out  SAFEARRAY  pRetVal);
  /*[id(0x6002000A)]*/ int InvokeMember(wchar* name, BindingFlags invokeAttr, _Binder Binder, VARIANT Target,   SAFEARRAY  args,   SAFEARRAY modifiers, _CultureInfo culture,  SAFEARRAY namedParameters, out VARIANT pRetVal);
  /*[id(0x6002000B)]*/ int get_UnderlyingSystemType(out _Type pRetVal);
}

interface IObjectHandle : IUnknown {
  mixin(ууид("c460e2b4-e199-412a-8456-84dc3e4838c3"));
  /*[id(0x60010000)]*/ int Unwrap(out VARIANT pRetVal);
}

interface IHashCodeProvider : IDispatch {
  mixin(ууид("5d573036-3435-3c5a-aeff-2b8191082c71"));
  /*[id(0x60020000)]*/ int GetHashCode(VARIANT объ, out int pRetVal);
}

interface IDictionary : IDispatch {
  mixin(ууид("6a6841df-3287-3d87-8060-ce0b4c77d2a1"));
  /*[id(0x00000000)]*/ int get_Item(VARIANT key, out VARIANT pRetVal);
  /*[id(0x00000000)]*/ int putref_Item(VARIANT key, VARIANT pRetVal);
  /*[id(0x60020002)]*/ int get_Keys(out ICollection pRetVal);
  /*[id(0x60020003)]*/ int get_Values(out ICollection pRetVal);
  /*[id(0x60020004)]*/ int Contains(VARIANT key, out short pRetVal);
  /*[id(0x60020005)]*/ int Add(VARIANT key, VARIANT value);
  /*[id(0x60020006)]*/ int Clear();
  /*[id(0x60020007)]*/ int get_IsReadOnly(out short pRetVal);
  /*[id(0x60020008)]*/ int get_IsFixedSize(out short pRetVal);
  /*[id(0x60020009)]*/ int GetEnumerator(out IDictionaryEnumerator pRetVal);
  /*[id(0x6002000A)]*/ int Remove(VARIANT key);
}

interface IDictionaryEnumerator : IDispatch {
  mixin(ууид("35d574bf-7a4f-3588-8c19-12212a0fe4dc"));
  /*[id(0x60020000)]*/ int get_key(out VARIANT pRetVal);
  /*[id(0x00000000)]*/ int get_value(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int get_Entry(out DictionaryEntry pRetVal);
}

interface ISymbolBinder : IDispatch {
  mixin(ууид("20808adc-cc01-3f3a-8f09-ed12940fc212"));
  /*[id(0x60020000)]*/ int GetReader(int importer, wchar* filename, wchar* searchPath, out ISymbolReader pRetVal);
}

interface ISymbolBinder1 : IDispatch {
  mixin(ууид("027c036a-4052-3821-85de-b53319df1211"));
  /*[id(0x60020000)]*/ int GetReader(int importer, wchar* filename, wchar* searchPath, out ISymbolReader pRetVal);
}

interface ISymbolDocument : IDispatch {
  mixin(ууид("1c32f012-2684-3efe-8d50-9c2973acc00b"));
  /*[id(0x60020000)]*/ int get_Url(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int get_DocumentType(out GUID pRetVal);
  /*[id(0x60020002)]*/ int get_Language(out GUID pRetVal);
  /*[id(0x60020003)]*/ int get_LanguageVendor(out GUID pRetVal);
  /*[id(0x60020004)]*/ int get_CheckSumAlgorithmId(out GUID pRetVal);
  /*[id(0x60020005)]*/ int GetCheckSum(out SAFEARRAY  pRetVal);
  /*[id(0x60020006)]*/ int FindClosestLine(int line, out int pRetVal);
  /*[id(0x60020007)]*/ int get_HasEmbeddedSource(out short pRetVal);
  /*[id(0x60020008)]*/ int get_SourceLength(out int pRetVal);
  /*[id(0x60020009)]*/ int GetSourceRange(int startLine, int startColumn, int endLine, int endColumn,  out  SAFEARRAY  pRetVal);
}

interface ISymbolDocumentWriter : IDispatch {
  mixin(ууид("fa682f24-3a3c-390d-b8a2-96f1106f4b37"));
  /*[id(0x60020000)]*/ int SetSource( SAFEARRAY Source);
  /*[id(0x60020001)]*/ int SetCheckSum(GUID algorithmId, SAFEARRAY checkSum);
}

interface ISymbolMethod : IDispatch {
  mixin(ууид("25c72eb0-e437-3f17-946d-3b72a3acff37"));
  /*[id(0x60020000)]*/ int get_Token(out SymbolToken pRetVal);
  /*[id(0x60020001)]*/ int get_SequencePointCount(out int pRetVal);
  /*[id(0x60020002)]*/ int GetSequencePoints( SAFEARRAY offsets,  SAFEARRAY documents,  SAFEARRAY lines,  SAFEARRAY columns,  SAFEARRAY endLines,  SAFEARRAY endColumns);
  /*[id(0x60020003)]*/ int get_RootScope(out ISymbolScope pRetVal);
  /*[id(0x60020004)]*/ int GetScope(int offset, out ISymbolScope pRetVal);
  /*[id(0x60020005)]*/ int GetOffset(ISymbolDocument document, int line, int column, out int pRetVal);
  /*[id(0x60020006)]*/ int GetRanges(ISymbolDocument document, int line, int column,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020007)]*/ int GetParameters(out SAFEARRAY pRetVal);
  /*[id(0x60020008)]*/ int GetNamespace(out ISymbolNamespace pRetVal);
  /*[id(0x60020009)]*/ int GetSourceStartEnd(SAFEARRAY docs, SAFEARRAY  lines, SAFEARRAY columns, out short pRetVal);
}

interface ISymbolNamespace : IDispatch {
  mixin(ууид("23ed2454-6899-3c28-bab7-6ec86683964a"));
  /*[id(0x60020000)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int GetNamespaces( out  SAFEARRAY  pRetVal);
  /*[id(0x60020002)]*/ int GetVariables( out  SAFEARRAY  pRetVal);
}

interface ISymbolReader : IDispatch {
  mixin(ууид("e809a5f1-d3d7-3144-9bef-fe8ac0364699"));
  /*[id(0x60020000)]*/ int GetDocument(wchar* Url, GUID Language, GUID LanguageVendor, GUID DocumentType, out ISymbolDocument pRetVal);
  /*[id(0x60020001)]*/ int GetDocuments( out  SAFEARRAY  pRetVal);
  /*[id(0x60020002)]*/ int get_UserEntryPoint(out SymbolToken pRetVal);
  /*[id(0x60020003)]*/ int GetMethod(SymbolToken Method, out ISymbolMethod pRetVal);
  /*[id(0x60020004)]*/ int GetMethod_2(SymbolToken Method, int Version, out ISymbolMethod pRetVal);
  /*[id(0x60020005)]*/ int GetVariables(SymbolToken parent,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020006)]*/ int GetGlobalVariables( out  SAFEARRAY  pRetVal);
  /*[id(0x60020007)]*/ int GetMethodFromDocumentPosition(ISymbolDocument document, int line, int column, out ISymbolMethod pRetVal);
  /*[id(0x60020008)]*/ int GetSymAttribute(SymbolToken parent, wchar* name,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020009)]*/ int GetNamespaces( out  SAFEARRAY  pRetVal);
}

interface ISymbolScope : IDispatch {
  mixin(ууид("1cee3a11-01ae-3244-a939-4972fc9703ef"));
  /*[id(0x60020000)]*/ int get_Method(out ISymbolMethod pRetVal);
  /*[id(0x60020001)]*/ int get_parent(out ISymbolScope pRetVal);
  /*[id(0x60020002)]*/ int GetChildren( out  SAFEARRAY  pRetVal);
  /*[id(0x60020003)]*/ int get_StartOffset(out int pRetVal);
  /*[id(0x60020004)]*/ int get_EndOffset(out int pRetVal);
  /*[id(0x60020005)]*/ int GetLocals( out  SAFEARRAY  pRetVal);
  /*[id(0x60020006)]*/ int GetNamespaces( out  SAFEARRAY  pRetVal);
}

interface ISymbolVariable : IDispatch {
  mixin(ууид("4042bd4d-b5ab-30e8-919b-14910687baae"));
  /*[id(0x60020000)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int get_Attributes(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int GetSignature( out  SAFEARRAY  pRetVal);
  /*[id(0x60020003)]*/ int get_AddressKind(out SymAddressKind pRetVal);
  /*[id(0x60020004)]*/ int get_AddressField1(out int pRetVal);
  /*[id(0x60020005)]*/ int get_AddressField2(out int pRetVal);
  /*[id(0x60020006)]*/ int get_AddressField3(out int pRetVal);
  /*[id(0x60020007)]*/ int get_StartOffset(out int pRetVal);
  /*[id(0x60020008)]*/ int get_EndOffset(out int pRetVal);
}

interface ISymbolWriter : IDispatch {
  mixin(ууид("da295a1b-c5bd-3b34-8acd-1d7d334ffb7f"));
  /*[id(0x60020000)]*/ int Initialize(int emitter, wchar* filename, short fFullBuild);
  /*[id(0x60020001)]*/ int DefineDocument(wchar* Url, GUID Language, GUID LanguageVendor, GUID DocumentType, out ISymbolDocumentWriter pRetVal);
  /*[id(0x60020002)]*/ int SetUserEntryPoint(SymbolToken entryMethod);
  /*[id(0x60020003)]*/ int OpenMethod(SymbolToken Method);
  /*[id(0x60020004)]*/ int CloseMethod();
  /*[id(0x60020005)]*/ int DefineSequencePoints(ISymbolDocumentWriter document,   SAFEARRAY offsets,  SAFEARRAY lines,  SAFEARRAY columns,  SAFEARRAY endLines,  SAFEARRAY endColumns);
  /*[id(0x60020006)]*/ int OpenScope(int StartOffset, out int pRetVal);
  /*[id(0x60020007)]*/ int CloseScope(int EndOffset);
  /*[id(0x60020008)]*/ int SetScopeRange(int scopeID, int StartOffset, int EndOffset);
  /*[id(0x60020009)]*/ int DefineLocalVariable(wchar* name, FieldAttributes Attributes,   SAFEARRAY signature, SymAddressKind addrKind, int addr1, int addr2, int addr3, int StartOffset, int EndOffset);
  /*[id(0x6002000A)]*/ int DefineParameter(wchar* name, ParameterAttributes Attributes, int sequence, SymAddressKind addrKind, int addr1, int addr2, int addr3);
  /*[id(0x6002000B)]*/ int DefineField(SymbolToken parent, wchar* name, FieldAttributes Attributes,   SAFEARRAY signature, SymAddressKind addrKind, int addr1, int addr2, int addr3);
  /*[id(0x6002000C)]*/ int DefineGlobalVariable(wchar* name, FieldAttributes Attributes,   SAFEARRAY signature, SymAddressKind addrKind, int addr1, int addr2, int addr3);
  /*[id(0x6002000D)]*/ int Close();
  /*[id(0x6002000E)]*/ int SetSymAttribute(SymbolToken parent, wchar* name,   SAFEARRAY data);
  /*[id(0x6002000F)]*/ int OpenNamespace(wchar* name);
  /*[id(0x60020010)]*/ int CloseNamespace();
  /*[id(0x60020011)]*/ int UsingNamespace(wchar* FullName);
  /*[id(0x60020012)]*/ int SetMethodSourceRange(ISymbolDocumentWriter startDoc, int startLine, int startColumn, ISymbolDocumentWriter endDoc, int endLine, int endColumn);
  /*[id(0x60020013)]*/ int SetUnderlyingWriter(int underlyingWriter);
}

interface _Assembly : IDispatch {
  mixin(ууид("17156360-2f1a-384a-bc52-fde93c215c5b"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int get_CodeBase(out wchar* pRetVal);
  /*[id(0x60020005)]*/ int get_EscapedCodeBase(out wchar* pRetVal);
  /*[id(0x60020006)]*/ int GetName(out _AssemblyName pRetVal);
  /*[id(0x60020007)]*/ int GetName_2(short copiedName, out _AssemblyName pRetVal);
  /*[id(0x60020008)]*/ int get_FullName(out wchar* pRetVal);
  /*[id(0x60020009)]*/ int get_EntryPoint(out _MethodInfo pRetVal);
  /*[id(0x6002000A)]*/ int GetType_2(wchar* name, out _Type pRetVal);
  /*[id(0x6002000B)]*/ int GetType_3(wchar* name, short throwOnError, out _Type pRetVal);
  /*[id(0x6002000C)]*/ int GetExportedTypes( out  SAFEARRAY  pRetVal);
  /*[id(0x6002000D)]*/ int GetTypes( out  SAFEARRAY  pRetVal);
  /*[id(0x6002000E)]*/ int GetManifestResourceStream(_Type Type, wchar* name, out _Stream pRetVal);
  /*[id(0x6002000F)]*/ int GetManifestResourceStream_2(wchar* name, out _Stream pRetVal);
  /*[id(0x60020010)]*/ int GetFile(wchar* name, out _FileStream pRetVal);
  /*[id(0x60020011)]*/ int GetFiles( out  SAFEARRAY  pRetVal);
  /*[id(0x60020012)]*/ int GetFiles_2(short getResourceModules,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020013)]*/ int GetManifestResourceNames( out  SAFEARRAY  pRetVal);
  /*[id(0x60020014)]*/ int GetManifestResourceInfo(wchar* resourceName, out _ManifestResourceInfo pRetVal);
  /*[id(0x60020015)]*/ int get_Location(out wchar* pRetVal);
  /*[id(0x60020016)]*/ int get_Evidence(out _Evidence pRetVal);
  /*[id(0x60020017)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020018)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020019)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6002001A)]*/ int GetObjectData(_SerializationInfo info, StreamingContext Context);
  /*[id(0x6002001B)]*/ int add_ModuleResolve(_ModuleResolveEventHandler value);
  /*[id(0x6002001C)]*/ int remove_ModuleResolve(_ModuleResolveEventHandler value);
  /*[id(0x6002001D)]*/ int GetType_4(wchar* name, short throwOnError, short ignoreCase, out _Type pRetVal);
  /*[id(0x6002001E)]*/ int GetSatelliteAssembly(_CultureInfo culture, out _Assembly pRetVal);
  /*[id(0x6002001F)]*/ int GetSatelliteAssembly_2(_CultureInfo culture, _Version Version, out _Assembly pRetVal);
  /*[id(0x60020020)]*/ int LoadModule(wchar* moduleName,   SAFEARRAY rawModule, out _Module pRetVal);
  /*[id(0x60020021)]*/ int LoadModule_2(wchar* moduleName,   SAFEARRAY rawModule,   SAFEARRAY rawSymbolStore, out _Module pRetVal);
  /*[id(0x60020022)]*/ int CreateInstance(wchar* typeName, out VARIANT pRetVal);
  /*[id(0x60020023)]*/ int CreateInstance_2(wchar* typeName, short ignoreCase, out VARIANT pRetVal);
  /*[id(0x60020024)]*/ int CreateInstance_3(wchar* typeName, short ignoreCase, BindingFlags bindingAttr, _Binder Binder,   SAFEARRAY  args, _CultureInfo culture,   SAFEARRAY  activationAttributes, out VARIANT pRetVal);
  /*[id(0x60020025)]*/ int GetLoadedModules( out  SAFEARRAY  pRetVal);
  /*[id(0x60020026)]*/ int GetLoadedModules_2(short getResourceModules,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020027)]*/ int GetModules( out  SAFEARRAY  pRetVal);
  /*[id(0x60020028)]*/ int GetModules_2(short getResourceModules,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020029)]*/ int GetModule(wchar* name, out _Module pRetVal);
  /*[id(0x6002002A)]*/ int GetReferencedAssemblies( out  SAFEARRAY  pRetVal);
  /*[id(0x6002002B)]*/ int get_GlobalAssemblyCache(out short pRetVal);
}

interface _AssemblyName : IUnknown {
  mixin(ууид("b42b6aac-317e-34d5-9fa9-093bb4160c50"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _MethodBase : IUnknown {
  mixin(ууид("6240837a-707f-3181-8e98-a36ae086766b"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int GetParameters( out  SAFEARRAY  pRetVal);
  /*[id(0x60010010)]*/ int GetMethodImplementationFlags(out MethodImplAttributes pRetVal);
  /*[id(0x60010011)]*/ int get_MethodHandle(out RuntimeMethodHandle pRetVal);
  /*[id(0x60010012)]*/ int get_Attributes(out MethodAttributes pRetVal);
  /*[id(0x60010013)]*/ int get_CallingConvention(out CallingConventions pRetVal);
  /*[id(0x60010014)]*/ int Invoke_2(VARIANT объ, BindingFlags invokeAttr, _Binder Binder,   SAFEARRAY parameters, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60010015)]*/ int get_IsPublic(out short pRetVal);
  /*[id(0x60010016)]*/ int get_IsPrivate(out short pRetVal);
  /*[id(0x60010017)]*/ int get_IsFamily(out short pRetVal);
  /*[id(0x60010018)]*/ int get_IsAssembly(out short pRetVal);
  /*[id(0x60010019)]*/ int get_IsFamilyAndAssembly(out short pRetVal);
  /*[id(0x6001001A)]*/ int get_IsFamilyOrAssembly(out short pRetVal);
  /*[id(0x6001001B)]*/ int get_IsStatic(out short pRetVal);
  /*[id(0x6001001C)]*/ int get_IsFinal(out short pRetVal);
  /*[id(0x6001001D)]*/ int get_IsVirtual(out short pRetVal);
  /*[id(0x6001001E)]*/ int get_IsHideBySig(out short pRetVal);
  /*[id(0x6001001F)]*/ int get_IsAbstract(out short pRetVal);
  /*[id(0x60010020)]*/ int get_IsSpecialName(out short pRetVal);
  /*[id(0x60010021)]*/ int get_IsConstructor(out short pRetVal);
  /*[id(0x60010022)]*/ int Invoke_3(VARIANT объ,   SAFEARRAY parameters, out VARIANT pRetVal);
}

interface _MethodInfo : IUnknown {
  mixin(ууид("ffcc1b5d-ecb8-38dd-9b01-3dc8abc2aa5f"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int GetParameters( out  SAFEARRAY  pRetVal);
  /*[id(0x60010010)]*/ int GetMethodImplementationFlags(out MethodImplAttributes pRetVal);
  /*[id(0x60010011)]*/ int get_MethodHandle(out RuntimeMethodHandle pRetVal);
  /*[id(0x60010012)]*/ int get_Attributes(out MethodAttributes pRetVal);
  /*[id(0x60010013)]*/ int get_CallingConvention(out CallingConventions pRetVal);
  /*[id(0x60010014)]*/ int Invoke_2(VARIANT объ, BindingFlags invokeAttr, _Binder Binder,   SAFEARRAY parameters, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60010015)]*/ int get_IsPublic(out short pRetVal);
  /*[id(0x60010016)]*/ int get_IsPrivate(out short pRetVal);
  /*[id(0x60010017)]*/ int get_IsFamily(out short pRetVal);
  /*[id(0x60010018)]*/ int get_IsAssembly(out short pRetVal);
  /*[id(0x60010019)]*/ int get_IsFamilyAndAssembly(out short pRetVal);
  /*[id(0x6001001A)]*/ int get_IsFamilyOrAssembly(out short pRetVal);
  /*[id(0x6001001B)]*/ int get_IsStatic(out short pRetVal);
  /*[id(0x6001001C)]*/ int get_IsFinal(out short pRetVal);
  /*[id(0x6001001D)]*/ int get_IsVirtual(out short pRetVal);
  /*[id(0x6001001E)]*/ int get_IsHideBySig(out short pRetVal);
  /*[id(0x6001001F)]*/ int get_IsAbstract(out short pRetVal);
  /*[id(0x60010020)]*/ int get_IsSpecialName(out short pRetVal);
  /*[id(0x60010021)]*/ int get_IsConstructor(out short pRetVal);
  /*[id(0x60010022)]*/ int Invoke_3(VARIANT объ,   SAFEARRAY parameters, out VARIANT pRetVal);
  /*[id(0x60010023)]*/ int get_returnType(out _Type pRetVal);
  /*[id(0x60010024)]*/ int get_ReturnTypeCustomAttributes(out ICustomAttributeProvider pRetVal);
  /*[id(0x60010025)]*/ int GetBaseDefinition(out _MethodInfo pRetVal);
}

interface _ConstructorInfo : IUnknown {
  mixin(ууид("e9a19478-9646-3679-9b10-8411ae1fd57d"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int GetParameters( out  SAFEARRAY  pRetVal);
  /*[id(0x60010010)]*/ int GetMethodImplementationFlags(out MethodImplAttributes pRetVal);
  /*[id(0x60010011)]*/ int get_MethodHandle(out RuntimeMethodHandle pRetVal);
  /*[id(0x60010012)]*/ int get_Attributes(out MethodAttributes pRetVal);
  /*[id(0x60010013)]*/ int get_CallingConvention(out CallingConventions pRetVal);
  /*[id(0x60010014)]*/ int Invoke_2(VARIANT объ, BindingFlags invokeAttr, _Binder Binder,   SAFEARRAY parameters, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60010015)]*/ int get_IsPublic(out short pRetVal);
  /*[id(0x60010016)]*/ int get_IsPrivate(out short pRetVal);
  /*[id(0x60010017)]*/ int get_IsFamily(out short pRetVal);
  /*[id(0x60010018)]*/ int get_IsAssembly(out short pRetVal);
  /*[id(0x60010019)]*/ int get_IsFamilyAndAssembly(out short pRetVal);
  /*[id(0x6001001A)]*/ int get_IsFamilyOrAssembly(out short pRetVal);
  /*[id(0x6001001B)]*/ int get_IsStatic(out short pRetVal);
  /*[id(0x6001001C)]*/ int get_IsFinal(out short pRetVal);
  /*[id(0x6001001D)]*/ int get_IsVirtual(out short pRetVal);
  /*[id(0x6001001E)]*/ int get_IsHideBySig(out short pRetVal);
  /*[id(0x6001001F)]*/ int get_IsAbstract(out short pRetVal);
  /*[id(0x60010020)]*/ int get_IsSpecialName(out short pRetVal);
  /*[id(0x60010021)]*/ int get_IsConstructor(out short pRetVal);
  /*[id(0x60010022)]*/ int Invoke_3(VARIANT объ,   SAFEARRAY parameters, out VARIANT pRetVal);
  /*[id(0x60010023)]*/ int Invoke_4(BindingFlags invokeAttr, _Binder Binder,   SAFEARRAY parameters, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60010024)]*/ int Invoke_5(  SAFEARRAY parameters, out VARIANT pRetVal);
}

interface _FieldInfo : IUnknown {
  mixin(ууид("8a7c1442-a9fb-366b-80d8-4939ffa6dbe0"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int get_FieldType(out _Type pRetVal);
  /*[id(0x60010010)]*/ int GetValue(VARIANT объ, out VARIANT pRetVal);
  /*[id(0x60010011)]*/ int GetValueDirect(VARIANT объ, out VARIANT pRetVal);
  /*[id(0x60010012)]*/ int SetValue(VARIANT объ, VARIANT value, BindingFlags invokeAttr, _Binder Binder, _CultureInfo culture);
  /*[id(0x60010013)]*/ int SetValueDirect(VARIANT объ, VARIANT value);
  /*[id(0x60010014)]*/ int get_FieldHandle(out RuntimeFieldHandle pRetVal);
  /*[id(0x60010015)]*/ int get_Attributes(out FieldAttributes pRetVal);
  /*[id(0x60010016)]*/ int SetValue_2(VARIANT объ, VARIANT value);
  /*[id(0x60010017)]*/ int get_IsPublic(out short pRetVal);
  /*[id(0x60010018)]*/ int get_IsPrivate(out short pRetVal);
  /*[id(0x60010019)]*/ int get_IsFamily(out short pRetVal);
  /*[id(0x6001001A)]*/ int get_IsAssembly(out short pRetVal);
  /*[id(0x6001001B)]*/ int get_IsFamilyAndAssembly(out short pRetVal);
  /*[id(0x6001001C)]*/ int get_IsFamilyOrAssembly(out short pRetVal);
  /*[id(0x6001001D)]*/ int get_IsStatic(out short pRetVal);
  /*[id(0x6001001E)]*/ int get_IsInitOnly(out short pRetVal);
  /*[id(0x6001001F)]*/ int get_IsLiteral(out short pRetVal);
  /*[id(0x60010020)]*/ int get_IsNotSerialized(out short pRetVal);
  /*[id(0x60010021)]*/ int get_IsSpecialName(out short pRetVal);
  /*[id(0x60010022)]*/ int get_IsPinvokeImpl(out short pRetVal);
}

interface _PropertyInfo : IUnknown {
  mixin(ууид("f59ed4e4-e68f-3218-bd77-061aa82824bf"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int get_PropertyType(out _Type pRetVal);
  /*[id(0x60010010)]*/ int GetValue(VARIANT объ,   SAFEARRAY index, out VARIANT pRetVal);
  /*[id(0x60010011)]*/ int GetValue_2(VARIANT объ, BindingFlags invokeAttr, _Binder Binder,   SAFEARRAY index, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60010012)]*/ int SetValue(VARIANT объ, VARIANT value,   SAFEARRAY index);
  /*[id(0x60010013)]*/ int SetValue_2(VARIANT объ, VARIANT value, BindingFlags invokeAttr, _Binder Binder,   SAFEARRAY index, _CultureInfo culture);
  /*[id(0x60010014)]*/ int GetAccessors(short nonPublic,  out  SAFEARRAY  pRetVal);
  /*[id(0x60010015)]*/ int GetGetMethod(short nonPublic, out _MethodInfo pRetVal);
  /*[id(0x60010016)]*/ int GetSetMethod(short nonPublic, out _MethodInfo pRetVal);
  /*[id(0x60010017)]*/ int GetIndexParameters( out  SAFEARRAY  pRetVal);
  /*[id(0x60010018)]*/ int get_Attributes(out PropertyAttributes pRetVal);
  /*[id(0x60010019)]*/ int get_CanRead(out short pRetVal);
  /*[id(0x6001001A)]*/ int get_CanWrite(out short pRetVal);
  /*[id(0x6001001B)]*/ int GetAccessors_2( out  SAFEARRAY  pRetVal);
  /*[id(0x6001001C)]*/ int GetGetMethod_2(out _MethodInfo pRetVal);
  /*[id(0x6001001D)]*/ int GetSetMethod_2(out _MethodInfo pRetVal);
  /*[id(0x6001001E)]*/ int get_IsSpecialName(out short pRetVal);
}

interface _EventInfo : IUnknown {
  mixin(ууид("9de59c64-d889-35a1-b897-587d74469e5b"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60010005)]*/ int Equals(VARIANT other, out short pRetVal);
  /*[id(0x60010006)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60010007)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60010008)]*/ int get_MemberType(out MemberTypes pRetVal);
  /*[id(0x60010009)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x6001000A)]*/ int get_DeclaringType(out _Type pRetVal);
  /*[id(0x6001000B)]*/ int get_ReflectedType(out _Type pRetVal);
  /*[id(0x6001000C)]*/ int GetCustomAttributes(_Type attributeType, short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000D)]*/ int GetCustomAttributes_2(short inherit,  out  SAFEARRAY  pRetVal);
  /*[id(0x6001000E)]*/ int IsDefined(_Type attributeType, short inherit, out short pRetVal);
  /*[id(0x6001000F)]*/ int GetAddMethod(short nonPublic, out _MethodInfo pRetVal);
  /*[id(0x60010010)]*/ int GetRemoveMethod(short nonPublic, out _MethodInfo pRetVal);
  /*[id(0x60010011)]*/ int GetRaiseMethod(short nonPublic, out _MethodInfo pRetVal);
  /*[id(0x60010012)]*/ int get_Attributes(out EventAttributes pRetVal);
  /*[id(0x60010013)]*/ int GetAddMethod_2(out _MethodInfo pRetVal);
  /*[id(0x60010014)]*/ int GetRemoveMethod_2(out _MethodInfo pRetVal);
  /*[id(0x60010015)]*/ int GetRaiseMethod_2(out _MethodInfo pRetVal);
  /*[id(0x60010016)]*/ int AddEventHandler(VARIANT Target, _Delegate handler);
  /*[id(0x60010017)]*/ int RemoveEventHandler(VARIANT Target, _Delegate handler);
  /*[id(0x60010018)]*/ int get_EventHandlerType(out _Type pRetVal);
  /*[id(0x60010019)]*/ int get_IsSpecialName(out short pRetVal);
  /*[id(0x6001001A)]*/ int get_IsMulticast(out short pRetVal);
}

interface _ParameterInfo : IUnknown {
  mixin(ууид("993634c4-e47a-32cc-be08-85f567dc27d6"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _Module : IUnknown {
  mixin(ууид("d002e9ba-d9e3-3749-b1d3-d565a08b13e7"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface IFormatterConverter : IDispatch {
  mixin(ууид("f4f5c303-fad3-3d0c-a4df-bb82b5ee308f"));
  /*[id(0x60020000)]*/ int Convert(VARIANT value, _Type Type, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int Convert_2(VARIANT value, TypeCode TypeCode, out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int ToBoolean(VARIANT value, out short pRetVal);
  /*[id(0x60020003)]*/ int ToChar(VARIANT value, out ushort pRetVal);
  /*[id(0x60020004)]*/ int ToSByte(VARIANT value, out byte pRetVal);
  /*[id(0x60020005)]*/ int ToByte(VARIANT value, out ubyte pRetVal);
  /*[id(0x60020006)]*/ int ToInt16(VARIANT value, out short pRetVal);
  /*[id(0x60020007)]*/ int ToUInt16(VARIANT value, out ushort pRetVal);
  /*[id(0x60020008)]*/ int ToInt32(VARIANT value, out int pRetVal);
  /*[id(0x60020009)]*/ int ToUInt32(VARIANT value, out uint pRetVal);
  /*[id(0x6002000A)]*/ int ToInt64(VARIANT value, out long pRetVal);
  /*[id(0x6002000B)]*/ int ToUInt64(VARIANT value, out ulong pRetVal);
  /*[id(0x6002000C)]*/ int ToSingle(VARIANT value, out float pRetVal);
  /*[id(0x6002000D)]*/ int ToDouble(VARIANT value, out double pRetVal);
  /*[id(0x6002000E)]*/ int ToDecimal(VARIANT value, out DECIMAL pRetVal);
  /*[id(0x6002000F)]*/ int ToDateTime(VARIANT value, out double pRetVal);
  /*[id(0x60020010)]*/ int get_ToString(VARIANT value, out wchar* pRetVal);
}

interface ISerializationSurrogate : IDispatch {
  mixin(ууид("62339172-dbfa-337b-8ac8-053b241e06ab"));
  /*[id(0x60020000)]*/ int GetObjectData(VARIANT объ, _SerializationInfo info, StreamingContext Context);
  /*[id(0x60020001)]*/ int SetObjectData(VARIANT объ, _SerializationInfo info, StreamingContext Context, ISurrogateSelector selector, out VARIANT pRetVal);
}

interface IFormatter : IDispatch {
  mixin(ууид("93d7a8c5-d2eb-319b-a374-a65d321f2aa9"));
  /*[id(0x60020000)]*/ int Deserialize(_Stream serializationStream, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int Serialize(_Stream serializationStream, VARIANT graph);
  /*[id(0x60020002)]*/ int get_SurrogateSelector(out ISurrogateSelector pRetVal);
  /*[id(0x60020002)]*/ int putref_SurrogateSelector(ISurrogateSelector pRetVal);
  /*[id(0x60020004)]*/ int get_Binder(out _SerializationBinder pRetVal);
  /*[id(0x60020004)]*/ int putref_Binder(_SerializationBinder pRetVal);
  /*[id(0x60020006)]*/ int get_Context(out StreamingContext pRetVal);
  /*[id(0x60020006)]*/ int put_Context(StreamingContext pRetVal);
}

interface ISurrogateSelector : IDispatch {
  mixin(ууид("7c66ff18-a1a5-3e19-857b-0e7b6a9e3f38"));
  /*[id(0x60020000)]*/ int ChainSelector(ISurrogateSelector selector);
  /*[id(0x60020001)]*/ int GetSurrogate(_Type Type, StreamingContext Context, out ISurrogateSelector selector, out ISerializationSurrogate pRetVal);
  /*[id(0x60020002)]*/ int GetNextSelector(out ISurrogateSelector pRetVal);
}

interface IResourceReader : IDispatch {
  mixin(ууид("8965a22f-fba8-36ad-8132-70bbd0da457d"));
  /*[id(0x60020000)]*/ int Close();
  /*[id(0x60020001)]*/ int GetEnumerator(out IDictionaryEnumerator pRetVal);
}

interface IResourceWriter : IDispatch {
  mixin(ууид("e97aa6e5-595e-31c3-82f0-688fb91954c6"));
  /*[id(0x60020000)]*/ int AddResource(wchar* name, wchar* value);
  /*[id(0x60020001)]*/ int AddResource_2(wchar* name, VARIANT value);
  /*[id(0x60020002)]*/ int AddResource_3(wchar* name,  SAFEARRAY value);
  /*[id(0x60020003)]*/ int Close();
  /*[id(0x60020004)]*/ int Generate();
}

interface ISecurityEncodable : IDispatch {
  mixin(ууид("fd46bde5-acdf-3ca5-b189-f0678387077f"));
  /*[id(0x60020000)]*/ int ToXml(out _SecurityElement pRetVal);
  /*[id(0x60020001)]*/ int FromXml(_SecurityElement e);
}

interface ISecurityPolicyEncodable : IDispatch {
  mixin(ууид("e6c21ba7-21bb-34e9-8e57-db66d8ce4a70"));
  /*[id(0x60020000)]*/ int ToXml(_PolicyLevel level, out _SecurityElement pRetVal);
  /*[id(0x60020001)]*/ int FromXml(_SecurityElement e, _PolicyLevel level);
}

interface IMembershipCondition : IDispatch {
  mixin(ууид("6844eff4-4f86-3ca1-a1ea-aaf583a6395e"));
  /*[id(0x60020000)]*/ int Check(_Evidence Evidence, out short pRetVal);
  /*[id(0x60020001)]*/ int Copy(out IMembershipCondition pRetVal);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int Equals(VARIANT объ, out short pRetVal);
}

interface IIdentityPermissionFactory : IDispatch {
  mixin(ууид("4e95244e-c6fc-3a86-8db7-1712454de3b6"));
  /*[id(0x60020000)]*/ int CreateIdentityPermission(_Evidence Evidence, out IPermission pRetVal);
}

interface IApplicationTrustManager : IDispatch {
  mixin(ууид("427e255d-af02-3b0d-8ce3-a2bb94ba300f"));
  /*[id(0x60020000)]*/ int DetermineApplicationTrust(IUnknown activationContext, _TrustManagerContext Context, out _ApplicationTrust pRetVal);
}

interface IIdentity : IDispatch {
  mixin(ууид("f4205a87-4d46-303d-b1d9-5a99f7c90d30"));
  /*[id(0x60020000)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int get_AuthenticationType(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int get_IsAuthenticated(out short pRetVal);
}

interface IPrincipal : IDispatch {
  mixin(ууид("4283ca6c-d291-3481-83c9-9554481fe888"));
  /*[id(0x60020000)]*/ int get_Identity(out IIdentity pRetVal);
  /*[id(0x60020001)]*/ int IsInRole(wchar* role, out short pRetVal);
}

interface ICustomMarshaler : IDispatch {
  mixin(ууид("601cd486-04bf-3213-9ea9-06ebe4351d74"));
  /*[id(0x60020000)]*/ int MarshalNativeToManaged(int pNativeData, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int MarshalManagedToNative(VARIANT ManagedObj, out int pRetVal);
  /*[id(0x60020002)]*/ int CleanUpNativeData(int pNativeData);
  /*[id(0x60020003)]*/ int CleanUpManagedData(VARIANT ManagedObj);
  /*[id(0x60020004)]*/ int GetNativeDataSize(out int pRetVal);
}

interface ITypeLibImporterNotifySink : IUnknown {
  mixin(ууид("f1c3bf76-c3e4-11d3-88e7-00902754c43a"));
  /*[id(0x60010000)]*/ int ReportEvent(ImporterEventKind eventKind, int eventCode, wchar* eventMsg);
  /*[id(0x60010001)]*/ int ResolveRef(IUnknown typeLib, out _Assembly pRetVal);
}

interface ICustomAdapter : IDispatch {
  mixin(ууид("3cc86595-feb5-3ce9-ba14-d05c8dc3321c"));
  /*[id(0x60020000)]*/ int GetUnderlyingObject(out IUnknown pRetVal);
}

interface ICustomFactory : IDispatch {
  mixin(ууид("0ca9008e-ee90-356e-9f6d-b59e6006b9a4"));
  /*[id(0x60020000)]*/ int CreateInstance(_Type serverType, out _MarshalByRefObject pRetVal);
}

interface IRegistrationServices : IDispatch {
  mixin(ууид("ccbd682c-73a5-4568-b8b0-c7007e11aba2"));
  /*[id(0x60020000)]*/ int RegisterAssembly(_Assembly Assembly, AssemblyRegistrationFlags flags, out short pRetVal);
  /*[id(0x60020001)]*/ int UnregisterAssembly(_Assembly Assembly, out short pRetVal);
  /*[id(0x60020002)]*/ int GetRegistrableTypesInAssembly(_Assembly Assembly,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020003)]*/ int GetProgIdForType(_Type Type, out wchar* pRetVal);
  /*[id(0x60020004)]*/ int RegisterTypeForComClients(_Type Type, ref GUID G);
  /*[id(0x60020005)]*/ int GetManagedCategoryGuid(out GUID pRetVal);
  /*[id(0x60020006)]*/ int TypeRequiresRegistration(_Type Type, out short pRetVal);
  /*[id(0x60020007)]*/ int TypeRepresentsComType(_Type Type, out short pRetVal);
}

interface ITypeLibExporterNotifySink : IUnknown {
  mixin(ууид("f1c3bf77-c3e4-11d3-88e7-00902754c43a"));
  /*[id(0x60010000)]*/ int ReportEvent(ExporterEventKind eventKind, int eventCode, wchar* eventMsg);
  /*[id(0x60010001)]*/ int ResolveRef(_Assembly Assembly, out IUnknown pRetVal);
}

interface ITypeLibConverter : IUnknown {
  mixin(ууид("f1c3bf78-c3e4-11d3-88e7-00902754c43a"));
  /*[id(0x60010000)]*/ int ConvertTypeLibToAssembly(IUnknown typeLib, wchar* asmFileName, TypeLibImporterFlags flags, ITypeLibImporterNotifySink notifySink,  SAFEARRAY publicKey, _StrongNameKeyPair keyPair, wchar* asmNamespace, _Version asmVersion, out _AssemblyBuilder pRetVal);
  /*[id(0x60010001)]*/ int ConvertAssemblyToTypeLib(_Assembly Assembly, wchar* typeLibName, TypeLibExporterFlags flags, ITypeLibExporterNotifySink notifySink, out IUnknown pRetVal);
  /*[id(0x60010002)]*/ int GetPrimaryInteropAssembly(GUID G, int major, int minor, int lcid, out wchar* asmName, out wchar* asmCodeBase, out short pRetVal);
  /*[id(0x60010003)]*/ int ConvertTypeLibToAssembly_2(IUnknown typeLib, wchar* asmFileName, int flags, ITypeLibImporterNotifySink notifySink,  SAFEARRAY publicKey, _StrongNameKeyPair keyPair, short unsafeInterfaces, out _AssemblyBuilder pRetVal);
}

interface ITypeLibExporterNameProvider : IUnknown {
  mixin(ууид("fa1f3615-acb9-486d-9eac-1bef87e36b09"));
  /*[id(0x60010000)]*/ int GetNames( out  SAFEARRAY  pRetVal);
}

interface IExpando : IDispatch {
  mixin(ууид("afbf15e6-c37c-11d2-b88e-00a0c9b471b8"));
  /*[id(0x60020000)]*/ int AddField(wchar* name, out _FieldInfo pRetVal);
  /*[id(0x60020001)]*/ int AddProperty(wchar* name, out _PropertyInfo pRetVal);
  /*[id(0x60020002)]*/ int AddMethod(wchar* name, _Delegate Method, out _MethodInfo pRetVal);
  /*[id(0x60020003)]*/ int RemoveMember(_MemberInfo m);
}

interface IPermission : IDispatch {
  mixin(ууид("a19b3fc6-d680-3dd4-a17a-f58a7d481494"));
  /*[id(0x60020000)]*/ int Copy(out IPermission pRetVal);
  /*[id(0x60020001)]*/ int Intersect(IPermission Target, out IPermission pRetVal);
  /*[id(0x60020002)]*/ int Union(IPermission Target, out IPermission pRetVal);
  /*[id(0x60020003)]*/ int IsSubsetOf(IPermission Target, out short pRetVal);
  /*[id(0x60020004)]*/ int Demand();
}

interface IStackWalk : IDispatch {
  mixin(ууид("60fc57b0-4a46-32a0-a5b4-b05b0de8e781"));
  /*[id(0x60020000)]*/ int Assert();
  /*[id(0x60020001)]*/ int Demand();
  /*[id(0x60020002)]*/ int Deny();
  /*[id(0x60020003)]*/ int PermitOnly();
}

interface IUnrestrictedPermission : IDispatch {
  mixin(ууид("0f1284e6-4399-3963-8ddd-a6a4904f66c8"));
  /*[id(0x60020000)]*/ int IsUnrestricted(out short pRetVal);
}

interface IContextAttribute : IDispatch {
  mixin(ууид("4a68baa3-27aa-314a-bdbb-6ae9bdfc0420"));
  /*[id(0x60020000)]*/ int IsContextOK(_Context конткст, IConstructionCallMessage msg, out short pRetVal);
  /*[id(0x60020001)]*/ int GetPropertiesForNewContext(IConstructionCallMessage msg);
}

interface IContextProperty : IDispatch {
  mixin(ууид("f01d896d-8d5f-3235-be59-20e1e10dc22a"));
  /*[id(0x60020000)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int IsNewContextOK(_Context newCtx, out short pRetVal);
  /*[id(0x60020002)]*/ int Freeze(_Context newContext);
}

interface IActivator : IDispatch {
  mixin(ууид("c02bbb79-5aa8-390d-927f-717b7bff06a1"));
  /*[id(0x60020000)]*/ int get_NextActivator(out IActivator pRetVal);
  /*[id(0x60020000)]*/ int putref_NextActivator(IActivator pRetVal);
  /*[id(0x60020002)]*/ int Activate(IConstructionCallMessage msg, out IConstructionReturnMessage pRetVal);
  /*[id(0x60020003)]*/ int get_level(out ActivatorLevel pRetVal);
}

interface IMessageSink : IDispatch {
  mixin(ууид("941f8aaa-a353-3b1d-a019-12e44377f1cd"));
  /*[id(0x60020000)]*/ int SyncProcessMessage(IMessage msg, out IMessage pRetVal);
  /*[id(0x60020001)]*/ int AsyncProcessMessage(IMessage msg, IMessageSink replySink, out IMessageCtrl pRetVal);
  /*[id(0x60020002)]*/ int get_NextSink(out IMessageSink pRetVal);
}

interface IClientResponseChannelSinkStack : IDispatch {
  mixin(ууид("3afab213-f5a2-3241-93ba-329ea4ba8016"));
  /*[id(0x60020000)]*/ int AsyncProcessResponse(ITransportHeaders headers, _Stream Stream);
  /*[id(0x60020001)]*/ int DispatchReplyMessage(IMessage msg);
  /*[id(0x60020002)]*/ int DispatchException(_Exception e);
}

interface IClientChannelSinkStack : IDispatch {
  mixin(ууид("3a5fde6b-db46-34e8-bacd-16ea5a440540"));
  /*[id(0x60020000)]*/ int Push(IClientChannelSink sink, VARIANT state);
  /*[id(0x60020001)]*/ int Pop(IClientChannelSink sink, out VARIANT pRetVal);
}

interface IServerResponseChannelSinkStack : IDispatch {
  mixin(ууид("9be679a6-61fd-38fc-a7b2-89982d33338b"));
  /*[id(0x60020000)]*/ int AsyncProcessResponse(IMessage msg, ITransportHeaders headers, _Stream Stream);
  /*[id(0x60020001)]*/ int GetResponseStream(IMessage msg, ITransportHeaders headers, out _Stream pRetVal);
}

interface IServerChannelSinkStack : IDispatch {
  mixin(ууид("e694a733-768d-314d-b317-dcead136b11d"));
  /*[id(0x60020000)]*/ int Push(IServerChannelSink sink, VARIANT state);
  /*[id(0x60020001)]*/ int Pop(IServerChannelSink sink, out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int Store(IServerChannelSink sink, VARIANT state);
  /*[id(0x60020003)]*/ int StoreAndDispatch(IServerChannelSink sink, VARIANT state);
  /*[id(0x60020004)]*/ int ServerCallback(IAsyncResult ar);
}

interface ISponsor : IDispatch {
  mixin(ууид("675591af-0508-3131-a7cc-287d265ca7d6"));
  /*[id(0x60020000)]*/ int Renewal(ILease lease, out TimeSpan pRetVal);
}

interface IContextPropertyActivator : IDispatch {
  mixin(ууид("7197b56b-5fa1-31ef-b38b-62fee737277f"));
  /*[id(0x60020000)]*/ int IsOKToActivate(IConstructionCallMessage msg, out short pRetVal);
  /*[id(0x60020001)]*/ int CollectFromClientContext(IConstructionCallMessage msg);
  /*[id(0x60020002)]*/ int DeliverClientContextToServerContext(IConstructionCallMessage msg, out short pRetVal);
  /*[id(0x60020003)]*/ int CollectFromServerContext(IConstructionReturnMessage msg);
  /*[id(0x60020004)]*/ int DeliverServerContextToClientContext(IConstructionReturnMessage msg, out short pRetVal);
}

interface IChannel : IDispatch {
  mixin(ууид("563581e8-c86d-39e2-b2e8-6c23f7987a4b"));
  /*[id(0x60020000)]*/ int get_ChannelPriority(out int pRetVal);
  /*[id(0x60020001)]*/ int get_ChannelName(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int Parse(wchar* Url, out wchar* objectURI, out wchar* pRetVal);
}

interface IChannelSender : IDispatch {
  mixin(ууид("10f1d605-e201-3145-b7ae-3ad746701986"));
  /*[id(0x60020000)]*/ int CreateMessageSink(wchar* Url, VARIANT remoteChannelData, out wchar* objectURI, out IMessageSink pRetVal);
}

interface IChannelReceiver : IDispatch {
  mixin(ууид("48ad41da-0872-31da-9887-f81f213527e6"));
  /*[id(0x60020000)]*/ int get_ChannelData(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int GetUrlsForUri(wchar* objectURI,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020002)]*/ int StartListening(VARIANT data);
  /*[id(0x60020003)]*/ int StopListening(VARIANT data);
}

interface IServerChannelSinkProvider : IDispatch {
  mixin(ууид("7dd6e975-24ea-323c-a98c-0fde96f9c4e6"));
  /*[id(0x60020000)]*/ int GetChannelData(IChannelDataStore ChannelData);
  /*[id(0x60020001)]*/ int CreateSink(IChannelReceiver channel, out IServerChannelSink pRetVal);
  /*[id(0x60020002)]*/ int get_Next(out IServerChannelSinkProvider pRetVal);
  /*[id(0x60020002)]*/ int putref_Next(IServerChannelSinkProvider pRetVal);
}

interface IChannelSinkBase : IDispatch {
  mixin(ууид("308de042-acc8-32f8-b632-7cb9799d9aa6"));
  /*[id(0x60020000)]*/ int get_Properties(out IDictionary pRetVal);
}

interface IServerChannelSink : IDispatch {
  mixin(ууид("21b5f37b-bef3-354c-8f84-0f9f0863f5c5"));
  /*[id(0x60020000)]*/ int ProcessMessage(IServerChannelSinkStack sinkStack, IMessage requestMsg, ITransportHeaders requestHeaders, _Stream requestStream, out IMessage responseMsg, out ITransportHeaders responseHeaders, out _Stream responseStream, out ServerProcessing pRetVal);
  /*[id(0x60020001)]*/ int AsyncProcessResponse(IServerResponseChannelSinkStack sinkStack, VARIANT state, IMessage msg, ITransportHeaders headers, _Stream Stream);
  /*[id(0x60020002)]*/ int GetResponseStream(IServerResponseChannelSinkStack sinkStack, VARIANT state, IMessage msg, ITransportHeaders headers, out _Stream pRetVal);
  /*[id(0x60020003)]*/ int get_NextChannelSink(out IServerChannelSink pRetVal);
}

interface IMessage : IDispatch {
  mixin(ууид("1a8b0de6-b825-38c5-b744-8f93075fd6fa"));
  /*[id(0x60020000)]*/ int get_Properties(out IDictionary pRetVal);
}

interface IMethodMessage : IDispatch {
  mixin(ууид("8e5e0b95-750e-310d-892c-8ca7231cf75b"));
  /*[id(0x60020000)]*/ int get_Uri(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int get_MethodName(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int get_typeName(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int get_MethodSignature(out VARIANT pRetVal);
  /*[id(0x60020004)]*/ int get_ArgCount(out int pRetVal);
  /*[id(0x60020005)]*/ int GetArgName(int index, out wchar* pRetVal);
  /*[id(0x60020006)]*/ int GetArg(int argNum, out VARIANT pRetVal);
  /*[id(0x60020007)]*/ int get_args( out  SAFEARRAY  pRetVal);
  /*[id(0x60020008)]*/ int get_HasVarArgs(out short pRetVal);
  /*[id(0x60020009)]*/ int get_LogicalCallContext(out _LogicalCallContext pRetVal);
  /*[id(0x6002000A)]*/ int get_MethodBase(out _MethodBase pRetVal);
}

interface IMethodCallMessage : IDispatch {
  mixin(ууид("b90efaa6-25e4-33d2-aca3-94bf74dc4ab9"));
  /*[id(0x60020000)]*/ int get_InArgCount(out int pRetVal);
  /*[id(0x60020001)]*/ int GetInArgName(int index, out wchar* pRetVal);
  /*[id(0x60020002)]*/ int GetInArg(int argNum, out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int get_InArgs( out  SAFEARRAY  pRetVal);
}

interface IConstructionCallMessage : IDispatch {
  mixin(ууид("fa28e3af-7d09-31d5-beeb-7f2626497cde"));
  /*[id(0x60020000)]*/ int get_Activator(out IActivator pRetVal);
  /*[id(0x60020000)]*/ int putref_Activator(IActivator pRetVal);
  /*[id(0x60020002)]*/ int get_CallSiteActivationAttributes( out  SAFEARRAY  pRetVal);
  /*[id(0x60020003)]*/ int get_ActivationTypeName(out wchar* pRetVal);
  /*[id(0x60020004)]*/ int get_ActivationType(out _Type pRetVal);
  /*[id(0x60020005)]*/ int get_ContextProperties(out IList pRetVal);
}

interface IMethodReturnMessage : IDispatch {
  mixin(ууид("f617690a-55f4-36af-9149-d199831f8594"));
  /*[id(0x60020000)]*/ int get_OutArgCount(out int pRetVal);
  /*[id(0x60020001)]*/ int GetOutArgName(int index, out wchar* pRetVal);
  /*[id(0x60020002)]*/ int GetOutArg(int argNum, out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int get_OutArgs( out  SAFEARRAY  pRetVal);
  /*[id(0x60020004)]*/ int get_Exception(out _Exception pRetVal);
  /*[id(0x60020005)]*/ int get_ReturnValue(out VARIANT pRetVal);
}

interface IConstructionReturnMessage : IDispatch {
  mixin(ууид("ca0ab564-f5e9-3a7f-a80b-eb0aeefa44e9"));
}

interface IChannelReceiverHook : IDispatch {
  mixin(ууид("3a02d3f7-3f40-3022-853d-cfda765182fe"));
  /*[id(0x60020000)]*/ int get_ChannelScheme(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int get_WantsToListen(out short pRetVal);
  /*[id(0x60020002)]*/ int get_ChannelSinkChain(out IServerChannelSink pRetVal);
  /*[id(0x60020003)]*/ int AddHookChannelUri(wchar* channelUri);
}

interface IClientChannelSinkProvider : IDispatch {
  mixin(ууид("3f8742c2-ac57-3440-a283-fe5ff4c75025"));
  /*[id(0x60020000)]*/ int CreateSink(IChannelSender channel, wchar* Url, VARIANT remoteChannelData, out IClientChannelSink pRetVal);
  /*[id(0x60020001)]*/ int get_Next(out IClientChannelSinkProvider pRetVal);
  /*[id(0x60020001)]*/ int putref_Next(IClientChannelSinkProvider pRetVal);
}

interface IClientFormatterSinkProvider : IDispatch {
  mixin(ууид("6d94b6f3-da91-3c2f-b876-083769667468"));
}

interface IServerFormatterSinkProvider : IDispatch {
  mixin(ууид("042b5200-4317-3e4d-b653-7e9a08f1a5f2"));
}

interface IClientChannelSink : IDispatch {
  mixin(ууид("ff726320-6b92-3e6c-aaac-f97063d0b142"));
  /*[id(0x60020000)]*/ int ProcessMessage(IMessage msg, ITransportHeaders requestHeaders, _Stream requestStream, out ITransportHeaders responseHeaders, out _Stream responseStream);
  /*[id(0x60020001)]*/ int AsyncProcessRequest(IClientChannelSinkStack sinkStack, IMessage msg, ITransportHeaders headers, _Stream Stream);
  /*[id(0x60020002)]*/ int AsyncProcessResponse(IClientResponseChannelSinkStack sinkStack, VARIANT state, ITransportHeaders headers, _Stream Stream);
  /*[id(0x60020003)]*/ int GetRequestStream(IMessage msg, ITransportHeaders headers, out _Stream pRetVal);
  /*[id(0x60020004)]*/ int get_NextChannelSink(out IClientChannelSink pRetVal);
}

interface IClientFormatterSink : IDispatch {
  mixin(ууид("46527c03-b144-3cf0-86b3-b8776148a6e9"));
}

interface IChannelDataStore : IDispatch {
  mixin(ууид("1e250ccd-dc30-3217-a7e4-148f375a0088"));
  /*[id(0x60020000)]*/ int get_ChannelUris( out  SAFEARRAY  pRetVal);
  /*[id(0x00000000)]*/ int get_Item(VARIANT key, out VARIANT pRetVal);
  /*[id(0x00000000)]*/ int putref_Item(VARIANT key, VARIANT pRetVal);
}

interface ITransportHeaders : IDispatch {
  mixin(ууид("1ac82fbe-4ff0-383c-bbfd-fe40ecb3628d"));
  /*[id(0x00000000)]*/ int get_Item(VARIANT key, out VARIANT pRetVal);
  /*[id(0x00000000)]*/ int putref_Item(VARIANT key, VARIANT pRetVal);
  /*[id(0xFFFFFFFC)]*/ int GetEnumerator(out IEnumVARIANT pRetVal);
}

interface IContributeClientContextSink : IDispatch {
  mixin(ууид("4db956b7-69d0-312a-aa75-44fb55fd5d4b"));
  /*[id(0x60020000)]*/ int GetClientContextSink(IMessageSink NextSink, out IMessageSink pRetVal);
}

interface IContributeDynamicSink : IDispatch {
  mixin(ууид("a0fe9b86-0c06-32ce-85fa-2ff1b58697fb"));
  /*[id(0x60020000)]*/ int GetDynamicSink(out IDynamicMessageSink pRetVal);
}

interface IContributeEnvoySink : IDispatch {
  mixin(ууид("124777b6-0308-3569-97e5-e6fe88eae4eb"));
  /*[id(0x60020000)]*/ int GetEnvoySink(_MarshalByRefObject объ, IMessageSink NextSink, out IMessageSink pRetVal);
}

interface IContributeObjectSink : IDispatch {
  mixin(ууид("6a5d38bc-2789-3546-81a1-f10c0fb59366"));
  /*[id(0x60020000)]*/ int GetObjectSink(_MarshalByRefObject объ, IMessageSink NextSink, out IMessageSink pRetVal);
}

interface IContributeServerContextSink : IDispatch {
  mixin(ууид("0caa23ec-f78c-39c9-8d25-b7a9ce4097a7"));
  /*[id(0x60020000)]*/ int GetServerContextSink(IMessageSink NextSink, out IMessageSink pRetVal);
}

interface IDynamicProperty : IDispatch {
  mixin(ууид("00a358d4-4d58-3b9d-8fb6-fb7f6bc1713b"));
  /*[id(0x60020000)]*/ int get_name(out wchar* pRetVal);
}

interface IDynamicMessageSink : IDispatch {
  mixin(ууид("c74076bb-8a2d-3c20-a542-625329e9af04"));
  /*[id(0x60020000)]*/ int ProcessMessageStart(IMessage reqMsg, short bCliSide, short bAsync);
  /*[id(0x60020001)]*/ int ProcessMessageFinish(IMessage replyMsg, short bCliSide, short bAsync);
}

interface ILease : IDispatch {
  mixin(ууид("53a561f2-cbbf-3748-bffe-2180002db3df"));
  /*[id(0x60020000)]*/ int Register(ISponsor объ, TimeSpan renewalTime);
  /*[id(0x60020001)]*/ int Register_2(ISponsor объ);
  /*[id(0x60020002)]*/ int Unregister(ISponsor объ);
  /*[id(0x60020003)]*/ int Renew(TimeSpan renewalTime, out TimeSpan pRetVal);
  /*[id(0x60020004)]*/ int get_RenewOnCallTime(out TimeSpan pRetVal);
  /*[id(0x60020004)]*/ int put_RenewOnCallTime(TimeSpan pRetVal);
  /*[id(0x60020006)]*/ int get_SponsorshipTimeout(out TimeSpan pRetVal);
  /*[id(0x60020006)]*/ int put_SponsorshipTimeout(TimeSpan pRetVal);
  /*[id(0x60020008)]*/ int get_InitialLeaseTime(out TimeSpan pRetVal);
  /*[id(0x60020008)]*/ int put_InitialLeaseTime(TimeSpan pRetVal);
  /*[id(0x6002000A)]*/ int get_CurrentLeaseTime(out TimeSpan pRetVal);
  /*[id(0x6002000B)]*/ int get_CurrentState(out LeaseState pRetVal);
}

interface IMessageCtrl : IDispatch {
  mixin(ууид("3677cbb0-784d-3c15-bbc8-75cd7dc3901e"));
  /*[id(0x60020000)]*/ int Cancel(int msToCancel);
}

interface IRemotingFormatter : IDispatch {
  mixin(ууид("ae1850fd-3596-3727-a242-2fc31c5a0312"));
  /*[id(0x60020000)]*/ int Deserialize(_Stream serializationStream, _HeaderHandler handler, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int Serialize(_Stream serializationStream, VARIANT graph,   SAFEARRAY headers);
}

interface IFieldInfo : IDispatch {
  mixin(ууид("cc18fd4d-aa2d-3ab4-9848-584bbae4ab44"));
  /*[id(0x60020000)]*/ int get_FieldNames( out  SAFEARRAY  pRetVal);
  /*[id(0x60020000)]*/ int put_FieldNames(  SAFEARRAY pRetVal);
  /*[id(0x60020002)]*/ int get_FieldTypes( out  SAFEARRAY  pRetVal);
  /*[id(0x60020002)]*/ int put_FieldTypes(  SAFEARRAY pRetVal);
}

interface IRemotingTypeInfo : IDispatch {
  mixin(ууид("c09effa9-1ffe-3a52-a733-6236cbc45e7b"));
  /*[id(0x60020000)]*/ int get_typeName(out wchar* pRetVal);
  /*[id(0x60020000)]*/ int put_typeName(wchar* pRetVal);
  /*[id(0x60020002)]*/ int CanCastTo(_Type fromType, VARIANT o, out short pRetVal);
}

interface IChannelInfo : IDispatch {
  mixin(ууид("855e6566-014a-3fe8-aa70-1eac771e3a88"));
  /*[id(0x60020000)]*/ int get_ChannelData( out  SAFEARRAY  pRetVal);
  /*[id(0x60020000)]*/ int put_ChannelData(  SAFEARRAY pRetVal);
}

interface IEnvoyInfo : IDispatch {
  mixin(ууид("2a6e91b9-a874-38e4-99c2-c5d83d78140d"));
  /*[id(0x60020000)]*/ int get_EnvoySinks(out IMessageSink pRetVal);
  /*[id(0x60020000)]*/ int putref_EnvoySinks(IMessageSink pRetVal);
}

interface ISoapXsd : IDispatch {
  mixin(ууид("80031d2a-ad59-3fb4-97f3-b864d71da86b"));
  /*[id(0x60020000)]*/ int GetXsdType(out wchar* pRetVal);
}

interface ITrackingHandler : IDispatch {
  mixin(ууид("03ec7d10-17a5-3585-9a2e-0596fcac3870"));
  /*[id(0x60020000)]*/ int MarshaledObject(VARIANT объ, _ObjRef or);
  /*[id(0x60020001)]*/ int UnmarshaledObject(VARIANT объ, _ObjRef or);
  /*[id(0x60020002)]*/ int DisconnectedObject(VARIANT объ);
}

interface ILogicalThreadAffinative : IDispatch {
  mixin(ууид("4d125449-ba27-3927-8589-3e1b34b622e5"));
}

interface INormalizeForIsolatedStorage : IDispatch {
  mixin(ууид("f5006531-d4d7-319e-9eda-9b4b65ad8d4f"));
  /*[id(0x60020000)]*/ int Normalize(out VARIANT pRetVal);
}

interface ISoapMessage : IDispatch {
  mixin(ууид("e699146c-7793-3455-9bef-964c90d8f995"));
  /*[id(0x60020000)]*/ int get_ParamNames( out  SAFEARRAY  pRetVal);
  /*[id(0x60020000)]*/ int put_ParamNames(  SAFEARRAY pRetVal);
  /*[id(0x60020002)]*/ int get_ParamValues( out  SAFEARRAY  pRetVal);
  /*[id(0x60020002)]*/ int put_ParamValues(  SAFEARRAY pRetVal);
  /*[id(0x60020004)]*/ int get_ParamTypes( out  SAFEARRAY  pRetVal);
  /*[id(0x60020004)]*/ int put_ParamTypes(  SAFEARRAY pRetVal);
  /*[id(0x60020006)]*/ int get_MethodName(out wchar* pRetVal);
  /*[id(0x60020006)]*/ int put_MethodName(wchar* pRetVal);
  /*[id(0x60020008)]*/ int get_XmlNameSpace(out wchar* pRetVal);
  /*[id(0x60020008)]*/ int put_XmlNameSpace(wchar* pRetVal);
  /*[id(0x6002000A)]*/ int get_headers( out  SAFEARRAY  pRetVal);
  /*[id(0x6002000A)]*/ int put_headers(  SAFEARRAY pRetVal);
}

interface _AssemblyBuilder : IUnknown {
  mixin(ууид("bebb2505-8b54-3443-aead-142a16dd9cc7"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _ConstructorBuilder : IUnknown {
  mixin(ууид("ed3e4384-d7e2-3fa7-8ffd-8940d330519a"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _CustomAttributeBuilder : IUnknown {
  mixin(ууид("be9acce8-aaff-3b91-81ae-8211663f5cad"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _EnumBuilder : IUnknown {
  mixin(ууид("c7bd73de-9f85-3290-88ee-090b8bdfe2df"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _EventBuilder : IUnknown {
  mixin(ууид("aadaba99-895d-3d65-9760-b1f12621fae8"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _FieldBuilder : IUnknown {
  mixin(ууид("ce1a3bf5-975e-30cc-97c9-1ef70f8f3993"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _ILGenerator : IUnknown {
  mixin(ууид("a4924b27-6e3b-37f7-9b83-a4501955e6a7"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _LocalBuilder : IUnknown {
  mixin(ууид("4e6350d1-a08b-3dec-9a3e-c465f9aeec0c"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _MethodBuilder : IUnknown {
  mixin(ууид("007d8a14-fdf3-363e-9a0b-fec0618260a2"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _MethodRental : IUnknown {
  mixin(ууид("c2323c25-f57f-3880-8a4d-12ebea7a5852"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _ModuleBuilder : IUnknown {
  mixin(ууид("d05ffa9a-04af-3519-8ee1-8d93ad73430b"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _ParameterBuilder : IUnknown {
  mixin(ууид("36329eba-f97a-3565-bc07-0ed5c6ef19fc"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _PropertyBuilder : IUnknown {
  mixin(ууид("15f9a479-9397-3a63-acbd-f51977fb0f02"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _SignatureHelper : IUnknown {
  mixin(ууид("7d13dd37-5a04-393c-bbca-a5fea802893d"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface _TypeBuilder : IUnknown {
  mixin(ууид("7e5678ee-48b3-3f83-b076-c58543498a58"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pcTInfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint iTInfo, uint lcid, int ppTInfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, int rgszNames, uint cNames, uint lcid, int rgDispId);
  /*[id(0x60010003)]*/ int Invoke(uint dispIdMember, ref GUID riid, uint lcid, short wFlags, int pDispParams, int pVarResult, int pExcepInfo, int puArgErr);
}

interface ICryptoTransform : IDispatch {
  mixin(ууид("8abad867-f515-3cf6-bb62-5f0c88b3bb11"));
  /*[id(0x60020000)]*/ int get_InputBlockSize(out int pRetVal);
  /*[id(0x60020001)]*/ int get_OutputBlockSize(out int pRetVal);
  /*[id(0x60020002)]*/ int get_CanTransformMultipleBlocks(out short pRetVal);
  /*[id(0x60020003)]*/ int get_CanReuseTransform(out short pRetVal);
  /*[id(0x60020004)]*/ int TransformBlock( SAFEARRAY inputBuffer, int inputOffset, int inputCount,  SAFEARRAY outputBuffer, int outputOffset, out int pRetVal);
  /*[id(0x60020005)]*/ int TransformFinalBlock( SAFEARRAY inputBuffer, int inputOffset, int inputCount,  out  SAFEARRAY  pRetVal);
}

interface ICspAsymmetricAlgorithm : IDispatch {
  mixin(ууид("494a7583-190e-3693-9ec4-de54dc6a84a2"));
  /*[id(0x60020000)]*/ int get_CspKeyContainerInfo(out _CspKeyContainerInfo pRetVal);
  /*[id(0x60020001)]*/ int ExportCspBlob(short includePrivateParameters,  out  SAFEARRAY  pRetVal);
  /*[id(0x60020002)]*/ int ImportCspBlob( SAFEARRAY rawData);
}

interface _Object : IDispatch {
  mixin(ууид("65074f7f-63c0-304e-af0a-d51741cb4a8d"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT объ, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
}

interface _ValueType : IDispatch {
  mixin(ууид("139e041d-0e41-39f5-a302-c4387e9d0a6c"));
}

interface _Enum : IDispatch {
  mixin(ууид("d09d1e04-d590-39a3-b517-b734a49a9277"));
}

interface _Delegate : IDispatch {
  mixin(ууид("fb6ab00f-5096-3af8-a33d-d7885a5fa829"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT объ, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int GetInvocationList( out  SAFEARRAY  pRetVal);
  /*[id(0x60020005)]*/ int Clone(out VARIANT pRetVal);
  /*[id(0x60020006)]*/ int GetObjectData(_SerializationInfo info, StreamingContext Context);
  /*[id(0x60020007)]*/ int DynamicInvoke(  SAFEARRAY  args, out VARIANT pRetVal);
  /*[id(0x60020008)]*/ int get_Method(out _MethodInfo pRetVal);
  /*[id(0x60020009)]*/ int get_Target(out VARIANT pRetVal);
}

interface _MulticastDelegate : IDispatch {
  mixin(ууид("16fe0885-9129-3884-a232-90b58c5b2aa9"));
}

interface _Array : IDispatch {
  mixin(ууид("2b67cece-71c3-36a9-a136-925ccc1935a8"));
}

interface _String : IDispatch {
  mixin(ууид("36936699-fc79-324d-ab43-e33c1f94e263"));
}

interface _StringComparer : IDispatch {
  mixin(ууид("7499e7e8-df01-3948-b8d4-fa4b9661d36b"));
}

interface _StringBuilder : IDispatch {
  mixin(ууид("9fb09782-8d39-3b0c-b79e-f7a37a65b3da"));
}

interface _SystemException : IDispatch {
  mixin(ууид("4c482cc2-68e9-37c6-8353-9a94bd2d7f0b"));
}

interface _OutOfMemoryException : IDispatch {
  mixin(ууид("cf3edb7e-0574-3383-a44f-292f7c145db4"));
}

interface _StackПереполнИскл : IDispatch {
  mixin(ууид("9cf4339a-2911-3b8a-8f30-e5c6b5be9a29"));
}

interface _DataMisalignedException : IDispatch {
  mixin(ууид("152a6b4d-09af-3edf-8cba-11797eeeea4e"));
}

interface _ExecutionEngineException : IDispatch {
  mixin(ууид("ccf0139c-79f7-3d0a-affe-2b0762c65b07"));
}

interface _MemberAccessException : IDispatch {
  mixin(ууид("7eaba4e2-1259-3cf2-b084-9854278e5897"));
}

interface _AccessViolationException : IDispatch {
  mixin(ууид("13ef674a-6327-3caf-8772-fa0395612669"));
}

interface _ApplicationActivator : IDispatch {
  mixin(ууид("d1204423-01f0-336a-8911-a7e8fbe185a3"));
}

interface _ApplicationException : IDispatch {
  mixin(ууид("d81130bf-d627-3b91-a7c7-cea597093464"));
}

interface _EventArgs : IDispatch {
  mixin(ууид("1f9ec719-343a-3cb3-8040-3927626777c1"));
}

interface _ResolveEventArgs : IDispatch {
  mixin(ууид("98947cf0-77e7-328e-b709-5dd1aa1c9c96"));
}

interface _AssemblyLoadEventArgs : IDispatch {
  mixin(ууид("7a0325f0-22c2-31f9-8823-9b8aee9456b1"));
}

interface _ResolveEventHandler : IDispatch {
  mixin(ууид("8e54a9cc-7aa4-34ca-985b-bd7d7527b110"));
}

interface _AssemblyLoadEventHandler : IDispatch {
  mixin(ууид("deece11f-a893-3e35-a4c3-dab7fa0911eb"));
}

interface _AppDomainInitializer : IDispatch {
  mixin(ууид("5e6f9edb-3ce1-3a56-86d9-cd2ddf7a6fff"));
}

interface _MarshalByRefObject : IDispatch {
  mixin(ууид("2c358e27-8c1a-3c03-b086-a40465625557"));
}

interface _CrossAppDomainDelegate : IDispatch {
  mixin(ууид("af93163f-c2f4-3fab-9ff1-728a7aaad1cb"));
}

interface _AppDomainManager : IDispatch {
  mixin(ууид("63e53e04-d31b-3099-9f0c-c7a1c883c1d9"));
}

interface _LoaderOptimizationAttribute : IDispatch {
  mixin(ууид("ce59d7ad-05ca-33b4-a1dd-06028d46e9d2"));
}

interface _AppDomainUnloadedException : IDispatch {
  mixin(ууид("6e96aa70-9ffb-399d-96bf-a68436095c54"));
}

interface _EvidenceBase : IDispatch {
  mixin(ууид("f4b8d231-6028-39ef-b017-72988a3f6766"));
}

interface _ActivationArguments : IDispatch {
  mixin(ууид("cfd9ca27-f0ba-388a-acde-b7e20fcad79c"));
}

interface _ApplicationId : IDispatch {
  mixin(ууид("2f218f95-4215-3cc6-8a51-bd2770c090e4"));
}

interface _АргИскл : IDispatch {
  mixin(ууид("4db2c2b7-cbc2-3185-b966-875d4625b1a8"));
}

interface _ПустойАргИскл : IDispatch {
  mixin(ууид("c991949b-e623-3f24-885c-bbb01ff43564"));
}

interface _АргВнеИскл : IDispatch {
  mixin(ууид("77da3028-bc45-3e82-bf76-2c123ee2c021"));
}

interface _МатИскл : IDispatch {
  mixin(ууид("9b012cf1-acf6-3389-a336-c023040c62a2"));
}

interface _ArrayTypeMismatchException : IDispatch {
  mixin(ууид("dd7488a6-1b3f-3823-9556-c2772b15150f"));
}

interface _AsyncCallback : IDispatch {
  mixin(ууид("3612706e-0239-35fd-b900-0819d16d442d"));
}

interface _AttributeUsageAttribute : IDispatch {
  mixin(ууид("a902a192-49ba-3ec8-b444-af5f7743f61a"));
}

interface _BadImageФорматИскл : IDispatch {
  mixin(ууид("f98bce04-4a4b-398c-a512-fd8348d51e3b"));
}

interface _Buffer : IDispatch {
  mixin(ууид("f036bca4-f8df-3682-8290-75285ce7456c"));
}

interface _CannotUnloadAppDomainException : IDispatch {
  mixin(ууид("6d4b6adb-b9fa-3809-b5ea-fa57b56c546f"));
}

interface _CharEnumerator : IDispatch {
  mixin(ууид("1dd627fc-89e3-384f-bb9d-58cb4efb9456"));
}

interface _CLSCompliantAttribute : IDispatch {
  mixin(ууид("bf1af177-94ca-3e6d-9d91-55cf9e859d22"));
}

interface _TypeUnloadedException : IDispatch {
  mixin(ууид("c2a10f3a-356a-3c77-aab9-8991d73a2561"));
}

interface _CriticalFinalizerObject : IDispatch {
  mixin(ууид("6b3f9834-1725-38c5-955e-20f051d067bd"));
}

interface _ContextMarshalException : IDispatch {
  mixin(ууид("7386f4d7-7c11-389f-bb75-895714b12bb5"));
}

interface _ContextBoundObject : IDispatch {
  mixin(ууид("3eb1d909-e8bf-3c6b-ada5-0e86e31e186e"));
}

interface _ContextStaticAttribute : IDispatch {
  mixin(ууид("160d517f-f175-3b61-8264-6d2305b8246c"));
}

interface _TimeZone : IDispatch {
  mixin(ууид("3025f666-7891-33d7-aacd-23d169ef354e"));
}

interface _DBNull : IDispatch {
  mixin(ууид("0d9f1b65-6d27-3e9f-baf3-0597837e0f33"));
}

interface _Binder : IDispatch {
  mixin(ууид("3169ab11-7109-3808-9a61-ef4ba0534fd9"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT объ, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int BindToMethod(BindingFlags bindingAttr,   SAFEARRAY  match, ref   SAFEARRAY  args,   SAFEARRAY  modifiers, _CultureInfo culture,   SAFEARRAY  names, out VARIANT state, out _MethodBase pRetVal);
  /*[id(0x60020005)]*/ int BindToField(BindingFlags bindingAttr,   SAFEARRAY  match, VARIANT value, _CultureInfo culture, out _FieldInfo pRetVal);
  /*[id(0x60020006)]*/ int SelectMethod(BindingFlags bindingAttr,   SAFEARRAY  match,   SAFEARRAY types,   SAFEARRAY  modifiers, out _MethodBase pRetVal);
  /*[id(0x60020007)]*/ int SelectProperty(BindingFlags bindingAttr,   SAFEARRAY  match, _Type returnType,   SAFEARRAY indexes,   SAFEARRAY  modifiers, out _PropertyInfo pRetVal);
  /*[id(0x60020008)]*/ int ChangeType(VARIANT value, _Type Type, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60020009)]*/ int ReorderArgumentArray(ref   SAFEARRAY  args, VARIANT state);
}

interface _DivideByZeroException : IDispatch {
  mixin(ууид("bdeea460-8241-3b41-9ed3-6e3e9977ac7f"));
}

interface _DuplicateWaitObjectException : IDispatch {
  mixin(ууид("d345a42b-cfe0-3eee-861c-f3322812b388"));
}

interface _TypeLoadException : IDispatch {
  mixin(ууид("82d6b3bf-a633-3b3b-a09e-2363e4b24a41"));
}

interface _EntryPointNotFoundException : IDispatch {
  mixin(ууид("67388f3f-b600-3bcf-84aa-bb2b88dd9ee2"));
}

interface _DllNotFoundException : IDispatch {
  mixin(ууид("24ae6464-2834-32cd-83d6-fa06953de62a"));
}

interface _Environment : IDispatch {
  mixin(ууид("29dc56cf-b981-3432-97c8-3680ab6d862d"));
}

interface _EventHandler : IDispatch {
  mixin(ууид("7cefc46e-16e0-3e65-9c38-55b4342ba7f0"));
}

interface _FieldAccessException : IDispatch {
  mixin(ууид("8d5f5811-ffa1-3306-93e3-8afc572b9b82"));
}

interface _FlagsAttribute : IDispatch {
  mixin(ууид("ebe3746d-ddec-3d23-8e8d-9361ba87bac6"));
}

interface _ФорматИскл : IDispatch {
  mixin(ууид("07f92156-398a-3548-90b7-2e58026353d0"));
}

interface _IndexOutOfRangeException : IDispatch {
  mixin(ууид("e5a5f1e4-82c1-391f-a1c6-f39eae9dc72f"));
}

interface _КастИскл : IDispatch {
  mixin(ууид("fa047cbd-9ba5-3a13-9b1f-6694d622cd76"));
}

interface _ОпИскл : IDispatch {
  mixin(ууид("8d520d10-0b8a-3553-8874-d30a4ad2ff4c"));
}

interface _InvalidProgramException : IDispatch {
  mixin(ууид("3410e0fb-636f-3cd1-8045-3993ca113f25"));
}

interface _LocalDataStoreSlot : IDispatch {
  mixin(ууид("dc77f976-318d-3a1a-9b60-abb9dd9406d6"));
}

interface _MethodAccessException : IDispatch {
  mixin(ууид("ff0bf77d-8f81-3d31-a3bb-6f54440fa7e5"));
}

interface _MissingMemberException : IDispatch {
  mixin(ууид("8897d14b-7fb3-3d8b-9ee4-221c3dbad6fe"));
}

interface _MissingFieldException : IDispatch {
  mixin(ууид("9717176d-1179-3487-8849-cf5f63de356e"));
}

interface _MissingMethodException : IDispatch {
  mixin(ууид("e5c659f6-92c8-3887-a07e-74d0d9c6267a"));
}

interface _MulticastНеПоддерживаетсяИскл : IDispatch {
  mixin(ууид("d2ba71cc-1b3d-3966-a0d7-c61e957ad325"));
}

interface _NonSerializedAttribute : IDispatch {
  mixin(ууид("665c9669-b9c6-3add-9213-099f0127c893"));
}

interface _NotFiniteNumberException : IDispatch {
  mixin(ууид("8e21ce22-4f17-347b-b3b5-6a6df3e0e58a"));
}

interface _NotImplementedException : IDispatch {
  mixin(ууид("1e4d31a2-63ea-397a-a77e-b20ad87a9614"));
}

interface _НеПоддерживаетсяИскл : IDispatch {
  mixin(ууид("40e5451f-b237-33f8-945b-0230db700bbb"));
}

interface _НулСсылкаИскл : IDispatch {
  mixin(ууид("ecbe2313-cf41-34b4-9fd0-b6cd602b023f"));
}

interface _ObjectDisposedException : IDispatch {
  mixin(ууид("17b730ba-45ef-3ddf-9f8d-a490bac731f4"));
}

interface _ObsoleteAttribute : IDispatch {
  mixin(ууид("e84307be-3036-307a-acc2-5d5de8a006a8"));
}

interface _OperatingSystem : IDispatch {
  mixin(ууид("9e230640-a5d0-30e1-b217-9d2b6cc0fc40"));
}

interface _OperationCanceledException : IDispatch {
  mixin(ууид("9df9af5a-7853-3d55-9b48-bd1f5d8367ab"));
}

interface _ПереполнИскл : IDispatch {
  mixin(ууид("37c69a5d-7619-3a0f-a96b-9c9578ae00ef"));
}

interface _ParamArrayAttribute : IDispatch {
  mixin(ууид("d54500ae-8cf4-3092-9054-90dc91ac65c9"));
}

interface _PlatformНеПоддерживаетсяИскл : IDispatch {
  mixin(ууид("1eb8340b-8190-3d9d-92f8-51244b9804c5"));
}

interface _Random : IDispatch {
  mixin(ууид("0f240708-629a-31ab-94a5-2bb476fe1783"));
}

interface _RankException : IDispatch {
  mixin(ууид("871ddc46-b68e-3fee-a09a-c808b0f827e6"));
}

interface _SerializableAttribute : IDispatch {
  mixin(ууид("1b96e53c-4028-38bc-9dc3-8d7a9555c311"));
}

interface _STAThreadAttribute : IDispatch {
  mixin(ууид("85d72f83-be91-3cb1-b4f0-76b56ff04033"));
}

interface _MTAThreadAttribute : IDispatch {
  mixin(ууид("c02468d1-8713-3225-bda3-49b2fe37ddbb"));
}

interface _TimeoutException : IDispatch {
  mixin(ууид("7ab88ca9-17f4-385e-ad41-4ee0aa316fa1"));
}

interface _TypeInitializationException : IDispatch {
  mixin(ууид("feb0323d-8ce4-36a4-a41e-0ba0c32e1a6a"));
}

interface _ВзломИскл : IDispatch {
  mixin(ууид("6193c5f6-6807-3561-a7f3-b64c80b5f00f"));
}

interface _UnhandledExceptionEventArgs : IDispatch {
  mixin(ууид("a218e20a-0905-3741-b0b3-9e3193162e50"));
}

interface _UnhandledExceptionEventHandler : IDispatch {
  mixin(ууид("84199e64-439c-3011-b249-3c9065735adb"));
}

interface _Version : IDispatch {
  mixin(ууид("011a90c5-4910-3c29-bbb7-50d05ccbaa4a"));
}

interface _WeakReference : IDispatch {
  mixin(ууид("c5df3568-c251-3c58-afb4-32e79e8261f0"));
}

interface _WaitHandle : IDispatch {
  mixin(ууид("40dfc50a-e93a-3c08-b9ef-e2b4f28b5676"));
}

interface _EventWaitHandle : IDispatch {
  mixin(ууид("e142db4a-1a52-34ce-965e-13affd5447d0"));
}

interface _AutoResetEvent : IDispatch {
  mixin(ууид("3f243ebd-612f-3db8-9e03-bd92343a8371"));
}

interface _ContextCallback : IDispatch {
  mixin(ууид("56d201f1-3e5d-39d9-b5de-064710818905"));
}

interface _ManualResetEvent : IDispatch {
  mixin(ууид("c0bb9361-268f-3e72-bf6f-4120175a1500"));
}

interface _Monitor : IDispatch {
  mixin(ууид("ee22485e-4c45-3c9d-9027-a8d61c5f53f2"));
}

interface _Mutex : IDispatch {
  mixin(ууид("36cb559b-87c6-3ad2-9225-62a7ed499b37"));
}

interface _Overlapped : IDispatch {
  mixin(ууид("dd846fcc-8d04-3665-81b6-aacbe99c19c3"));
}

interface _ReaderWriterLock : IDispatch {
  mixin(ууид("ad89b568-4fd4-3f8d-8327-b396b20a460e"));
}

interface _SynchronizationLockException : IDispatch {
  mixin(ууид("87f55344-17e0-30fd-8eb9-38eaf6a19b3f"));
}

interface _ThreadAbortException : IDispatch {
  mixin(ууид("95b525db-6b81-3cdc-8fe7-713f7fc793c0"));
}

interface _ThreadInterruptedException : IDispatch {
  mixin(ууид("b9e07599-7c44-33be-a70e-efa16f51f54a"));
}

interface _RegisteredWaitHandle : IDispatch {
  mixin(ууид("64409425-f8c9-370e-809e-3241ce804541"));
}

interface _WaitCallback : IDispatch {
  mixin(ууид("ce949142-4d4c-358d-89a9-e69a531aa363"));
}

interface _WaitOrTimerCallback : IDispatch {
  mixin(ууид("f078f795-f452-3d2d-8cc8-16d66ae46c67"));
}

interface _IOCompletionCallback : IDispatch {
  mixin(ууид("bbae942d-bff4-36e2-a3bc-508bb3801f4f"));
}

interface _ThreadStart : IDispatch {
  mixin(ууид("b45bbd7e-a977-3f56-a626-7a693e5dbbc5"));
}

interface _ThreadStateException : IDispatch {
  mixin(ууид("a13a41cf-e066-3b90-82f4-73109104e348"));
}

interface _ThreadStaticAttribute : IDispatch {
  mixin(ууид("a6b94b6d-854e-3172-a4ec-a17edd16f85e"));
}

interface _Timeout : IDispatch {
  mixin(ууид("81456e86-22af-31d1-a91a-9c370c0e2530"));
}

interface _TimerCallback : IDispatch {
  mixin(ууид("3741bc6f-101b-36d7-a9d5-03fcc0ecda35"));
}

interface _Timer : IDispatch {
  mixin(ууид("b49a029b-406b-3b1e-88e4-f86690d20364"));
}

interface _CaseInsensitiveComparer : IDispatch {
  mixin(ууид("ea6795ac-97d6-3377-be64-829abd67607b"));
}

interface _CaseInsensitiveHashCodeProvider : IDispatch {
  mixin(ууид("0422b845-b636-3688-8f61-9b6d93096336"));
}

interface _CollectionBase : IDispatch {
  mixin(ууид("b7d29e26-7798-3fa4-90f4-e6a22d2099f9"));
}

interface _DictionaryBase : IDispatch {
  mixin(ууид("ddd44da2-bc6b-3620-9317-c0372968c741"));
}

interface _ReadOnlyCollectionBase : IDispatch {
  mixin(ууид("bd32d878-a59b-3e5c-bfe0-a96b1a1e9d6f"));
}

interface _Queue : IDispatch {
  mixin(ууид("3a7d3ca4-b7d1-3a2a-800c-8fc2acfcbda4"));
}

interface _ArrayList : IDispatch {
  mixin(ууид("401f89cb-c127-3041-82fd-b67035395c56"));
}

interface _BitArray : IDispatch {
  mixin(ууид("f145c46a-d170-3170-b52f-4678dfca0300"));
}

interface _Stack : IDispatch {
  mixin(ууид("ab538809-3c2f-35d9-80e6-7bad540484a1"));
}

interface _Comparer : IDispatch {
  mixin(ууид("8064a157-b5c8-3a4a-ad3d-02dc1a39c417"));
}

interface _Hashtable : IDispatch {
  mixin(ууид("d25a197e-3e69-3271-a989-23d85e97f920"));
}

interface _SortedList : IDispatch {
  mixin(ууид("56421139-a143-3ae9-9852-1dbdfe3d6bfa"));
}

interface _Nullable : IDispatch {
  mixin(ууид("84e7ac09-795a-3ea9-a36a-5b81ebab0558"));
}

interface _KeyNotFoundException : IDispatch {
  mixin(ууид("8039c41f-4399-38a2-99b7-d234b5cf7a7b"));
}

interface _ConditionalAttribute : IDispatch {
  mixin(ууид("e40a025c-645b-3c8e-a1ac-9c5cca279625"));
}

interface _Debugger : IDispatch {
  mixin(ууид("a9b4786c-08e3-344f-a651-2f9926deac5e"));
}

interface _DebuggerStepThroughAttribute : IDispatch {
  mixin(ууид("3344e8b4-a5c3-3882-8d30-63792485eccf"));
}

interface _DebuggerStepperBoundaryAttribute : IDispatch {
  mixin(ууид("b3276180-b23e-3034-b18f-e0122ba4e4cf"));
}

interface _DebuggerHiddenAttribute : IDispatch {
  mixin(ууид("55b6903b-55fe-35e0-804f-e42a096d2eb0"));
}

interface _DebuggerNonUserCodeAttribute : IDispatch {
  mixin(ууид("cc6dcafd-0185-308a-891c-83812fe574e7"));
}

interface _DebuggableAttribute : IDispatch {
  mixin(ууид("428e3627-2b1f-302c-a7e6-6388cd535e75"));
}

interface _DebuggerBrowsableAttribute : IDispatch {
  mixin(ууид("a3fc6319-7355-3d7d-8621-b598561152fc"));
}

interface _DebuggerTypeProxyAttribute : IDispatch {
  mixin(ууид("404fafdd-1e3f-3602-bff6-755c00613ed8"));
}

interface _DebuggerDisplayAttribute : IDispatch {
  mixin(ууид("22fdabc0-eec7-33e0-b4f2-f3b739e19a5e"));
}

interface _DebuggerVisualizerAttribute : IDispatch {
  mixin(ууид("e19ea1a2-67ff-31a5-b95c-e0b753403f6b"));
}

interface _StackTrace : IDispatch {
  mixin(ууид("9a2669ec-ff84-3726-89a0-663a3ef3b5cd"));
}

interface _StackFrame : IDispatch {
  mixin(ууид("0e9b8e47-ca67-38b6-b9db-2c42ee757b08"));
}

interface _SymDocumentType : IDispatch {
  mixin(ууид("5141d79c-7b01-37da-b7e9-53e5a271baf8"));
}

interface _SymLanguageType : IDispatch {
  mixin(ууид("22bb8891-fd21-313d-92e4-8a892dc0b39c"));
}

interface _SymLanguageVendor : IDispatch {
  mixin(ууид("01364e7b-c983-3651-b7d8-fd1b64fc0e00"));
}

interface _AmbiguousMatchException : IDispatch {
  mixin(ууид("81aa0d59-c3b1-36a3-b2e7-054928fbfc1a"));
}

interface _ModuleResolveEventHandler : IDispatch {
  mixin(ууид("05532e88-e0f2-3263-9b57-805ac6b6bb72"));
}

interface _AssemblyCopyrightAttribute : IDispatch {
  mixin(ууид("6163f792-3cd6-38f1-b5f7-000b96a5082b"));
}

interface _AssemblyTrademarkAttribute : IDispatch {
  mixin(ууид("64c26bf9-c9e5-3f66-ad74-bebaade36214"));
}

interface _AssemblyProductAttribute : IDispatch {
  mixin(ууид("de10d587-a188-3dcb-8000-92dfdb9b8021"));
}

interface _AssemblyCompanyAttribute : IDispatch {
  mixin(ууид("c6802233-ef82-3c91-ad72-b3a5d7230ed5"));
}

interface _AssemblyDescriptionAttribute : IDispatch {
  mixin(ууид("6b2c0bc4-ddb7-38ea-8a86-f0b59e192816"));
}

interface _AssemblyTitleAttribute : IDispatch {
  mixin(ууид("df44cad3-cef2-36a9-b013-383cc03177d7"));
}

interface _AssemblyConfigurationAttribute : IDispatch {
  mixin(ууид("746d1d1e-ee37-393b-b6fa-e387d37553aa"));
}

interface _AssemblyDefaultAliasAttribute : IDispatch {
  mixin(ууид("04311d35-75ec-347b-bedf-969487ce4014"));
}

interface _AssemblyInformationalVersionAttribute : IDispatch {
  mixin(ууид("c6f5946c-143a-3747-a7c0-abfada6bdeb7"));
}

interface _AssemblyFileVersionAttribute : IDispatch {
  mixin(ууид("b101fe3c-4479-311a-a945-1225ee1731e8"));
}

interface _AssemblyCultureAttribute : IDispatch {
  mixin(ууид("177c4e63-9e0b-354d-838b-b52aa8683ef6"));
}

interface _AssemblyVersionAttribute : IDispatch {
  mixin(ууид("a1693c5c-101f-3557-94db-c480ceb4c16b"));
}

interface _AssemblyKeyFileAttribute : IDispatch {
  mixin(ууид("a9fcda18-c237-3c6f-a6ef-749be22ba2bf"));
}

interface _AssemblyDelaySignAttribute : IDispatch {
  mixin(ууид("6cf1c077-c974-38e1-90a4-976e4835e165"));
}

interface _AssemblyAlgorithmIdAttribute : IDispatch {
  mixin(ууид("57b849aa-d8ef-3ea6-9538-c5b4d498c2f7"));
}

interface _AssemblyFlagsAttribute : IDispatch {
  mixin(ууид("0ecd8635-f5eb-3e4a-8989-4d684d67c48a"));
}

interface _AssemblyKeyNameAttribute : IDispatch {
  mixin(ууид("322a304d-11ac-3814-a905-a019f6e3dae9"));
}

interface _AssemblyNameProxy : IDispatch {
  mixin(ууид("fe52f19a-8aa8-309c-bf99-9d0a566fb76a"));
}

interface _CustomAttributeФорматИскл : IDispatch {
  mixin(ууид("1660eb67-ee41-363e-beb0-c2de09214abf"));
}

interface _CustomAttributeData : IDispatch {
  mixin(ууид("f4e5539d-0a65-3073-bf27-8dce8ef1def1"));
}

interface _DefaultMemberAttribute : IDispatch {
  mixin(ууид("c462b072-fe6e-3bdc-9fab-4cdbfcbcd124"));
}

interface _InvalidFilterCriteriaException : IDispatch {
  mixin(ууид("e6df0ae7-ba15-3f80-8afa-27773ae414fc"));
}

interface _ManifestResourceInfo : IDispatch {
  mixin(ууид("3188878c-deb3-3558-80e8-84e9ed95f92c"));
}

interface _MemberFilter : IDispatch {
  mixin(ууид("fae5d9b7-40c1-3de1-be06-a91c9da1ba9f"));
}

interface _Missing : IDispatch {
  mixin(ууид("0c48f55d-5240-30c7-a8f1-af87a640cefe"));
}

interface _ObfuscateAssemblyAttribute : IDispatch {
  mixin(ууид("8a5f0da2-7b43-3767-b623-2424cf7cd268"));
}

interface _ObfuscationAttribute : IDispatch {
  mixin(ууид("71fb8dcf-3fa7-3483-8464-9d8200e57c43"));
}

interface _ExceptionHandlingClause : IDispatch {
  mixin(ууид("643a4016-1b16-3ccf-ae86-9c2d9135ecb0"));
}

interface _MethodBody : IDispatch {
  mixin(ууид("b072efe2-c943-3977-bfd9-91d5232b0d53"));
}

interface _LocalVariableInfo : IDispatch {
  mixin(ууид("f2ecd8ca-91a2-31e8-b808-e028b4f5ca67"));
}

interface _Pointer : IDispatch {
  mixin(ууид("f0deafe9-5eba-3737-9950-c1795739cdcd"));
}

interface _ReflectionTypeLoadException : IDispatch {
  mixin(ууид("22c26a41-5fa3-34e3-a76f-ba480252d8ec"));
}

interface _StrongNameKeyPair : IDispatch {
  mixin(ууид("fc4963cb-e52b-32d8-a418-d058fa51a1fa"));
}

interface _TargetException : IDispatch {
  mixin(ууид("98b1524d-da12-3c4b-8a69-7539a6dec4fa"));
}

interface _TargetInvocationException : IDispatch {
  mixin(ууид("a90106ed-9099-3329-8a5a-2044b3d8552b"));
}

interface _TargetParameterCountException : IDispatch {
  mixin(ууид("6032b3cd-9bed-351c-a145-9d500b0f636f"));
}

interface _TypeDelegator : IDispatch {
  mixin(ууид("34e00ef9-83e2-3bbc-b6af-4cae703838bd"));
}

interface _TypeFilter : IDispatch {
  mixin(ууид("e1817846-3745-3c97-b4a6-ee20a1641b29"));
}

interface _FormatterConverter : IDispatch {
  mixin(ууид("3faa35ee-c867-3e2e-bf48-2da271f88303"));
}

interface _FormatterServices : IDispatch {
  mixin(ууид("f859954a-78cf-3d00-86ab-ef661e6a4b8d"));
}

interface _OptionalFieldAttribute : IDispatch {
  mixin(ууид("feca70d4-ae27-3d94-93dd-a90f02e299d5"));
}

interface _OnSerializingAttribute : IDispatch {
  mixin(ууид("9ec28d2c-04c0-35f3-a7ee-0013271ff65e"));
}

interface _OnSerializedAttribute : IDispatch {
  mixin(ууид("547bf8cd-f2a8-3b41-966d-98db33ded06d"));
}

interface _OnDeserializingAttribute : IDispatch {
  mixin(ууид("f5aef88f-9ac4-320c-95d2-88e863a35762"));
}

interface _OnDeserializedAttribute : IDispatch {
  mixin(ууид("dd36c803-73d1-338d-88ba-dc9eb7620ef7"));
}

interface _SerializationBinder : IDispatch {
  mixin(ууид("450222d0-87ca-3699-a7b4-d8a0fdb72357"));
}

interface _SerializationException : IDispatch {
  mixin(ууид("245fe7fd-e020-3053-b5f6-7467fd2c6883"));
}

interface _SerializationInfo : IDispatch {
  mixin(ууид("b58d62cf-b03a-3a14-b0b6-b1e5ad4e4ad5"));
}

interface _SerializationInfoEnumerator : IDispatch {
  mixin(ууид("607056c6-1bca-36c8-ab87-33b202ebf0d8"));
}

interface _Formatter : IDispatch {
  mixin(ууид("d9bd3c8d-9395-3657-b6ee-d1b509c38b70"));
}

interface _ObjectIDGenerator : IDispatch {
  mixin(ууид("a30646cc-f710-3bfa-a356-b4c858d4ed8e"));
}

interface _ObjectManager : IDispatch {
  mixin(ууид("f28e7d04-3319-3968-8201-c6e55becd3d4"));
}

interface _SurrogateSelector : IDispatch {
  mixin(ууид("6de1230e-1f52-3779-9619-f5184103466c"));
}

interface _Calendar : IDispatch {
  mixin(ууид("4cca29e4-584b-3cd0-ad25-855dc5799c16"));
}

interface _CompareInfo : IDispatch {
  mixin(ууид("505defe5-aefa-3e23-82b0-d5eb085bb840"));
}

interface _CultureInfo : IDispatch {
  mixin(ууид("152722c2-f0b1-3d19-ada8-f40ca5caecb8"));
}

interface _CultureNotFoundException : IDispatch {
  mixin(ууид("ab20bf9e-7549-3226-ba87-c1edfb6cda6c"));
}

interface _DateTimeFormatInfo : IDispatch {
  mixin(ууид("015e9f67-337c-398a-a0c1-da4af1905571"));
}

interface _DaylightTime : IDispatch {
  mixin(ууид("efea8feb-ee7f-3e48-8a36-6206a6acbf73"));
}

interface _GregorianCalendar : IDispatch {
  mixin(ууид("677ad8b5-8a0e-3c39-92fb-72fb817cf694"));
}

interface _HebrewCalendar : IDispatch {
  mixin(ууид("96a62d6c-72a9-387a-81fa-e6dd5998caee"));
}

interface _HijriCalendar : IDispatch {
  mixin(ууид("28ddc187-56b2-34cf-a078-48bd1e113d1e"));
}

interface _EastAsianLunisolarCalendar : IDispatch {
  mixin(ууид("89e148c4-2424-30ae-80f5-c5d21ea3366c"));
}

interface _JulianCalendar : IDispatch {
  mixin(ууид("36e2de92-1fb3-3d7d-ba26-9cad5b98dd52"));
}

interface _JapaneseCalendar : IDispatch {
  mixin(ууид("d662ae3f-cef9-38b4-bb8e-5d8dd1dbf806"));
}

interface _KoreanCalendar : IDispatch {
  mixin(ууид("48bea6c4-752e-3974-8ca8-cfb6274e2379"));
}

interface _RegionInfo : IDispatch {
  mixin(ууид("f9e97e04-4e1e-368f-b6c6-5e96ce4362d6"));
}

interface _SortKey : IDispatch {
  mixin(ууид("f4c70e15-2ca6-3e90-96ed-92e28491f538"));
}

interface _StringInfo : IDispatch {
  mixin(ууид("0a25141f-51b3-3121-aa30-0af4556a52d9"));
}

interface _TaiwanCalendar : IDispatch {
  mixin(ууид("0c08ed74-0acf-32a9-99df-09a9dc4786dd"));
}

interface _TextElementEnumerator : IDispatch {
  mixin(ууид("8c248251-3e6c-3151-9f8e-a255fb8d2b12"));
}

interface _TextInfo : IDispatch {
  mixin(ууид("db8de23f-f264-39ac-b61c-cc1e7eb4a5e6"));
}

interface _ThaiBuddhistCalendar : IDispatch {
  mixin(ууид("c70c8ae8-925b-37ce-8944-34f15ff94307"));
}

interface _NumberFormatInfo : IDispatch {
  mixin(ууид("25e47d71-20dd-31be-b261-7ae76497d6b9"));
}

interface _Encoding : IDispatch {
  mixin(ууид("ddedb94d-4f3f-35c1-97c9-3f1d87628d9e"));
}

interface _Encoder : IDispatch {
  mixin(ууид("8fd56502-8724-3df0-a1b5-9d0e8d4e4f78"));
}

interface _Decoder : IDispatch {
  mixin(ууид("2adb0d4a-5976-38e4-852b-c131797430f5"));
}

interface _ASCIIEncoding : IDispatch {
  mixin(ууид("0cbe0204-12a1-3d40-9d9e-195de6aaa534"));
}

interface _UnicodeEncoding : IDispatch {
  mixin(ууид("f7dd3b7f-2b05-3894-8eda-59cdf9395b6a"));
}

interface _UTF7Encoding : IDispatch {
  mixin(ууид("89b9f00b-aa2a-3a49-91b4-e8d1f1c00e58"));
}

interface _UTF8Encoding : IDispatch {
  mixin(ууид("010fc1d0-3ef9-3f3b-aa0a-b78a1ff83a37"));
}

interface _MissingManifestResourceException : IDispatch {
  mixin(ууид("1a4e1878-fe8c-3f59-b6a9-21ab82be57e9"));
}

interface _MissingSatelliteAssemblyException : IDispatch {
  mixin(ууид("5a8de087-d9d7-3bba-92b4-fe1034a1242f"));
}

interface _NeutralResourcesLanguageAttribute : IDispatch {
  mixin(ууид("f48df808-8b7d-3f4e-9159-1dfd60f298d6"));
}

interface _ResourceManager : IDispatch {
  mixin(ууид("4de671b7-7c85-37e9-aff8-1222abe4883e"));
}

interface _ResourceReader : IDispatch {
  mixin(ууид("7fbcfdc7-5cec-3945-8095-daed61be5fb1"));
}

interface _ResourceSet : IDispatch {
  mixin(ууид("44d5f81a-727c-35ae-8df8-9ff6722f1c6c"));
}

interface _ResourceWriter : IDispatch {
  mixin(ууид("af170258-aac6-3a86-bd34-303e62ced10e"));
}

interface _SatelliteContractVersionAttribute : IDispatch {
  mixin(ууид("5cbb1f47-fba5-33b9-9d4a-57d6e3d133d2"));
}

interface _Registry : IDispatch {
  mixin(ууид("23bae0c0-3a36-32f0-9dad-0e95add67d23"));
}

interface _RegistryKey : IDispatch {
  mixin(ууид("2eac6733-8d92-31d9-be04-dc467efc3eb1"));
}

interface _AllMembershipCondition : IDispatch {
  mixin(ууид("99f01720-3cc2-366d-9ab9-50e36647617f"));
}

interface _ApplicationDirectory : IDispatch {
  mixin(ууид("9ccc831b-1ba7-34be-a966-56d5a6db5aad"));
}

interface _ApplicationDirectoryMembershipCondition : IDispatch {
  mixin(ууид("a02a2b22-1dba-3f92-9f84-5563182851bb"));
}

interface _ApplicationSecurityInfo : IDispatch {
  mixin(ууид("18e473f6-637b-3c01-8d46-d011aad26c95"));
}

interface _ApplicationSecurityManager : IDispatch {
  mixin(ууид("c664fe09-0a55-316d-b25b-6b3200ecaf70"));
}

interface _ApplicationTrust : IDispatch {
  mixin(ууид("e66a9755-58e2-3fcb-a265-835851cbf063"));
}

interface _ApplicationTrustCollection : IDispatch {
  mixin(ууид("bb03c920-1c05-3ecb-982d-53324d5ac9ff"));
}

interface _ApplicationTrustEnumerator : IDispatch {
  mixin(ууид("01afd447-60ca-3b67-803a-e57b727f3a5b"));
}

interface _CodeGroup : IDispatch {
  mixin(ууид("d7093f61-ed6b-343f-b1e9-02472fcc710e"));
}

interface _Evidence : IDispatch {
  mixin(ууид("a505edbc-380e-3b23-9e1a-0974d4ef02ef"));
}

interface _FileCodeGroup : IDispatch {
  mixin(ууид("dfad74dc-8390-32f6-9612-1bd293b233f4"));
}

interface _FirstMatchCodeGroup : IDispatch {
  mixin(ууид("54b0afb1-e7d3-3770-bb0e-75a95e8d2656"));
}

interface _TrustManagerContext : IDispatch {
  mixin(ууид("d89eac5e-0331-3fcd-9c16-4f1ed3fe1be2"));
}

interface _CodeConnectAccess : IDispatch {
  mixin(ууид("fe8a2546-3478-3fad-be1d-da7bc25c4e4e"));
}

interface _NetCodeGroup : IDispatch {
  mixin(ууид("a8f69eca-8c48-3b5e-92a1-654925058059"));
}

interface _PermissionRequestEvidence : IDispatch {
  mixin(ууид("34b0417e-e71d-304c-9fac-689350a1b41c"));
}

interface _PolicyException : IDispatch {
  mixin(ууид("a9c9f3d9-e153-39b8-a533-b8df4664407b"));
}

interface _PolicyLevel : IDispatch {
  mixin(ууид("44494e35-c370-3014-bc78-0f2ecbf83f53"));
}

interface _PolicyStatement : IDispatch {
  mixin(ууид("3eefd1fc-4d8d-3177-99f6-6c19d9e088d3"));
}

interface _Site : IDispatch {
  mixin(ууид("90c40b4c-b0d0-30f5-b520-fdba97bc31a0"));
}

interface _SiteMembershipCondition : IDispatch {
  mixin(ууид("0a7c3542-8031-3593-872c-78d85d7cc273"));
}

interface _StrongName : IDispatch {
  mixin(ууид("2a75c1fd-06b0-3cbb-b467-2545d4d6c865"));
}

interface _StrongNameMembershipCondition : IDispatch {
  mixin(ууид("579e93bc-ffab-3b8d-9181-ce9c22b51915"));
}

interface _UnionCodeGroup : IDispatch {
  mixin(ууид("d9d822de-44e5-33ce-a43f-173e475cecb1"));
}

interface _Url : IDispatch {
  mixin(ууид("d94ed9bf-c065-3703-81a2-2f76ea8e312f"));
}

interface _UrlMembershipCondition : IDispatch {
  mixin(ууид("bb7a158d-dbd9-3e13-b137-8e61e87e1128"));
}

interface _Zone : IDispatch {
  mixin(ууид("742e0c26-0e23-3d20-968c-d221094909aa"));
}

interface _ZoneMembershipCondition : IDispatch {
  mixin(ууид("adbc3463-0101-3429-a06c-db2f1dd6b724"));
}

interface _GacInstalled : IDispatch {
  mixin(ууид("a7aef52c-b47b-3660-bb3e-34347d56db46"));
}

interface _GacMembershipCondition : IDispatch {
  mixin(ууид("b2217ab5-6e55-3ff6-a1a9-1b0dc0585040"));
}

interface _Hash : IDispatch {
  mixin(ууид("7574e121-74a6-3626-b578-0783badb19d2"));
}

interface _HashMembershipCondition : IDispatch {
  mixin(ууид("6ba6ea7a-c9fc-3e73-82ec-18f29d83eefd"));
}

interface _Publisher : IDispatch {
  mixin(ууид("77cca693-abf6-3773-bf58-c0b02701a744"));
}

interface _PublisherMembershipCondition : IDispatch {
  mixin(ууид("3515cf63-9863-3044-b3e1-210e98efc702"));
}

interface _GenericIdentity : IDispatch {
  mixin(ууид("9a37d8b2-2256-3fe3-8bf0-4fc421a1244f"));
}

interface _GenericPrincipal : IDispatch {
  mixin(ууид("b4701c26-1509-3726-b2e1-409a636c9b4f"));
}

interface _WindowsIdentity : IDispatch {
  mixin(ууид("d8cf3f23-1a66-3344-8230-07eb53970b85"));
}

interface _WindowsImpersonationContext : IDispatch {
  mixin(ууид("60ecfdda-650a-324c-b4b3-f4d75b563bb1"));
}

interface _WindowsPrincipal : IDispatch {
  mixin(ууид("6c42baf9-1893-34fc-b3af-06931e9b34a3"));
}

interface _UnmanagedFunctionPointerAttribute : IDispatch {
  mixin(ууид("1b6ed26a-4b7f-34fc-b2c8-8109d684b3df"));
}

interface _DispIdAttribute : IDispatch {
  mixin(ууид("bbe41ac5-8692-3427-9ae1-c1058a38d492"));
}

interface _InterfaceTypeAttribute : IDispatch {
  mixin(ууид("a2145f38-cac1-33dd-a318-21948af6825d"));
}

interface _ComDefaultInterfaceAttribute : IDispatch {
  mixin(ууид("0c1e7b57-b9b1-36e4-8396-549c29062a81"));
}

interface _ClassInterfaceAttribute : IDispatch {
  mixin(ууид("6b6391ee-842f-3e9a-8eee-f13325e10996"));
}

interface _ComVisibleAttribute : IDispatch {
  mixin(ууид("1e7fffe2-aad9-34ee-8a9f-3c016b880ff0"));
}

interface _TypeLibImportClassAttribute : IDispatch {
  mixin(ууид("288a86d1-6f4f-39c9-9e42-162cf1c37226"));
}

interface _LCIDConversionAttribute : IDispatch {
  mixin(ууид("4ab67927-3c86-328a-8186-f85357dd5527"));
}

interface _ComRegisterFunctionAttribute : IDispatch {
  mixin(ууид("51ba926f-aab5-3945-b8a6-c8f0f4a7d12b"));
}

interface _ComUnregisterFunctionAttribute : IDispatch {
  mixin(ууид("9f164188-34eb-3f86-9f74-0bbe4155e65e"));
}

interface _ProgIdAttribute : IDispatch {
  mixin(ууид("2b9f01df-5a12-3688-98d6-c34bf5ed1865"));
}

interface _ImportedFromTypeLibAttribute : IDispatch {
  mixin(ууид("3f3311ce-6baf-3fb0-b855-489aff740b6e"));
}

interface _IDispatchImplAttribute : IDispatch {
  mixin(ууид("5778e7c7-2040-330e-b47a-92974dffcfd4"));
}

interface _ComSourceInterfacesAttribute : IDispatch {
  mixin(ууид("e1984175-55f5-3065-82d8-a683fdfcf0ac"));
}

interface _ComConversionLossAttribute : IDispatch {
  mixin(ууид("fd5b6aac-ff8c-3472-b894-cd6dfadb6939"));
}

interface _TypeLibTypeAttribute : IDispatch {
  mixin(ууид("b5a1729e-b721-3121-a838-fde43af13468"));
}

interface _TypeLibFuncAttribute : IDispatch {
  mixin(ууид("3d18a8e2-eede-3139-b29d-8cac057955df"));
}

interface _TypeLibVarAttribute : IDispatch {
  mixin(ууид("7b89862a-02a4-3279-8b42-4095fa3a778e"));
}

interface _MarshalAsAttribute : IDispatch {
  mixin(ууид("d858399f-e19e-3423-a720-ac12abe2e5e8"));
}

interface _ComImportAttribute : IDispatch {
  mixin(ууид("1b093056-5454-386f-8971-bbcbc4e9a8f3"));
}

interface _GuidAttribute : IDispatch {
  mixin(ууид("74435dad-ec55-354b-8f5b-fa70d13b6293"));
}

interface _PreserveSigAttribute : IDispatch {
  mixin(ууид("fdf2a2ee-c882-3198-a48b-e37f0e574dfa"));
}

interface _InAttribute : IDispatch {
  mixin(ууид("8474b65c-c39a-3d05-893d-577b9a314615"));
}

interface _OutAttribute : IDispatch {
  mixin(ууид("0697fc8c-9b04-3783-95c7-45eccac1ca27"));
}

interface _OptionalAttribute : IDispatch {
  mixin(ууид("0d6bd9ad-198e-3904-ad99-f6f82a2787c4"));
}

interface _DllImportAttribute : IDispatch {
  mixin(ууид("a1a26181-d55e-3ee2-96e6-70b354ef9371"));
}

interface _StructLayoutAttribute : IDispatch {
  mixin(ууид("23753322-c7b3-3f9a-ac96-52672c1b1ca9"));
}

interface _FieldOffsetAttribute : IDispatch {
  mixin(ууид("c14342b8-bafd-322a-bb71-62c672da284e"));
}

interface _ComAliasNameAttribute : IDispatch {
  mixin(ууид("e78785c4-3a73-3c15-9390-618bf3a14719"));
}

interface _AutomationProxyAttribute : IDispatch {
  mixin(ууид("57b908a8-c082-3581-8a47-6b41b86e8fdc"));
}

interface _PrimaryInteropAssemblyAttribute : IDispatch {
  mixin(ууид("c69e96b2-6161-3621-b165-5805198c6b8d"));
}

interface _CoClassAttribute : IDispatch {
  mixin(ууид("15d54c00-7c95-38d7-b859-e19346677dcd"));
}

interface _ComEventInterfaceAttribute : IDispatch {
  mixin(ууид("76cc0491-9a10-35c0-8a66-7931ec345b7f"));
}

interface _TypeLibVersionAttribute : IDispatch {
  mixin(ууид("a03b61a4-ca61-3460-8232-2f4ec96aa88f"));
}

interface _ComCompatibleVersionAttribute : IDispatch {
  mixin(ууид("ad419379-2ac8-3588-ab1e-0115413277c4"));
}

interface _BestFitMappingAttribute : IDispatch {
  mixin(ууид("ed47abe7-c84b-39f9-be1b-828cfb925afe"));
}

interface _DefaultCharSetAttribute : IDispatch {
  mixin(ууид("b26b3465-28e4-33b5-b9bf-dd7c4f6461f5"));
}

interface _SetWin32ContextInIDispatchAttribute : IDispatch {
  mixin(ууид("a54ac093-bfce-37b0-a81f-148dfed0971f"));
}

interface _ExternalException : IDispatch {
  mixin(ууид("a83f04e9-fd28-384a-9dff-410688ac23ab"));
}

interface _COMException : IDispatch {
  mixin(ууид("a28c19df-b488-34ae-becc-7de744d17f7b"));
}

interface _InvalidOleVariantTypeException : IDispatch {
  mixin(ууид("76e5dbd6-f960-3c65-8ea6-fc8ad6a67022"));
}

interface _MarshalDirectiveException : IDispatch {
  mixin(ууид("523f42a5-1fd2-355d-82bf-0d67c4a0a0e7"));
}

interface _RuntimeEnvironment : IDispatch {
  mixin(ууид("edcee21a-3e3a-331e-a86d-274028be6716"));
}

interface _SEHException : IDispatch {
  mixin(ууид("3e72e067-4c5e-36c8-bbef-1e2978c7780d"));
}

interface _BStrWrapper : IDispatch {
  mixin(ууид("80da5818-609f-32b8-a9f8-95fcfbdb9c8e"));
}

interface _CurrencyWrapper : IDispatch {
  mixin(ууид("7df6f279-da62-3c9f-8944-4dd3c0f08170"));
}

interface _DispatchWrapper : IDispatch {
  mixin(ууид("72103c67-d511-329c-b19a-dd5ec3f1206c"));
}

interface _ErrorWrapper : IDispatch {
  mixin(ууид("f79db336-06be-3959-a5ab-58b2ab6c5fd1"));
}

interface _ExtensibleClassFactory : IDispatch {
  mixin(ууид("519eb857-7a2d-3a95-a2a3-8bb8ed63d41b"));
}

interface _InvalidComObjectException : IDispatch {
  mixin(ууид("de9156b5-5e7a-3041-bf45-a29a6c2cf48a"));
}

interface _ObjectCreationDelegate : IDispatch {
  mixin(ууид("e4a369d3-6cf0-3b05-9c0c-1a91e331641a"));
}

interface _SafeArrayRankMismatchException : IDispatch {
  mixin(ууид("8608fe7b-2fdc-318a-b711-6f7b2feded06"));
}

interface _SafeArrayTypeMismatchException : IDispatch {
  mixin(ууид("e093fb32-e43b-3b3f-a163-742c920c2af3"));
}

interface _UnknownWrapper : IDispatch {
  mixin(ууид("1c8d8b14-4589-3dca-8e0f-a30e80fbd1a8"));
}

interface _Stream : IDispatch {
  mixin(ууид("2752364a-924f-3603-8f6f-6586df98b292"));
}

interface _BinaryReader : IDispatch {
  mixin(ууид("442e3c03-a205-3f21-aa4d-31768bb8ea28"));
}

interface _BinaryWriter : IDispatch {
  mixin(ууид("4ca8147e-baa3-3a7f-92ce-a4fd7f17d8da"));
}

interface _BufferedStream : IDispatch {
  mixin(ууид("4b7571c3-1275-3457-8fee-9976fd3937e3"));
}

interface _Directory : IDispatch {
  mixin(ууид("8ce58ff5-f26d-38a4-9195-0e2ecb3b56b9"));
}

interface _FileSystemInfo : IDispatch {
  mixin(ууид("a5d29a57-36a8-3e36-a099-7458b1fabaa2"));
}

interface _DirectoryInfo : IDispatch {
  mixin(ууид("487e52f1-2bb9-3bd0-a0ca-6728b3a1d051"));
}

interface _IOException : IDispatch {
  mixin(ууид("c5bfc9bf-27a7-3a59-a986-44c85f3521bf"));
}

interface _DirectoryNotFoundException : IDispatch {
  mixin(ууид("c8a200e4-9735-30e4-b168-ed861a3020f2"));
}

interface _DriveInfo : IDispatch {
  mixin(ууид("ce83a763-940f-341f-b880-332325eb6f4b"));
}

interface _DriveNotFoundException : IDispatch {
  mixin(ууид("b24e9559-a662-3762-ae33-bc7dfdd538f4"));
}

interface _EndOfStreamException : IDispatch {
  mixin(ууид("d625afd0-8fd9-3113-a900-43912a54c421"));
}

interface _File : IDispatch {
  mixin(ууид("5d59051f-e19d-329a-9962-fd00d552e13d"));
}

interface _FileInfo : IDispatch {
  mixin(ууид("c3c429f9-8590-3a01-b2b2-434837f3d16d"));
}

interface _FileLoadException : IDispatch {
  mixin(ууид("51d2c393-9b70-3551-84b5-ff5409fb3ada"));
}

interface _FileNotFoundException : IDispatch {
  mixin(ууид("a15a976b-81e3-3ef4-8ff1-d75ddbe20aef"));
}

interface _FileStream : IDispatch {
  mixin(ууид("74265195-4a46-3d6f-a9dd-69c367ea39c8"));
}

interface _MemoryStream : IDispatch {
  mixin(ууид("2dbc46fe-b3dd-3858-afc2-d3a2d492a588"));
}

interface _Path : IDispatch {
  mixin(ууид("6df93530-d276-31d9-8573-346778c650af"));
}

interface _PathTooLongException : IDispatch {
  mixin(ууид("468b8eb4-89ac-381b-8f86-5e47ec0648b4"));
}

interface _TextReader : IDispatch {
  mixin(ууид("897471f2-9450-3f03-a41f-d2e1f1397854"));
}

interface _StreamReader : IDispatch {
  mixin(ууид("e645b470-dc3f-3ce0-8104-5837feda04b3"));
}

interface _TextWriter : IDispatch {
  mixin(ууид("556137ea-8825-30bc-9d49-e47a9db034ee"));
}

interface _StreamWriter : IDispatch {
  mixin(ууид("1f124e1c-d05d-3643-a59f-c3de6051994f"));
}

interface _StringReader : IDispatch {
  mixin(ууид("59733b03-0ea5-358c-95b5-659fcd9aa0b4"));
}

interface _StringWriter : IDispatch {
  mixin(ууид("cb9f94c0-d691-3b62-b0b2-3ce5309cfa62"));
}

interface _AccessedThroughPropertyAttribute : IDispatch {
  mixin(ууид("998dcf16-f603-355d-8c89-3b675947997f"));
}

interface _CallConvCdecl : IDispatch {
  mixin(ууид("a6c2239b-08e6-3822-9769-e3d4b0431b82"));
}

interface _CallConvStdcall : IDispatch {
  mixin(ууид("8e17a5cd-1160-32dc-8548-407e7c3827c9"));
}

interface _CallConvThiscall : IDispatch {
  mixin(ууид("fa73dd3d-a472-35ed-b8be-f99a13581f72"));
}

interface _CallConvFastcall : IDispatch {
  mixin(ууид("3b452d17-3c5e-36c4-a12d-5e9276036cf8"));
}

interface _CustomConstantAttribute : IDispatch {
  mixin(ууид("62caf4a2-6a78-3fc7-af81-a6bbf930761f"));
}

interface _DateTimeConstantAttribute : IDispatch {
  mixin(ууид("ef387020-b664-3acd-a1d2-806345845953"));
}

interface _DiscardableAttribute : IDispatch {
  mixin(ууид("3c3a8c69-7417-32fa-aa20-762d85e1b594"));
}

interface _DecimalConstantAttribute : IDispatch {
  mixin(ууид("7e133967-ccec-3e89-8bd2-6cfca649ecbf"));
}

interface _CompilationRelaxationsAttribute : IDispatch {
  mixin(ууид("c5c4f625-2329-3382-8994-aaf561e5dfe9"));
}

interface _CompilerGlobalScopeAttribute : IDispatch {
  mixin(ууид("1eed213e-656a-3a73-a4b9-0d3b26fd942b"));
}

interface _IndexerNameAttribute : IDispatch {
  mixin(ууид("243368f5-67c9-3510-9424-335a8a67772f"));
}

interface _IsVolatile : IDispatch {
  mixin(ууид("0278c819-0c06-3756-b053-601a3e566d9b"));
}

interface _MethodImplAttribute : IDispatch {
  mixin(ууид("98966503-5d80-3242-83ef-79e136f6b954"));
}

interface _RequiredAttributeAttribute : IDispatch {
  mixin(ууид("db2c11d9-3870-35e7-a10c-a3ddc3dc79b1"));
}

interface _IsCopyConstructed : IDispatch {
  mixin(ууид("f68a4008-ab94-3370-a9ac-8cc99939f534"));
}

interface _NativeCppClassAttribute : IDispatch {
  mixin(ууид("40e8e914-dc23-38a6-936b-90e4e3ab01fa"));
}

interface _IDispatchConstantAttribute : IDispatch {
  mixin(ууид("97d0b28a-6932-3d74-b67f-6bcd3c921e7d"));
}

interface _IUnknownConstantAttribute : IDispatch {
  mixin(ууид("54542649-ce64-3f96-bce5-fde3bb22f242"));
}

interface _SecurityElement : IDispatch {
  mixin(ууид("8d597c42-2cfd-32b6-b6d6-86c9e2cff00a"));
}

interface _XmlSyntaxException : IDispatch {
  mixin(ууид("d9fcad88-d869-3788-a802-1b1e007c7a22"));
}

interface _CodeAccessPermission : IDispatch {
  mixin(ууид("4803ce39-2f30-31fc-b84b-5a0141385269"));
}

interface _EnvironmentPermission : IDispatch {
  mixin(ууид("0720590d-5218-352a-a337-5449e6bd19da"));
}

interface _FileDialogPermission : IDispatch {
  mixin(ууид("a8b7138c-8932-3d78-a585-a91569c743ac"));
}

interface _FileIOPermission : IDispatch {
  mixin(ууид("a2ed7efc-8e59-3ccc-ae92-ea2377f4d5ef"));
}

interface _SecurityAttribute : IDispatch {
  mixin(ууид("48815668-6c27-3312-803e-2757f55ce96a"));
}

interface _CodeAccessSecurityAttribute : IDispatch {
  mixin(ууид("9c5149cb-d3c6-32fd-a0d5-95350de7b813"));
}

interface _HostProtectionAttribute : IDispatch {
  mixin(ууид("9f8f73a3-1e99-3e51-a41b-179a41dc747c"));
}

interface _IsolatedStoragePermission : IDispatch {
  mixin(ууид("7fee7903-f97c-3350-ad42-196b00ad2564"));
}

interface _IsolatedStorageFilePermission : IDispatch {
  mixin(ууид("0d0c83e8-bde1-3ba5-b1ef-a8fc686d8bc9"));
}

interface _EnvironmentPermissionAttribute : IDispatch {
  mixin(ууид("4164071a-ed12-3bdd-af40-fdabcaa77d5f"));
}

interface _FileDialogPermissionAttribute : IDispatch {
  mixin(ууид("0ccca629-440f-313e-96cd-ba1b4b4997f7"));
}

interface _FileIOPermissionAttribute : IDispatch {
  mixin(ууид("0dca817d-f21a-3943-b54c-5e800ce5bc50"));
}

interface _KeyContainerPermissionAttribute : IDispatch {
  mixin(ууид("edb51d1c-08ad-346a-be6f-d74fd6d6f965"));
}

interface _PrincipalPermissionAttribute : IDispatch {
  mixin(ууид("68ab69e4-5d68-3b51-b74d-1beab9f37f2b"));
}

interface _ReflectionPermissionAttribute : IDispatch {
  mixin(ууид("d31eed10-a5f0-308f-a951-e557961ec568"));
}

interface _RegistryPermissionAttribute : IDispatch {
  mixin(ууид("38b6068c-1e94-3119-8841-1eca35ed8578"));
}

interface _SecurityPermissionAttribute : IDispatch {
  mixin(ууид("3a5b876c-cde4-32d2-9c7e-020a14aca332"));
}

interface _UIPermissionAttribute : IDispatch {
  mixin(ууид("1d5c0f70-af29-38a3-9436-3070a310c73b"));
}

interface _ZoneIdentityPermissionAttribute : IDispatch {
  mixin(ууид("2e3be3ed-2f22-3b20-9f92-bd29b79d6f42"));
}

interface _StrongNameIdentityPermissionAttribute : IDispatch {
  mixin(ууид("c9a740f4-26e9-39a8-8885-8ca26bd79b21"));
}

interface _SiteIdentityPermissionAttribute : IDispatch {
  mixin(ууид("6fe6894a-2a53-3fb6-a06e-348f9bdad23b"));
}

interface _UrlIdentityPermissionAttribute : IDispatch {
  mixin(ууид("ca4a2073-48c5-3e61-8349-11701a90dd9b"));
}

interface _PublisherIdentityPermissionAttribute : IDispatch {
  mixin(ууид("6722c730-1239-3784-ac94-c285ae5b901a"));
}

interface _IsolatedStoragePermissionAttribute : IDispatch {
  mixin(ууид("5c4c522f-de4e-3595-9aa9-9319c86a5283"));
}

interface _IsolatedStorageFilePermissionAttribute : IDispatch {
  mixin(ууид("6f1f8aae-d667-39cc-98fa-722bebbbeac3"));
}

interface _PermissionSetAttribute : IDispatch {
  mixin(ууид("947a1995-bc16-3e7c-b65a-99e71f39c091"));
}

interface _ReflectionPermission : IDispatch {
  mixin(ууид("aeb3727f-5c3a-34c4-bf18-a38f088ac8c7"));
}

interface _PrincipalPermission : IDispatch {
  mixin(ууид("7c6b06d1-63ad-35ef-a938-149b4ad9a71f"));
}

interface _SecurityPermission : IDispatch {
  mixin(ууид("33c54a2d-02bd-3848-80b6-742d537085e5"));
}

interface _SiteIdentityPermission : IDispatch {
  mixin(ууид("790b3ee9-7e06-3cd0-8243-5848486d6a78"));
}

interface _StrongNameIdentityPermission : IDispatch {
  mixin(ууид("5f1562fb-0160-3655-baea-b15bef609161"));
}

interface _StrongNamePublicKeyBlob : IDispatch {
  mixin(ууид("af53d21a-d6af-3406-b399-7df9d2aad48a"));
}

interface _UIPermission : IDispatch {
  mixin(ууид("47698389-f182-3a67-87df-aed490e14dc6"));
}

interface _UrlIdentityPermission : IDispatch {
  mixin(ууид("ec7cac31-08a2-393b-bdf2-d052eb53af2c"));
}

interface _ZoneIdentityPermission : IDispatch {
  mixin(ууид("38b2f8d7-8cf4-323b-9c17-9c55ee287a63"));
}

interface _GacIdentityPermissionAttribute : IDispatch {
  mixin(ууид("5f19e082-26f8-3361-b338-9bacb98809a4"));
}

interface _GacIdentityPermission : IDispatch {
  mixin(ууид("a9637792-5be8-3c93-a501-49f0e840de38"));
}

interface _KeyContainerPermissionAccessEntry : IDispatch {
  mixin(ууид("094351ea-dbc1-327f-8a83-913b593a66be"));
}

interface _KeyContainerPermissionAccessEntryCollection : IDispatch {
  mixin(ууид("28ecf94e-3510-3a3e-8bd1-f866f45f3b06"));
}

interface _KeyContainerPermissionAccessEntryEnumerator : IDispatch {
  mixin(ууид("293187ea-5f88-316f-86a5-533b0c7b353f"));
}

interface _KeyContainerPermission : IDispatch {
  mixin(ууид("107a3cf1-b35e-3a23-b660-60264b231225"));
}

interface _PublisherIdentityPermission : IDispatch {
  mixin(ууид("e86cc74a-1233-3df3-b13f-8b27eeaac1f6"));
}

interface _RegistryPermission : IDispatch {
  mixin(ууид("c3fb5510-3454-3b31-b64f-de6aad6be820"));
}

interface _SuppressUnmanagedCodeSecurityAttribute : IDispatch {
  mixin(ууид("8000e51a-541c-3b20-a8ec-c8a8b41116c4"));
}

interface _UnverifiableCodeAttribute : IDispatch {
  mixin(ууид("41f41c1b-7b8d-39a3-a28f-aae20787f469"));
}

interface _AllowPartiallyTrustedCallersAttribute : IDispatch {
  mixin(ууид("f1c930c4-2233-3924-9840-231d008259b4"));
}

interface _HostSecurityManager : IDispatch {
  mixin(ууид("9deae196-48c1-3590-9d0a-33716a214acd"));
}

interface _PermissionSet : IDispatch {
  mixin(ууид("c2af4970-4fb6-319c-a8aa-0614d27f2b2c"));
}

interface _NamedPermissionSet : IDispatch {
  mixin(ууид("ba3e053f-ade3-3233-874a-16e624c9a49b"));
}

interface _БезопИскл : IDispatch {
  mixin(ууид("f174290f-e4cf-3976-88aa-4f8e32eb03db"));
}

interface _HostProtectionException : IDispatch {
  mixin(ууид("ed727a9b-6fc5-3fed-bedd-7b66c847f87a"));
}

interface _SecurityManager : IDispatch {
  mixin(ууид("abc04b16-5539-3c7e-92ec-0905a4a24464"));
}

interface _VerificationException : IDispatch {
  mixin(ууид("f65070df-57af-3ae3-b951-d2ad7d513347"));
}

interface _ContextAttribute : IDispatch {
  mixin(ууид("f042505b-7aac-313b-a8c7-3f1ac949c311"));
}

interface _AsyncResult : IDispatch {
  mixin(ууид("3936abe1-b29e-3593-83f1-793d1a7f3898"));
}

interface _ChannelServices : IDispatch {
  mixin(ууид("ffb2e16e-e5c7-367c-b326-965abf510f24"));
}

interface _ClientChannelSinkStack : IDispatch {
  mixin(ууид("e1796120-c324-30d8-86f4-20086711463b"));
}

interface _ServerChannelSinkStack : IDispatch {
  mixin(ууид("52da9f90-89b3-35ab-907b-3562642967de"));
}

interface _ClientSponsor : IDispatch {
  mixin(ууид("ff19d114-3bda-30ac-8e89-36ca64a87120"));
}

interface _CrossContextDelegate : IDispatch {
  mixin(ууид("ee949b7b-439f-363e-b9fc-34db1fb781d7"));
}

interface _Context : IDispatch {
  mixin(ууид("11a2ea7a-d600-307b-a606-511a6c7950d1"));
}

interface _ContextProperty : IDispatch {
  mixin(ууид("4acb3495-05db-381b-890a-d12f5340dca3"));
}

interface _EnterpriseServicesHelper : IDispatch {
  mixin(ууид("77c9bceb-9958-33c0-a858-599f66697da7"));
}

interface _ChannelDataStore : IDispatch {
  mixin(ууид("aa6da581-f972-36de-a53b-7585428a68ab"));
}

interface _TransportHeaders : IDispatch {
  mixin(ууид("65887f70-c646-3a66-8697-8a3f7d8fe94d"));
}

interface _SinkProviderData : IDispatch {
  mixin(ууид("a18545b7-e5ee-31ee-9b9b-41199b11c995"));
}

interface _BaseChannelObjectWithProperties : IDispatch {
  mixin(ууид("a1329ec9-e567-369f-8258-18366d89eaf8"));
}

interface _BaseChannelSinkWithProperties : IDispatch {
  mixin(ууид("8af3451e-154d-3d86-80d8-f8478b9733ed"));
}

interface _BaseChannelWithProperties : IDispatch {
  mixin(ууид("94bb98ed-18bb-3843-a7fe-642824ab4e01"));
}

interface _LifetimeServices : IDispatch {
  mixin(ууид("b0ad9a21-5439-3d88-8975-4018b828d74c"));
}

interface _ReturnMessage : IDispatch {
  mixin(ууид("0eeff4c2-84bf-3e4e-bf22-b7bdbb5df899"));
}

interface _MethodCall : IDispatch {
  mixin(ууид("95e01216-5467-371b-8597-4074402ccb06"));
}

interface _ConstructionCall : IDispatch {
  mixin(ууид("a2246ae7-eb81-3a20-8e70-c9fa341c7e10"));
}

interface _MethodResponse : IDispatch {
  mixin(ууид("9e9ea93a-d000-3ab9-bfca-ddeb398a55b9"));
}

interface _ConstructionResponse : IDispatch {
  mixin(ууид("be457280-6ffa-3e76-9822-83de63c0c4e0"));
}

interface _InternalMessageWrapper : IDispatch {
  mixin(ууид("ef926e1f-3ee7-32bc-8b01-c6e98c24bc19"));
}

interface _MethodCallMessageWrapper : IDispatch {
  mixin(ууид("c9614d78-10ea-3310-87ea-821b70632898"));
}

interface _MethodReturnMessageWrapper : IDispatch {
  mixin(ууид("89304439-a24f-30f6-9a8f-89ce472d85da"));
}

interface _ObjRef : IDispatch {
  mixin(ууид("1dd3cf3d-df8e-32ff-91ec-e19aa10b63fb"));
}

interface _OneWayAttribute : IDispatch {
  mixin(ууид("8ffedc68-5233-3fa8-813d-405aabb33ecb"));
}

interface _ProxyAttribute : IDispatch {
  mixin(ууид("d80ff312-2930-3680-a5e9-b48296c7415f"));
}

interface _RealProxy : IDispatch {
  mixin(ууид("e0cf3f77-c7c3-33da-beb4-46147fc905de"));
}

interface _SoapAttribute : IDispatch {
  mixin(ууид("725692a5-9e12-37f6-911c-e3da77e5faca"));
}

interface _SoapTypeAttribute : IDispatch {
  mixin(ууид("ebcdcd84-8c74-39fd-821c-f5eb3a2704d7"));
}

interface _SoapMethodAttribute : IDispatch {
  mixin(ууид("c58145b5-bd5a-3896-95d9-b358f54fbc44"));
}

interface _SoapFieldAttribute : IDispatch {
  mixin(ууид("46a3f9ff-f73c-33c7-bcc3-1bef4b25e4ae"));
}

interface _SoapParameterAttribute : IDispatch {
  mixin(ууид("c32abfc9-3917-30bf-a7bc-44250bdfc5d8"));
}

interface _RemotingConfiguration : IDispatch {
  mixin(ууид("4b10971e-d61d-373f-bc8d-2ccf31126215"));
}

interface _TypeEntry : IDispatch {
  mixin(ууид("8359f3ab-643f-3bcf-91e8-16e779edebe1"));
}

interface _ActivatedClientTypeEntry : IDispatch {
  mixin(ууид("bac12781-6865-3558-a8d1-f1cadd2806dd"));
}

interface _ActivatedServiceTypeEntry : IDispatch {
  mixin(ууид("94855a3b-5ca2-32cf-b1ab-48fd3915822c"));
}

interface _WellKnownClientTypeEntry : IDispatch {
  mixin(ууид("4d0bc339-e3f9-3e9e-8f68-92168e6f6981"));
}

interface _WellKnownServiceTypeEntry : IDispatch {
  mixin(ууид("60b8b604-0aed-3093-ac05-eb98fb29fc47"));
}

interface _RemotingException : IDispatch {
  mixin(ууид("7264843f-f60c-39a9-99e1-029126aa0815"));
}

interface _ServerException : IDispatch {
  mixin(ууид("19373c44-55b4-3487-9ad8-4c621aae85ea"));
}

interface _RemotingTimeoutException : IDispatch {
  mixin(ууид("44db8e15-acb1-34ee-81f9-56ed7ae37a5c"));
}

interface _RemotingServices : IDispatch {
  mixin(ууид("7b91368d-a50a-3d36-be8e-5b8836a419ad"));
}

interface _InternalRemotingServices : IDispatch {
  mixin(ууид("f4efb305-cdc4-31c5-8102-33c9b91774f3"));
}

interface _MessageSurrogateFilter : IDispatch {
  mixin(ууид("04a35d22-0b08-34e7-a573-88ef2374375e"));
}

interface _RemotingSurrogateSelector : IDispatch {
  mixin(ууид("551f7a57-8651-37db-a94a-6a3ca09c0ed7"));
}

interface _SoapServices : IDispatch {
  mixin(ууид("7416b6ee-82e8-3a16-966b-018a40e7b1aa"));
}

interface _SoapDateTime : IDispatch {
  mixin(ууид("1738adbc-156e-3897-844f-c3147c528dea"));
}

interface _SoapDuration : IDispatch {
  mixin(ууид("7ef50ddb-32a5-30a1-b412-47fab911404a"));
}

interface _SoapTime : IDispatch {
  mixin(ууид("a3bf0bcd-ec32-38e6-92f2-5f37bad8030d"));
}

interface _SoapDate : IDispatch {
  mixin(ууид("cfa6e9d2-b3de-39a6-94d1-cc691de193f8"));
}

interface _SoapYearMonth : IDispatch {
  mixin(ууид("103c7ef9-a9ee-35fb-84c5-3086c9725a20"));
}

interface _SoapYear : IDispatch {
  mixin(ууид("c20769f3-858d-316a-be6d-c347a47948ad"));
}

interface _SoapMonthDay : IDispatch {
  mixin(ууид("f9ead0aa-4156-368f-ae05-fd59d70f758d"));
}

interface _SoapDay : IDispatch {
  mixin(ууид("d9e8314d-5053-3497-8a33-97d3dcfe33e2"));
}

interface _SoapMonth : IDispatch {
  mixin(ууид("b4e32423-e473-3562-aa12-62fde5a7d4a2"));
}

interface _SoapHexBinary : IDispatch {
  mixin(ууид("63b9da95-fb91-358a-b7b7-90c34aa34ab7"));
}

interface _SoapBase64Binary : IDispatch {
  mixin(ууид("8ed115a1-5e7b-34dc-ab85-90316f28015d"));
}

interface _SoapInteger : IDispatch {
  mixin(ууид("30c65c40-4e54-3051-9d8f-4709b6ab214c"));
}

interface _SoapPositiveInteger : IDispatch {
  mixin(ууид("4979ec29-c2b7-3ad6-986d-5aaf7344cc4e"));
}

interface _SoapNonPositiveInteger : IDispatch {
  mixin(ууид("aaf5401e-f71c-3fe3-8a73-a25074b20d3a"));
}

interface _SoapNonNegativeInteger : IDispatch {
  mixin(ууид("bc261fc6-7132-3fb5-9aac-224845d3aa99"));
}

interface _SoapNegativeInteger : IDispatch {
  mixin(ууид("e384aa10-a70c-3943-97cf-0f7c282c3bdc"));
}

interface _SoapAnyUri : IDispatch {
  mixin(ууид("818ec118-be7e-3cde-92c8-44b99160920e"));
}

interface _SoapQName : IDispatch {
  mixin(ууид("3ac646b6-6b84-382f-9aed-22c2433244e6"));
}

interface _SoapNotation : IDispatch {
  mixin(ууид("974f01f4-6086-3137-9448-6a31fc9bef08"));
}

interface _SoapNormalizedString : IDispatch {
  mixin(ууид("f4926b50-3f23-37e0-9afa-aa91ff89a7bd"));
}

interface _SoapToken : IDispatch {
  mixin(ууид("ab4e97b9-651d-36f4-aaba-28acf5746624"));
}

interface _SoapLanguage : IDispatch {
  mixin(ууид("14aed851-a168-3462-b877-8f9a01126653"));
}

interface _SoapName : IDispatch {
  mixin(ууид("5eb06bef-4adf-3cc1-a6f2-62f76886b13a"));
}

interface _SoapIdrefs : IDispatch {
  mixin(ууид("7947a829-adb5-34d0-9cc8-6c172742c803"));
}

interface _SoapEntities : IDispatch {
  mixin(ууид("aca96da3-96ed-397e-8a72-ee1be1025f5e"));
}

interface _SoapNmtoken : IDispatch {
  mixin(ууид("e941fa15-e6c8-3dd4-b060-c0ddfbc0240a"));
}

interface _SoapNmtokens : IDispatch {
  mixin(ууид("a5e385ae-27fb-3708-baf7-0bf1f3955747"));
}

interface _SoapNcName : IDispatch {
  mixin(ууид("725cdaf7-b739-35c1-8463-e2a923e1f618"));
}

interface _SoapId : IDispatch {
  mixin(ууид("6a46b6a2-2d2c-3c67-af67-aae0175f17ae"));
}

interface _SoapIdref : IDispatch {
  mixin(ууид("7db7fd83-de89-38e1-9645-d4cabde694c0"));
}

interface _SoapEntity : IDispatch {
  mixin(ууид("37171746-b784-3586-a7d5-692a7604a66b"));
}

interface _SynchronizationAttribute : IDispatch {
  mixin(ууид("2d985674-231c-33d4-b14d-f3a6bd2ebe19"));
}

interface _TrackingServices : IDispatch {
  mixin(ууид("f51728f2-2def-308c-874a-cbb1baa9cf9e"));
}

interface _UrlAttribute : IDispatch {
  mixin(ууид("717105a3-739b-3bc3-a2b7-ad215903fad2"));
}

interface _Header : IDispatch {
  mixin(ууид("0d296515-ad19-3602-b415-d8ec77066081"));
}

interface _HeaderHandler : IDispatch {
  mixin(ууид("5dbbaf39-a3df-30b7-aaea-9fd11394123f"));
}

interface _CallContext : IDispatch {
  mixin(ууид("53bce4d4-6209-396d-bd4a-0b0a0a177df9"));
}

interface _LogicalCallContext : IDispatch {
  mixin(ууид("9aff21f5-1c9c-35e7-aea4-c3aa0beb3b77"));
}

interface _ObjectHandle : IDispatch {
  mixin(ууид("ea675b47-64e0-3b5f-9be7-f7dc2990730d"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT объ, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int GetLifetimeService(out VARIANT pRetVal);
  /*[id(0x60020005)]*/ int InitializeLifetimeService(out VARIANT pRetVal);
  /*[id(0x60020006)]*/ int CreateObjRef(_Type requestedType, out _ObjRef pRetVal);
  /*[id(0x60020007)]*/ int Unwrap(out VARIANT pRetVal);
}

interface _IsolatedStorage : IDispatch {
  mixin(ууид("34ec3bd7-f2f6-3c20-a639-804bff89df65"));
}

interface _IsolatedStorageFileStream : IDispatch {
  mixin(ууид("68d5592b-47c8-381a-8d51-3925c16cf025"));
}

interface _IsolatedStorageException : IDispatch {
  mixin(ууид("aec2b0de-9898-3607-b845-63e2e307cb5f"));
}

interface _IsolatedStorageFile : IDispatch {
  mixin(ууид("6bbb7dee-186f-3d51-9486-be0a71e915ce"));
}

interface _InternalRM : IDispatch {
  mixin(ууид("361a5049-1bc8-35a9-946a-53a877902f25"));
}

interface _InternalST : IDispatch {
  mixin(ууид("a864fb13-f945-3dc0-a01c-b903f944fc97"));
}

interface _SoapMessage : IDispatch {
  mixin(ууид("bc0847b2-bd5c-37b3-ba67-7d2d54b17238"));
}

interface _SoapFault : IDispatch {
  mixin(ууид("a1c392fc-314c-39d5-8de6-1f8ebca0a1e2"));
}

interface _ServerFault : IDispatch {
  mixin(ууид("02d1bd78-3bb6-37ad-a9f8-f7d5da273e4e"));
}

interface _BinaryFormatter : IDispatch {
  mixin(ууид("3bcf0cb2-a849-375e-8189-1ba5f1f4a9b0"));
}

interface _DynamicILInfo : IDispatch {
  mixin(ууид("0daeaee7-007b-3fca-8755-a5c6c3158955"));
}

interface _DynamicMethod : IDispatch {
  mixin(ууид("eaaa2670-0fb1-33ea-852b-f1c97fed1797"));
}

interface _OpCodes : IDispatch {
  mixin(ууид("1db1cc2a-da73-389e-828b-5c616f4fac49"));
}

interface _GenericTypeParameterBuilder : IDispatch {
  mixin(ууид("b1a62835-fc19-35a4-b206-a452463d7ee7"));
}

interface _UnmanagedMarshal : IDispatch {
  mixin(ууид("fd302d86-240a-3694-a31f-9ef59e6e41bc"));
}

interface _KeySizes : IDispatch {
  mixin(ууид("8978b0be-a89e-3ff9-9834-77862cebff3d"));
}

interface _CryptographicException : IDispatch {
  mixin(ууид("4311e8f5-b249-3f81-8ff4-cf853d85306d"));
}

interface _CryptographicUnexpectedOperationException : IDispatch {
  mixin(ууид("7fb08423-038f-3acc-b600-e6d072bae160"));
}

interface _RandomNumberGenerator : IDispatch {
  mixin(ууид("7ae4b03c-414a-36e0-ba68-f9603004c925"));
}

interface _RNGCryptoServiceProvider : IDispatch {
  mixin(ууид("2c65d4c0-584c-3e4e-8e6d-1afb112bff69"));
}

interface _SymmetricAlgorithm : IDispatch {
  mixin(ууид("05bc0e38-7136-3825-9e34-26c1cf2142c9"));
}

interface _AsymmetricAlgorithm : IDispatch {
  mixin(ууид("09343ac0-d19a-3e62-bc16-0f600f10180a"));
}

interface _AsymmetricKeyExchangeDeformatter : IDispatch {
  mixin(ууид("b6685cca-7a49-37d1-a805-3de829cb8deb"));
}

interface _AsymmetricKeyExchangeFormatter : IDispatch {
  mixin(ууид("1365b84b-6477-3c40-be6a-089dc01eced9"));
}

interface _AsymmetricSignatureDeformatter : IDispatch {
  mixin(ууид("7ca5fe57-d1ac-3064-bb0b-f450be40f194"));
}

interface _AsymmetricSignatureFormatter : IDispatch {
  mixin(ууид("5363d066-6295-3618-be33-3f0b070b7976"));
}

interface _ToBase64Transform : IDispatch {
  mixin(ууид("23ded1e1-7d5f-3936-aa4e-18bbcc39b155"));
}

interface _FromBase64Transform : IDispatch {
  mixin(ууид("fc0717a6-2e86-372f-81f4-b35ed4bdf0de"));
}

interface _CryptoAPITransform : IDispatch {
  mixin(ууид("983b8639-2ed7-364c-9899-682abb2ce850"));
}

interface _CspParameters : IDispatch {
  mixin(ууид("d5331d95-fff2-358f-afd5-588f469ff2e4"));
}

interface _CryptoConfig : IDispatch {
  mixin(ууид("ab00f3f8-7dde-3ff5-b805-6c5dbb200549"));
}

interface _CryptoStream : IDispatch {
  mixin(ууид("4134f762-d0ec-3210-93c0-de4f443d5669"));
}

interface _DES : IDispatch {
  mixin(ууид("c7ef0214-b91c-3799-98dd-c994aabfc741"));
}

interface _DESCryptoServiceProvider : IDispatch {
  mixin(ууид("65e8495e-5207-3248-9250-0fc849b4f096"));
}

interface _DeriveBytes : IDispatch {
  mixin(ууид("140ee78f-067f-3765-9258-c3bc72fe976b"));
}

interface _DSA : IDispatch {
  mixin(ууид("0eb5b5e0-1be6-3a5f-87b3-e3323342f44e"));
}

interface _DSACryptoServiceProvider : IDispatch {
  mixin(ууид("1f38aafe-7502-332f-971f-c2fc700a1d55"));
}

interface _DSASignatureDeformatter : IDispatch {
  mixin(ууид("0e774498-ade6-3820-b1d5-426b06397be7"));
}

interface _DSASignatureFormatter : IDispatch {
  mixin(ууид("4b5fc561-5983-31e4-903b-1404231b2c89"));
}

interface _HashAlgorithm : IDispatch {
  mixin(ууид("69d3baba-1c3d-354c-acfe-f19109ec3896"));
}

interface _KeyedHashAlgorithm : IDispatch {
  mixin(ууид("d182cf91-628c-3ff6-87f0-41ba51cc7433"));
}

interface _HMAC : IDispatch {
  mixin(ууид("e5456726-33f6-34e4-95c2-db2bfa581462"));
}

interface _HMACMD5 : IDispatch {
  mixin(ууид("486360f5-6213-322b-befb-45221579d4af"));
}

interface _HMACRIPEMD160 : IDispatch {
  mixin(ууид("9fd974a5-338c-37b9-a1b2-d45f0c2b25c2"));
}

interface _HMACSHA1 : IDispatch {
  mixin(ууид("63ac7c37-c51a-3d82-8fdd-2a567039e46d"));
}

interface _HMACSHA256 : IDispatch {
  mixin(ууид("1377ce34-8921-3bd4-96e9-c8d5d5aa1adf"));
}

interface _HMACSHA384 : IDispatch {
  mixin(ууид("786f8ac3-93e4-3b6f-9f62-1901b0e5f433"));
}

interface _HMACSHA512 : IDispatch {
  mixin(ууид("eb081b9d-a766-3abe-b720-505c42162d83"));
}

interface _CspKeyContainerInfo : IDispatch {
  mixin(ууид("be8619cb-3731-3cb2-a3a8-cd0bfa5566ec"));
}

interface _MACTripleDES : IDispatch {
  mixin(ууид("1cac0bda-ac58-31bc-b624-63f77d0c3d2f"));
}

interface _MD5 : IDispatch {
  mixin(ууид("9aa8765e-69a0-30e3-9cde-ebc70662ae37"));
}

interface _MD5CryptoServiceProvider : IDispatch {
  mixin(ууид("d3f5c812-5867-33c9-8cee-cb170e8d844a"));
}

interface _MaskGenerationMethod : IDispatch {
  mixin(ууид("85601fee-a79d-3710-af21-099089edc0bf"));
}

interface _PasswordDeriveBytes : IDispatch {
  mixin(ууид("3cd62d67-586f-309e-a6d8-1f4baac5ac28"));
}

interface _PKCS1MaskGenerationMethod : IDispatch {
  mixin(ууид("425bff0d-59e4-36a8-b1ff-1f5d39d698f4"));
}

interface _RC2 : IDispatch {
  mixin(ууид("f7c0c4cc-0d49-31ee-a3d3-b8b551e4928c"));
}

interface _RC2CryptoServiceProvider : IDispatch {
  mixin(ууид("875715c5-cb64-3920-8156-0ee9cb0e07ea"));
}

interface _Rfc2898DeriveBytes : IDispatch {
  mixin(ууид("a6589897-5a67-305f-9497-72e5fe8bead5"));
}

interface _RIPEMD160 : IDispatch {
  mixin(ууид("e5481be9-3422-3506-bc35-b96d4535014d"));
}

interface _RIPEMD160Managed : IDispatch {
  mixin(ууид("814f9c35-b7f8-3ceb-8e43-e01f09157060"));
}

interface _RSA : IDispatch {
  mixin(ууид("0b3fb710-a25c-3310-8774-1cf117f95bd4"));
}

interface _RSACryptoServiceProvider : IDispatch {
  mixin(ууид("bd9df856-2300-3254-bcf0-679ba03c7a13"));
}

interface _RSAOAEPKeyExchangeDeformatter : IDispatch {
  mixin(ууид("37625095-7baa-377d-a0dc-7f465c0167aa"));
}

interface _RSAOAEPKeyExchangeFormatter : IDispatch {
  mixin(ууид("77a416e7-2ac6-3d0e-98ff-3ba0f586f56f"));
}

interface _RSAPKCS1KeyExchangeDeformatter : IDispatch {
  mixin(ууид("8034aaf4-3666-3b6f-85cf-463f9bfd31a9"));
}

interface _RSAPKCS1KeyExchangeFormatter : IDispatch {
  mixin(ууид("9ff67f8e-a7aa-3ba6-90ee-9d44af6e2f8c"));
}

interface _RSAPKCS1SignatureDeformatter : IDispatch {
  mixin(ууид("fc38507e-06a4-3300-8652-8d7b54341f65"));
}

interface _RSAPKCS1SignatureFormatter : IDispatch {
  mixin(ууид("fb7a5ff4-cfa8-3f24-ad5f-d5eb39359707"));
}

interface _Rijndael : IDispatch {
  mixin(ууид("21b52a91-856f-373c-ad42-4cf3f1021f5a"));
}

interface _RijndaelManaged : IDispatch {
  mixin(ууид("427ea9d3-11d8-3e38-9e05-a4f7fa684183"));
}

interface _RijndaelManagedTransform : IDispatch {
  mixin(ууид("5767c78f-f344-35a5-84bc-53b9eaeb68cb"));
}

interface _SHA1 : IDispatch {
  mixin(ууид("48600dd2-0099-337f-92d6-961d1e5010d4"));
}

interface _SHA1CryptoServiceProvider : IDispatch {
  mixin(ууид("a16537bc-1edf-3516-b75e-cc65caf873ab"));
}

interface _SHA1Managed : IDispatch {
  mixin(ууид("c27990bb-3cfd-3d29-8dc0-bbe5fbadeafd"));
}

interface _SHA256 : IDispatch {
  mixin(ууид("3b274703-dfae-3f9c-a1b5-9990df9d7fa3"));
}

interface _SHA256Managed : IDispatch {
  mixin(ууид("3d077954-7bcc-325b-9dda-3b17a03378e0"));
}

interface _SHA384 : IDispatch {
  mixin(ууид("b60ad5d7-2c2e-35b7-8d77-7946156cfe8e"));
}

interface _SHA384Managed : IDispatch {
  mixin(ууид("de541460-f838-3698-b2da-510b09070118"));
}

interface _SHA512 : IDispatch {
  mixin(ууид("49dd9e4b-84f3-3d6d-91fb-3fedcef634c7"));
}

interface _SHA512Managed : IDispatch {
  mixin(ууид("dc8ce439-7954-36ed-803c-674f72f27249"));
}

interface _SignatureDescription : IDispatch {
  mixin(ууид("8017b414-4886-33da-80a3-7865c1350d43"));
}

interface _TripleDES : IDispatch {
  mixin(ууид("c040b889-5278-3132-aff9-afa61707a81d"));
}

interface _TripleDESCryptoServiceProvider : IDispatch {
  mixin(ууид("ec69d083-3cd0-3c0c-998c-3b738db535d5"));
}

interface _X509Certificate : IDispatch {
  mixin(ууид("68fd6f14-a7b2-36c8-a724-d01f90d73477"));
}

// CoClasses

abstract final class NObject {
  mixin(ууид("81c5fe01-027c-3e1c-98d5-da9c9862aa21"));
  mixin Интерфейсы!(_Object);
}
alias NObject Object;

abstract final class NException {
  mixin(ууид("a1c0a095-df97-3441-bfc1-c9f194e494db"));
  mixin Интерфейсы!(_Object, ISerializable, _Exception);
}
alias NException Exception;

abstract final class StringBuilder {
  mixin(ууид("e724b749-18d6-36ab-9f6d-09c36d9c6016"));
  mixin Интерфейсы!(_StringBuilder, _Object, ISerializable);
}

abstract final class SystemException {
  mixin(ууид("4224ac84-9b11-3561-8923-c893ca77acbe"));
  mixin Интерфейсы!(_SystemException, _Object, ISerializable, _Exception);
}

abstract final class OutOfMemoryException {
  mixin(ууид("ccf306ae-33bd-3003-9cce-daf5befef611"));
  mixin Интерфейсы!(_OutOfMemoryException, _Object, ISerializable, _Exception);
}

abstract final class StackПереполнИскл {
  mixin(ууид("9c125a6f-eae2-3fc1-97a1-c0dceab0b5df"));
  mixin Интерфейсы!(_StackПереполнИскл, _Object, ISerializable, _Exception);
}

abstract final class DataMisalignedException {
  mixin(ууид("aad4bdd3-81aa-3abc-b53b-d904d25bc01e"));
  mixin Интерфейсы!(_DataMisalignedException, _Object, ISerializable, _Exception);
}

abstract final class ExecutionEngineException {
  mixin(ууид("e786fb32-b659-3d96-94c4-e1a9fc037868"));
  mixin Интерфейсы!(_ExecutionEngineException, _Object, ISerializable, _Exception);
}

abstract final class MemberAccessException {
  mixin(ууид("0ff66430-c796-3ee7-902b-166c402ca288"));
  mixin Интерфейсы!(_MemberAccessException, _Object, ISerializable, _Exception);
}

abstract final class AccessViolationException {
  mixin(ууид("4c3ebfd5-fc72-33dc-bc37-9953eb25b8d7"));
  mixin Интерфейсы!(_AccessViolationException, _Object, ISerializable, _Exception);
}

abstract final class ApplicationActivator {
  mixin(ууид("1d09b407-a97f-378a-accb-82ca0082f9f3"));
  mixin Интерфейсы!(_ApplicationActivator, _Object);
}

abstract final class ApplicationException {
  mixin(ууид("682d63b8-1692-31be-88cd-5cb1f79edb7b"));
  mixin Интерфейсы!(_ApplicationException, _Object, ISerializable, _Exception);
}

abstract final class EventArgs {
  mixin(ууид("3fb717af-9d21-3016-871a-df817abddd51"));
  mixin Интерфейсы!(_EventArgs, _Object);
}

abstract final class AppDomainManager {
  mixin(ууид("c03880a5-0b5e-39ad-954a-ce0dcbd5ef7d"));
  mixin Интерфейсы!(_AppDomainManager, _Object);
}

abstract final class AppDomainSetup {
  mixin(ууид("3e8e0f03-d3fd-3a93-bae0-c74a6494dbca"));
  mixin Интерфейсы!(_Object, IAppDomainSetup);
}

abstract final class AppDomainUnloadedException {
  mixin(ууид("61b3e12b-3586-3a58-a497-7ed7c4c794b9"));
  mixin Интерфейсы!(_AppDomainUnloadedException, _Object, ISerializable, _Exception);
}

abstract final class АргИскл {
  mixin(ууид("3fdceec6-b14b-37e2-bb69-abc7ca0da22f"));
  mixin Интерфейсы!(_АргИскл, _Object, ISerializable, _Exception);
}

abstract final class ПустойАргИскл {
  mixin(ууид("3bd1f243-9bc4-305d-9b1c-0d10c80329fc"));
  mixin Интерфейсы!(_ПустойАргИскл, _Object, ISerializable, _Exception);
}

abstract final class АргВнеИскл {
  mixin(ууид("74bdd0b9-38d7-3fda-a67e-d404ee684f24"));
  mixin Интерфейсы!(_АргВнеИскл, _Object, ISerializable, _Exception);
}

abstract final class МатИскл {
  mixin(ууид("647053c3-1879-34d7-ae57-67015c91fc70"));
  mixin Интерфейсы!(_МатИскл, _Object, ISerializable, _Exception);
}

abstract final class ArrayTypeMismatchException {
  mixin(ууид("676e1164-752c-3a74-8d3f-bcd32a2026d6"));
  mixin Интерфейсы!(_ArrayTypeMismatchException, _Object, ISerializable, _Exception);
}

abstract final class BadImageФорматИскл {
  mixin(ууид("e9148312-a9bf-3a45-bbca-350967fd78f5"));
  mixin Интерфейсы!(_BadImageФорматИскл, _Object, ISerializable, _Exception);
}

abstract final class CannotUnloadAppDomainException {
  mixin(ууид("29c69707-875f-3678-8f01-283094a2dfb1"));
  mixin Интерфейсы!(_CannotUnloadAppDomainException, _Object, ISerializable, _Exception);
}

abstract final class TypeUnloadedException {
  mixin(ууид("d6d2034d-5f67-30d7-9cc5-452f2c46694f"));
  mixin Интерфейсы!(_TypeUnloadedException, _Object, ISerializable, _Exception);
}

abstract final class ContextMarshalException {
  mixin(ууид("cbeaa915-4d2c-3f77-98e8-a258b0fd3cef"));
  mixin Интерфейсы!(_ContextMarshalException, _Object, ISerializable, _Exception);
}

abstract final class ContextStaticAttribute {
  mixin(ууид("96705ee3-f7ab-3e9a-9fb2-ad1d536e901a"));
  mixin Интерфейсы!(_ContextStaticAttribute, _Object, _Attribute);
}

abstract final class DivideByZeroException {
  mixin(ууид("f6914a11-d95d-324f-ba0f-39a374625290"));
  mixin Интерфейсы!(_DivideByZeroException, _Object, ISerializable, _Exception);
}

abstract final class DuplicateWaitObjectException {
  mixin(ууид("cc20c6df-a054-3f09-a5f5-a3b5a25f4ce6"));
  mixin Интерфейсы!(_DuplicateWaitObjectException, _Object, ISerializable, _Exception);
}

abstract final class TypeLoadException {
  mixin(ууид("112bc2e7-9ef9-3648-af9e-45c0d4b89929"));
  mixin Интерфейсы!(_TypeLoadException, _Object, ISerializable, _Exception);
}

abstract final class EntryPointNotFoundException {
  mixin(ууид("ad326409-bf80-3e0c-ba6f-ee2c33b675a5"));
  mixin Интерфейсы!(_EntryPointNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class DllNotFoundException {
  mixin(ууид("46e97093-b2ec-3787-a9a5-470d1a27417c"));
  mixin Интерфейсы!(_DllNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class FieldAccessException {
  mixin(ууид("bda7bee5-85f1-3b66-b610-ddf1d5898006"));
  mixin Интерфейсы!(_FieldAccessException, _Object, ISerializable, _Exception);
}

abstract final class FlagsAttribute {
  mixin(ууид("66ce75d4-0334-3ca6-bca8-ce9af28a4396"));
  mixin Интерфейсы!(_FlagsAttribute, _Object, _Attribute);
}

abstract final class ФорматИскл {
  mixin(ууид("964aa3bd-4b12-3e23-9d7f-99342afae812"));
  mixin Интерфейсы!(_ФорматИскл, _Object, ISerializable, _Exception);
}

abstract final class IndexOutOfRangeException {
  mixin(ууид("5ca9971b-2dc3-3bc8-847a-5e6d15cbb16e"));
  mixin Интерфейсы!(_IndexOutOfRangeException, _Object, ISerializable, _Exception);
}

abstract final class КастИскл {
  mixin(ууид("7f6bcbe5-eb30-370b-9f1b-92a6265afedd"));
  mixin Интерфейсы!(_КастИскл, _Object, ISerializable, _Exception);
}

abstract final class ОпИскл {
  mixin(ууид("9546306b-1b68-33af-80db-3a9206501515"));
  mixin Интерфейсы!(_ОпИскл, _Object, ISerializable, _Exception);
}

abstract final class InvalidProgramException {
  mixin(ууид("91591469-efef-3d63-90f9-88520f0aa1ef"));
  mixin Интерфейсы!(_InvalidProgramException, _Object, ISerializable, _Exception);
}

abstract final class MethodAccessException {
  mixin(ууид("92e76a74-2622-3aa9-a3ca-1ae8bd7bc4a8"));
  mixin Интерфейсы!(_MethodAccessException, _Object, ISerializable, _Exception);
}

abstract final class MissingMemberException {
  mixin(ууид("cdc70043-d56b-3799-b7bd-6113bbca160a"));
  mixin Интерфейсы!(_MissingMemberException, _Object, ISerializable, _Exception);
}

abstract final class MissingFieldException {
  mixin(ууид("8d36569b-14d6-3c3d-b55c-9d02a45bfc3d"));
  mixin Интерфейсы!(_MissingFieldException, _Object, ISerializable, _Exception);
}

abstract final class MissingMethodException {
  mixin(ууид("58897d76-ef6c-327a-93f7-6cd66c424e11"));
  mixin Интерфейсы!(_MissingMethodException, _Object, ISerializable, _Exception);
}

abstract final class MulticastНеПоддерживаетсяИскл {
  mixin(ууид("9da2f8b8-59f0-3852-b509-0663e3bf643b"));
  mixin Интерфейсы!(_MulticastНеПоддерживаетсяИскл, _Object, ISerializable, _Exception);
}

abstract final class NonSerializedAttribute {
  mixin(ууид("cc77f5f3-222d-3586-88c3-410477a3b65d"));
  mixin Интерфейсы!(_NonSerializedAttribute, _Object, _Attribute);
}

abstract final class NotFiniteNumberException {
  mixin(ууид("7e34ab89-0684-3b86-8a0f-e638eb4e6252"));
  mixin Интерфейсы!(_NotFiniteNumberException, _Object, ISerializable, _Exception);
}

abstract final class NotImplementedException {
  mixin(ууид("f8be2ad5-4e99-3e00-b10e-7c54d31c1c1d"));
  mixin Интерфейсы!(_NotImplementedException, _Object, ISerializable, _Exception);
}

abstract final class НеПоддерживаетсяИскл {
  mixin(ууид("dafb2462-2a5b-3818-b17e-602984fe1bb0"));
  mixin Интерфейсы!(_НеПоддерживаетсяИскл, _Object, ISerializable, _Exception);
}

abstract final class НулСсылкаИскл {
  mixin(ууид("7f71db2d-1ea0-3cae-8087-26095f5215e6"));
  mixin Интерфейсы!(_НулСсылкаИскл, _Object, ISerializable, _Exception);
}

abstract final class ObsoleteAttribute {
  mixin(ууид("08295c62-7462-3633-b35e-7ae68aca3948"));
  mixin Интерфейсы!(_ObsoleteAttribute, _Object, _Attribute);
}

abstract final class OperationCanceledException {
  mixin(ууид("11581718-2434-32e3-b559-e86ce9923744"));
  mixin Интерфейсы!(_OperationCanceledException, _Object, ISerializable, _Exception);
}

abstract final class ПереполнИскл {
  mixin(ууид("4286fa72-a2fa-3245-8751-d4206070a191"));
  mixin Интерфейсы!(_ПереполнИскл, _Object, ISerializable, _Exception);
}

abstract final class ParamArrayAttribute {
  mixin(ууид("3495e5fa-2a90-3ca7-b3b5-58736c4441dd"));
  mixin Интерфейсы!(_ParamArrayAttribute, _Object, _Attribute);
}

abstract final class PlatformНеПоддерживаетсяИскл {
  mixin(ууид("a36738b5-fa8f-3316-a929-68099a32b43b"));
  mixin Интерфейсы!(_PlatformНеПоддерживаетсяИскл, _Object, ISerializable, _Exception);
}

abstract final class Random {
  mixin(ууид("4e77ec8f-51d8-386c-85fe-7dc931b7a8e7"));
  mixin Интерфейсы!(_Random, _Object);
}

abstract final class RankException {
  mixin(ууид("c9f61cbd-287f-3d24-9feb-2c3f347cf570"));
  mixin Интерфейсы!(_RankException, _Object, ISerializable, _Exception);
}

abstract final class SerializableAttribute {
  mixin(ууид("89bcc804-53a5-3eb2-a342-6282cc410260"));
  mixin Интерфейсы!(_SerializableAttribute, _Object, _Attribute);
}

abstract final class STAThreadAttribute {
  mixin(ууид("50aad4c2-61fa-3b1f-8157-5ba3b27aee61"));
  mixin Интерфейсы!(_STAThreadAttribute, _Object, _Attribute);
}

abstract final class MTAThreadAttribute {
  mixin(ууид("b406ac70-4d7e-3d24-b241-aeaeac343bd9"));
  mixin Интерфейсы!(_MTAThreadAttribute, _Object, _Attribute);
}

abstract final class TimeoutException {
  mixin(ууид("eaa78d4a-20a3-3fde-ab72-d3d55e3aefe6"));
  mixin Интерфейсы!(_TimeoutException, _Object, ISerializable, _Exception);
}

abstract final class ВзломИскл {
  mixin(ууид("75215200-a2fe-30f6-a34b-8f1a1830358e"));
  mixin Интерфейсы!(_ВзломИскл, _Object, ISerializable, _Exception);
}

abstract final class Version {
  mixin(ууид("43cd41ad-3b78-3531-9031-3059e0aa64eb"));
  mixin Интерфейсы!(_Version, _Object, ICloneable, IComparable);
}

abstract final class Mutex {
  mixin(ууид("d74d613d-f27f-311b-a9a3-27ebc63a1a5d"));
  mixin Интерфейсы!(_Mutex, _Object, IDisposable);
}

abstract final class Overlapped {
  mixin(ууид("7fe87a55-1321-3d9f-8fef-cd2f5e8ab2e9"));
  mixin Интерфейсы!(_Overlapped, _Object);
}

abstract final class ReaderWriterLock {
  mixin(ууид("9173d971-b142-38a5-8488-d10a9dcf71b0"));
  mixin Интерфейсы!(_ReaderWriterLock, _Object);
}

abstract final class SynchronizationLockException {
  mixin(ууид("48a75519-cb7a-3d18-b91e-be62ee842a3e"));
  mixin Интерфейсы!(_SynchronizationLockException, _Object, ISerializable, _Exception);
}

abstract final class ThreadInterruptedException {
  mixin(ууид("27e986e1-baec-3d48-82e4-14169ca8cecf"));
  mixin Интерфейсы!(_ThreadInterruptedException, _Object, ISerializable, _Exception);
}

abstract final class ThreadStateException {
  mixin(ууид("3e5509f0-1fb9-304d-8174-75d6c9afe5da"));
  mixin Интерфейсы!(_ThreadStateException, _Object, ISerializable, _Exception);
}

abstract final class ThreadStaticAttribute {
  mixin(ууид("ffc9f9ae-e87a-3252-8e25-b22423a40065"));
  mixin Интерфейсы!(_ThreadStaticAttribute, _Object, _Attribute);
}

abstract final class CaseInsensitiveComparer {
  mixin(ууид("35e946e4-7cda-3824-8b24-d799a96309ad"));
  mixin Интерфейсы!(_CaseInsensitiveComparer, _Object, IComparer);
}

abstract final class CaseInsensitiveHashCodeProvider {
  mixin(ууид("47d3c68d-7d85-3227-a9e7-88451d6badfc"));
  mixin Интерфейсы!(_CaseInsensitiveHashCodeProvider, _Object, IHashCodeProvider);
}

abstract final class Queue {
  mixin(ууид("7f976b72-4b71-3858-bee8-8e3a3189a651"));
  mixin Интерфейсы!(_Queue, _Object, ICollection, IEnumerable, ICloneable);
}

abstract final class ArrayList {
  mixin(ууид("6896b49d-7afb-34dc-934e-5add38eeee39"));
  mixin Интерфейсы!(_ArrayList, _Object, IList, ICollection, IEnumerable, ICloneable);
}

abstract final class Stack {
  mixin(ууид("4599202d-460f-3fb7-8a1c-c2cc6ed6c7c8"));
  mixin Интерфейсы!(_Stack, _Object, ICollection, IEnumerable, ICloneable);
}

abstract final class Hashtable {
  mixin(ууид("146855fa-309f-3d0e-bb3e-df525f30a715"));
  mixin Интерфейсы!(_Hashtable, _Object, IDictionary, ICollection, IEnumerable, ISerializable, IDeserializationCallback, ICloneable);
}

abstract final class SortedList {
  mixin(ууид("026cc6d7-34b2-33d5-b551-ca31eb6ce345"));
  mixin Интерфейсы!(_SortedList, _Object, IDictionary, ICollection, IEnumerable, ICloneable);
}

abstract final class KeyNotFoundException {
  mixin(ууид("0d52abe3-3c93-3d94-a744-ac44850baccd"));
  mixin Интерфейсы!(_KeyNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class Debugger {
  mixin(ууид("91f672a3-6b82-3e04-b2d7-bac5d6676609"));
  mixin Интерфейсы!(_Debugger, _Object);
}

abstract final class DebuggerStepThroughAttribute {
  mixin(ууид("93f551d6-2f9e-301b-be63-85aef508cae0"));
  mixin Интерфейсы!(_DebuggerStepThroughAttribute, _Object, _Attribute);
}

abstract final class DebuggerStepperBoundaryAttribute {
  mixin(ууид("1b979846-aaeb-314b-8e63-d44ef1cb9efc"));
  mixin Интерфейсы!(_DebuggerStepperBoundaryAttribute, _Object, _Attribute);
}

abstract final class DebuggerHiddenAttribute {
  mixin(ууид("41970d73-92f6-36d9-874d-3bd0762a0d6f"));
  mixin Интерфейсы!(_DebuggerHiddenAttribute, _Object, _Attribute);
}

abstract final class DebuggerNonUserCodeAttribute {
  mixin(ууид("29625281-51ce-3f8a-ac4d-e360cacb92e2"));
  mixin Интерфейсы!(_DebuggerNonUserCodeAttribute, _Object, _Attribute);
}

abstract final class StackTrace {
  mixin(ууид("405c2d81-315b-3cb0-8442-ef5a38d4c3b8"));
  mixin Интерфейсы!(_StackTrace, _Object);
}

abstract final class StackFrame {
  mixin(ууид("14910622-09d4-3b4a-8c1e-9991dbdcc553"));
  mixin Интерфейсы!(_StackFrame, _Object);
}

abstract final class SymDocumentType {
  mixin(ууид("40ae2088-ce00-33ad-9320-5d201cb46fc9"));
  mixin Интерфейсы!(_SymDocumentType, _Object);
}

abstract final class SymLanguageType {
  mixin(ууид("5a18d43e-115b-3b8b-8245-9a06b204b717"));
  mixin Интерфейсы!(_SymLanguageType, _Object);
}

abstract final class SymLanguageVendor {
  mixin(ууид("dfd888a7-a6b0-3b1b-985e-4cdab0e4c17d"));
  mixin Интерфейсы!(_SymLanguageVendor, _Object);
}

abstract final class AmbiguousMatchException {
  mixin(ууид("2846ae5e-a9fa-36cf-b2d1-6e95596dbde7"));
  mixin Интерфейсы!(_AmbiguousMatchException, _Object, ISerializable, _Exception);
}

abstract final class AssemblyName {
  mixin(ууид("f12fde6a-9394-3c32-8e4d-f3d470947284"));
  mixin Интерфейсы!(_Object, _AssemblyName, ICloneable, ISerializable, IDeserializationCallback);
}

abstract final class AssemblyNameProxy {
  mixin(ууид("3f4a4283-6a08-3e90-a976-2c2d3be4eb0b"));
  mixin Интерфейсы!(_AssemblyNameProxy, _Object);
}

abstract final class CustomAttributeФорматИскл {
  mixin(ууид("d5cb383d-99f4-3c7e-a9c3-85b53661448f"));
  mixin Интерфейсы!(_CustomAttributeФорматИскл, _Object, ISerializable, _Exception);
}

abstract final class InvalidFilterCriteriaException {
  mixin(ууид("7b938a6f-77bf-351c-a712-69483c91115d"));
  mixin Интерфейсы!(_InvalidFilterCriteriaException, _Object, ISerializable, _Exception);
}

abstract final class ObfuscationAttribute {
  mixin(ууид("93d11de9-5f6c-354a-a7c5-16ccca64a9b8"));
  mixin Интерфейсы!(_ObfuscationAttribute, _Object, _Attribute);
}

abstract final class TargetException {
  mixin(ууид("0d23f8b4-f2a6-3eff-9d37-bdf79ac6b440"));
  mixin Интерфейсы!(_TargetException, _Object, ISerializable, _Exception);
}

abstract final class TargetParameterCountException {
  mixin(ууид("da317be2-1a0d-37b3-83f2-a0f32787fc67"));
  mixin Интерфейсы!(_TargetParameterCountException, _Object, ISerializable, _Exception);
}

abstract final class FormatterConverter {
  mixin(ууид("d23d2f41-1d69-3e03-a275-32ae381223ac"));
  mixin Интерфейсы!(_FormatterConverter, _Object, IFormatterConverter);
}

abstract final class OptionalFieldAttribute {
  mixin(ууид("1c97ef1d-74ed-3d21-84a4-8631d959634a"));
  mixin Интерфейсы!(_OptionalFieldAttribute, _Object, _Attribute);
}

abstract final class OnSerializingAttribute {
  mixin(ууид("9bf86f6e-b0e1-348b-9627-6970672eb3d3"));
  mixin Интерфейсы!(_OnSerializingAttribute, _Object, _Attribute);
}

abstract final class OnSerializedAttribute {
  mixin(ууид("6f8527bf-5aad-3236-b639-a05177332efe"));
  mixin Интерфейсы!(_OnSerializedAttribute, _Object, _Attribute);
}

abstract final class OnDeserializingAttribute {
  mixin(ууид("30ac0b94-3bdb-3199-8a5d-eca0c5458381"));
  mixin Интерфейсы!(_OnDeserializingAttribute, _Object, _Attribute);
}

abstract final class OnDeserializedAttribute {
  mixin(ууид("18b1c7ee-68e3-35bb-9e40-469a223285f7"));
  mixin Интерфейсы!(_OnDeserializedAttribute, _Object, _Attribute);
}

abstract final class SerializationException {
  mixin(ууид("57154c7c-edb2-3bfd-a8ba-924c60913ebf"));
  mixin Интерфейсы!(_SerializationException, _Object, ISerializable, _Exception);
}

abstract final class ObjectIDGenerator {
  mixin(ууид("4f272c37-f0a8-350c-867b-2c03b2b16b80"));
  mixin Интерфейсы!(_ObjectIDGenerator, _Object);
}

abstract final class SurrogateSelector {
  mixin(ууид("88c8a919-eb24-3cca-84f7-2ea82bb3f3ed"));
  mixin Интерфейсы!(_SurrogateSelector, _Object, ISurrogateSelector);
}

abstract final class CultureNotFoundException {
  mixin(ууид("5df1ce00-4ebd-3f48-887a-c4bcca7ad912"));
  mixin Интерфейсы!(_CultureNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class DateTimeFormatInfo {
  mixin(ууид("70a738d1-1bc5-3175-bd42-603e2b82c08b"));
  mixin Интерфейсы!(_DateTimeFormatInfo, _Object, ICloneable, IFormatProvider);
}

abstract final class GregorianCalendar {
  mixin(ууид("68f8aea9-1968-35b9-8a0e-6fdc637a4f8e"));
  mixin Интерфейсы!(_GregorianCalendar, _Object, ICloneable);
}

abstract final class HebrewCalendar {
  mixin(ууид("2206d773-ca1c-3258-9456-ceb7706c3710"));
  mixin Интерфейсы!(_HebrewCalendar, _Object, ICloneable);
}

abstract final class HijriCalendar {
  mixin(ууид("ee832ce3-06ca-33ef-8f01-61c7c218bd7e"));
  mixin Интерфейсы!(_HijriCalendar, _Object, ICloneable);
}

abstract final class JulianCalendar {
  mixin(ууид("5c3e6ce8-b218-3762-883c-91bc987cdc2d"));
  mixin Интерфейсы!(_JulianCalendar, _Object, ICloneable);
}

abstract final class JapaneseCalendar {
  mixin(ууид("374050dd-6190-3257-8812-8230bf095147"));
  mixin Интерфейсы!(_JapaneseCalendar, _Object, ICloneable);
}

abstract final class KoreanCalendar {
  mixin(ууид("1a06a4dc-e239-3717-89e1-d0683f3a5320"));
  mixin Интерфейсы!(_KoreanCalendar, _Object, ICloneable);
}

abstract final class StringInfo {
  mixin(ууид("31c967b5-2f8a-3957-9c6d-34a0731db36c"));
  mixin Интерфейсы!(_StringInfo, _Object);
}

abstract final class TaiwanCalendar {
  mixin(ууид("769b8b68-64f7-3b61-b744-160a9fcc3216"));
  mixin Интерфейсы!(_TaiwanCalendar, _Object, ICloneable);
}

abstract final class ThaiBuddhistCalendar {
  mixin(ууид("ec3dac94-df80-3017-b381-b13dced6c4d8"));
  mixin Интерфейсы!(_ThaiBuddhistCalendar, _Object, ICloneable);
}

abstract final class NumberFormatInfo {
  mixin(ууид("146a47ab-a2cf-3587-bb25-2b286d7566b4"));
  mixin Интерфейсы!(_NumberFormatInfo, _Object, ICloneable, IFormatProvider);
}

abstract final class ASCIIEncoding {
  mixin(ууид("9e28ef95-9c6f-3a00-b525-36a76178cc9c"));
  mixin Интерфейсы!(_ASCIIEncoding, _Object, ICloneable);
}

abstract final class UnicodeEncoding {
  mixin(ууид("a0f5f5dc-337b-38d7-b1a3-fb1b95666bbf"));
  mixin Интерфейсы!(_UnicodeEncoding, _Object, ICloneable);
}

abstract final class UTF7Encoding {
  mixin(ууид("3c9dca8b-4410-3143-b801-559553eb6725"));
  mixin Интерфейсы!(_UTF7Encoding, _Object, ICloneable);
}

abstract final class UTF8Encoding {
  mixin(ууид("8c40d44a-4ede-3760-9b61-50255056d3c7"));
  mixin Интерфейсы!(_UTF8Encoding, _Object, ICloneable);
}

abstract final class MissingManifestResourceException {
  mixin(ууид("726bbdf4-6c6d-30f4-b3a0-f14d6aec08c7"));
  mixin Интерфейсы!(_MissingManifestResourceException, _Object, ISerializable, _Exception);
}

abstract final class MissingSatelliteAssemblyException {
  mixin(ууид("d41969a6-c394-34b9-bd24-dd408f39f261"));
  mixin Интерфейсы!(_MissingSatelliteAssemblyException, _Object, ISerializable, _Exception);
}

abstract final class AllMembershipCondition {
  mixin(ууид("06b81c12-a5da-340d-aff7-fa1453fbc29a"));
  mixin Интерфейсы!(_AllMembershipCondition, _Object, IMembershipCondition, ISecurityEncodable, ISecurityPolicyEncodable);
}

abstract final class ApplicationDirectoryMembershipCondition {
  mixin(ууид("3ddb2114-9285-30a6-906d-b117640ca927"));
  mixin Интерфейсы!(_ApplicationDirectoryMembershipCondition, _Object, IMembershipCondition, ISecurityEncodable, ISecurityPolicyEncodable);
}

abstract final class ApplicationTrust {
  mixin(ууид("a5448b7a-aa07-3c56-b42b-7d881fa10934"));
  mixin Интерфейсы!(_ApplicationTrust, _Object, ISecurityEncodable);
}

abstract final class Evidence {
  mixin(ууид("62545937-20a9-3d0f-b04b-322e854eacb0"));
  mixin Интерфейсы!(_Evidence, _Object, ICollection, IEnumerable);
}

abstract final class TrustManagerContext {
  mixin(ууид("afaef10f-1bc4-351f-886a-878a265c1862"));
  mixin Интерфейсы!(_TrustManagerContext, _Object);
}

abstract final class PolicyException {
  mixin(ууид("89d26277-8408-3fc8-bd44-cf5f0e614c82"));
  mixin Интерфейсы!(_PolicyException, _Object, ISerializable, _Exception);
}

abstract final class GacInstalled {
  mixin(ууид("ee24a2c3-3aa2-33da-8731-a4fcc1105813"));
  mixin Интерфейсы!(_GacInstalled, _Object, IIdentityPermissionFactory);
}

abstract final class GacMembershipCondition {
  mixin(ууид("390e92c9-fa66-3357-bef2-45a1f34186b9"));
  mixin Интерфейсы!(_GacMembershipCondition, _Object, IMembershipCondition, ISecurityEncodable, ISecurityPolicyEncodable);
}

abstract final class ComRegisterFunctionAttribute {
  mixin(ууид("630a3ef1-23c6-31fe-9d25-294e3b3e7486"));
  mixin Интерфейсы!(_ComRegisterFunctionAttribute, _Object, _Attribute);
}

abstract final class ComUnregisterFunctionAttribute {
  mixin(ууид("8f45c7ff-1e6e-34c1-a7cc-260985392a05"));
  mixin Интерфейсы!(_ComUnregisterFunctionAttribute, _Object, _Attribute);
}

abstract final class ComConversionLossAttribute {
  mixin(ууид("8a3fd229-b2a9-347f-93d2-87f3b7f92753"));
  mixin Интерфейсы!(_ComConversionLossAttribute, _Object, _Attribute);
}

abstract final class ComImportAttribute {
  mixin(ууид("f1eba909-6621-346d-9ce2-39f266c9d011"));
  mixin Интерфейсы!(_ComImportAttribute, _Object, _Attribute);
}

abstract final class PreserveSigAttribute {
  mixin(ууид("204d5a28-46a0-3f04-bd7c-b5672631e57f"));
  mixin Интерфейсы!(_PreserveSigAttribute, _Object, _Attribute);
}

abstract final class InAttribute {
  mixin(ууид("96a058cd-faf7-386c-85bf-e47f00c81795"));
  mixin Интерфейсы!(_InAttribute, _Object, _Attribute);
}

abstract final class OutAttribute {
  mixin(ууид("fdb2dc94-b5a0-3702-ae84-bbfa752acb36"));
  mixin Интерфейсы!(_OutAttribute, _Object, _Attribute);
}

abstract final class OptionalAttribute {
  mixin(ууид("b81cb5ed-e654-399f-9698-c83c50665786"));
  mixin Интерфейсы!(_OptionalAttribute, _Object, _Attribute);
}

abstract final class SetWin32ContextInIDispatchAttribute {
  mixin(ууид("9d309f77-4655-372e-84b0-b0fb4030f3b8"));
  mixin Интерфейсы!(_SetWin32ContextInIDispatchAttribute, _Object, _Attribute);
}

abstract final class ExternalException {
  mixin(ууид("afc681cf-e82f-361a-8280-cf4e1f844c3e"));
  mixin Интерфейсы!(_ExternalException, _Object, ISerializable, _Exception);
}

abstract final class COMException {
  mixin(ууид("07f94112-a42e-328b-b508-702ef62bcc29"));
  mixin Интерфейсы!(_COMException, _Object, ISerializable, _Exception);
}

abstract final class InvalidOleVariantTypeException {
  mixin(ууид("9a944885-edaf-3a81-a2ff-6a9d5d1abfc7"));
  mixin Интерфейсы!(_InvalidOleVariantTypeException, _Object, ISerializable, _Exception);
}

abstract final class MarshalDirectiveException {
  mixin(ууид("742ad1fb-b2f0-3681-b4aa-e736a3bce4e1"));
  mixin Интерфейсы!(_MarshalDirectiveException, _Object, ISerializable, _Exception);
}

abstract final class RuntimeEnvironment {
  mixin(ууид("78d22140-40cf-303e-be96-b3ac0407a34d"));
  mixin Интерфейсы!(_RuntimeEnvironment, _Object);
}

abstract final class SEHException {
  mixin(ууид("ca805b13-468c-3a22-bf9a-818e97efa6b7"));
  mixin Интерфейсы!(_SEHException, _Object, ISerializable, _Exception);
}

abstract final class InvalidComObjectException {
  mixin(ууид("a7248ec6-a8a5-3d07-890e-6107f8c247e5"));
  mixin Интерфейсы!(_InvalidComObjectException, _Object, ISerializable, _Exception);
}

abstract final class RegistrationServices {
  mixin(ууид("475e398f-8afa-43a7-a3be-f4ef8d6787c9"));
  mixin Интерфейсы!(_Object, IRegistrationServices);
}

abstract final class SafeArrayRankMismatchException {
  mixin(ууид("4be89ac3-603d-36b2-ab9b-9c38866f56d5"));
  mixin Интерфейсы!(_SafeArrayRankMismatchException, _Object, ISerializable, _Exception);
}

abstract final class SafeArrayTypeMismatchException {
  mixin(ууид("2d5ec63c-1b3e-3ee4-9052-eb0d0303549c"));
  mixin Интерфейсы!(_SafeArrayTypeMismatchException, _Object, ISerializable, _Exception);
}

abstract final class TypeLibConverter {
  mixin(ууид("f1c3bf79-c3e4-11d3-88e7-00902754c43a"));
  mixin Интерфейсы!(_Object, ITypeLibConverter);
}

abstract final class IOException {
  mixin(ууид("a164c0bf-67ae-3c7e-bc05-bfe24a8cdb62"));
  mixin Интерфейсы!(_IOException, _Object, ISerializable, _Exception);
}

abstract final class DirectoryNotFoundException {
  mixin(ууид("8833bc41-dc6b-34b9-a799-682d2554f02f"));
  mixin Интерфейсы!(_DirectoryNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class DriveNotFoundException {
  mixin(ууид("a8f9f740-70c9-30a7-937c-59785a9bb5a4"));
  mixin Интерфейсы!(_DriveNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class EndOfStreamException {
  mixin(ууид("58d052bc-a3df-3508-ac95-ff297bdc9f0c"));
  mixin Интерфейсы!(_EndOfStreamException, _Object, ISerializable, _Exception);
}

abstract final class FileLoadException {
  mixin(ууид("af8c5f8a-9999-3e92-bb41-c5f4955174cd"));
  mixin Интерфейсы!(_FileLoadException, _Object, ISerializable, _Exception);
}

abstract final class FileNotFoundException {
  mixin(ууид("48c6e96f-a2f3-33e7-ba7f-c8f74866760b"));
  mixin Интерфейсы!(_FileNotFoundException, _Object, ISerializable, _Exception);
}

abstract final class MemoryStream {
  mixin(ууид("f5e692d9-8a87-349d-9657-f96e5799d2f4"));
  mixin Интерфейсы!(_MemoryStream, _Object, IDisposable);
}

abstract final class PathTooLongException {
  mixin(ууид("c016a313-9606-36d3-a823-33ebf5006189"));
  mixin Интерфейсы!(_PathTooLongException, _Object, ISerializable, _Exception);
}

abstract final class StringWriter {
  mixin(ууид("27f31d55-d6c6-3676-9d42-c40f3a918636"));
  mixin Интерфейсы!(_StringWriter, _Object, IDisposable);
}

abstract final class CallConvCdecl {
  mixin(ууид("a3a1f076-1fa7-3a26-886d-8841cb45382f"));
  mixin Интерфейсы!(_CallConvCdecl, _Object);
}

abstract final class CallConvStdcall {
  mixin(ууид("bcb67d4d-2096-36be-974c-a003fc95041b"));
  mixin Интерфейсы!(_CallConvStdcall, _Object);
}

abstract final class CallConvThiscall {
  mixin(ууид("46080ca7-7cb8-3a55-a72e-8e50eca4d4fc"));
  mixin Интерфейсы!(_CallConvThiscall, _Object);
}

abstract final class CallConvFastcall {
  mixin(ууид("ed0bc45c-2438-31a9-bbb6-e2a3b5916419"));
  mixin Интерфейсы!(_CallConvFastcall, _Object);
}

abstract final class DiscardableAttribute {
  mixin(ууид("837a6733-1675-3bc9-bbf8-13889f84daf4"));
  mixin Интерфейсы!(_DiscardableAttribute, _Object, _Attribute);
}

abstract final class CompilerGlobalScopeAttribute {
  mixin(ууид("4b601364-a04b-38bc-bd38-a18e981324cf"));
  mixin Интерфейсы!(_CompilerGlobalScopeAttribute, _Object, _Attribute);
}

abstract final class MethodImplAttribute {
  mixin(ууид("48d0cfe7-3128-3d2c-a5b5-8c7b82b4ab4f"));
  mixin Интерфейсы!(_MethodImplAttribute, _Object, _Attribute);
}

abstract final class NativeCppClassAttribute {
  mixin(ууид("c437ab2e-865b-321d-ba15-0c8ec4ca119b"));
  mixin Интерфейсы!(_NativeCppClassAttribute, _Object, _Attribute);
}

abstract final class IDispatchConstantAttribute {
  mixin(ууид("e947a0b0-d47f-3aa3-9b77-4624e0f3aca4"));
  mixin Интерфейсы!(_IDispatchConstantAttribute, _Object, _Attribute);
}

abstract final class IUnknownConstantAttribute {
  mixin(ууид("590e4a07-dafc-3be7-a178-da349bba980b"));
  mixin Интерфейсы!(_IUnknownConstantAttribute, _Object, _Attribute);
}

abstract final class XmlSyntaxException {
  mixin(ууид("e38da416-8050-3786-8201-46f187c15213"));
  mixin Интерфейсы!(_XmlSyntaxException, _Object, ISerializable, _Exception);
}

abstract final class HostProtectionAttribute {
  mixin(ууид("ad664904-fe8a-3217-bbf5-e6ab1d998f5f"));
  mixin Интерфейсы!(_HostProtectionAttribute, _Object, _Attribute);
}

abstract final class GacIdentityPermission {
  mixin(ууид("29a6cf6f-d663-31a7-9210-1347871681fc"));
  mixin Интерфейсы!(_GacIdentityPermission, _Object, IPermission, ISecurityEncodable, IStackWalk);
}

abstract final class SuppressUnmanagedCodeSecurityAttribute {
  mixin(ууид("7ae01d6c-bee7-38f6-9a86-329d8a917803"));
  mixin Интерфейсы!(_SuppressUnmanagedCodeSecurityAttribute, _Object, _Attribute);
}

abstract final class UnverifiableCodeAttribute {
  mixin(ууид("7e3393ab-2ab2-320b-8f6f-eab6f5cf2caf"));
  mixin Интерфейсы!(_UnverifiableCodeAttribute, _Object, _Attribute);
}

abstract final class AllowPartiallyTrustedCallersAttribute {
  mixin(ууид("5610f042-ff1d-36d0-996c-68f7a207d1f0"));
  mixin Интерфейсы!(_AllowPartiallyTrustedCallersAttribute, _Object, _Attribute);
}

abstract final class HostSecurityManager {
  mixin(ууид("84589833-40d7-36e2-8545-67a92b97c408"));
  mixin Интерфейсы!(_HostSecurityManager, _Object);
}

abstract final class БезопИскл {
  mixin(ууид("eef05c76-5c98-3685-a69c-6e1a26a7f846"));
  mixin Интерфейсы!(_БезопИскл, _Object, ISerializable, _Exception);
}

abstract final class HostProtectionException {
  mixin(ууид("ecc82a10-b731-3a01-8a17-ac0ddd7666cf"));
  mixin Интерфейсы!(_HostProtectionException, _Object, ISerializable, _Exception);
}

abstract final class VerificationException {
  mixin(ууид("ebaa029c-01c0-32b6-aae6-fe21adfc3e5d"));
  mixin Интерфейсы!(_VerificationException, _Object, ISerializable, _Exception);
}

abstract final class ClientChannelSinkStack {
  mixin(ууид("dd5856e5-8151-3334-b8e9-07cb152b20a4"));
  mixin Интерфейсы!(_ClientChannelSinkStack, _Object, IClientChannelSinkStack, IClientResponseChannelSinkStack);
}

abstract final class ServerChannelSinkStack {
  mixin(ууид("5c35f099-165e-3225-a3a5-564150ea17f5"));
  mixin Интерфейсы!(_ServerChannelSinkStack, _Object, IServerChannelSinkStack, IServerResponseChannelSinkStack);
}

abstract final class ClientSponsor {
  mixin(ууид("fd8c8fce-4f85-36b2-b8e8-f5a183654539"));
  mixin Интерфейсы!(_ClientSponsor, _Object, ISponsor);
}

abstract final class Context {
  mixin(ууид("a36e4eaf-ea3f-30a6-906d-374bbf7903b1"));
  mixin Интерфейсы!(_Context, _Object);
}

abstract final class EnterpriseServicesHelper {
  mixin(ууид("bc5062b6-79e8-3f19-a87e-f9daf826960c"));
  mixin Интерфейсы!(_EnterpriseServicesHelper, _Object);
}

abstract final class TransportHeaders {
  mixin(ууид("48728b3f-f7d9-36c1-b3e7-8bf2e63ce1b3"));
  mixin Интерфейсы!(_TransportHeaders, _Object, ITransportHeaders);
}

abstract final class LifetimeServices {
  mixin(ууид("8fd730c1-dd1b-3694-84a1-8ce7159e266b"));
  mixin Интерфейсы!(_LifetimeServices, _Object);
}

abstract final class ObjRef {
  mixin(ууид("21f5a790-53ea-3d73-86c3-a5ba6cf65fe9"));
  mixin Интерфейсы!(_ObjRef, _Object, IObjectReference, ISerializable);
}

abstract final class OneWayAttribute {
  mixin(ууид("c30abd41-7b5a-3d10-a6ef-56862e2979b6"));
  mixin Интерфейсы!(_OneWayAttribute, _Object, _Attribute);
}

abstract final class ProxyAttribute {
  mixin(ууид("1163d0ca-2a02-37c1-bf3f-a9b9e9d49245"));
  mixin Интерфейсы!(_ProxyAttribute, _Object, _Attribute, IContextAttribute);
}

abstract final class SoapAttribute {
  mixin(ууид("9b924ec5-bf13-3a98-8ac0-80877995d403"));
  mixin Интерфейсы!(_SoapAttribute, _Object, _Attribute);
}

abstract final class SoapTypeAttribute {
  mixin(ууид("9c67f424-22dc-3d05-ab36-17eaf95881f2"));
  mixin Интерфейсы!(_SoapTypeAttribute, _Object, _Attribute);
}

abstract final class SoapMethodAttribute {
  mixin(ууид("01ff4e4b-8ad0-3171-8c82-5c2f48b87e3d"));
  mixin Интерфейсы!(_SoapMethodAttribute, _Object, _Attribute);
}

abstract final class SoapFieldAttribute {
  mixin(ууид("5b76534c-3acc-3d52-aa61-d788b134abe2"));
  mixin Интерфейсы!(_SoapFieldAttribute, _Object, _Attribute);
}

abstract final class SoapParameterAttribute {
  mixin(ууид("c76b435d-86c2-30fd-9329-e2603246095c"));
  mixin Интерфейсы!(_SoapParameterAttribute, _Object, _Attribute);
}

abstract final class RemotingException {
  mixin(ууид("24540ebc-316e-35d2-80db-8a535caf6a35"));
  mixin Интерфейсы!(_RemotingException, _Object, ISerializable, _Exception);
}

abstract final class ServerException {
  mixin(ууид("db13821e-9835-3958-8539-1e021399ab6c"));
  mixin Интерфейсы!(_ServerException, _Object, ISerializable, _Exception);
}

abstract final class RemotingTimeoutException {
  mixin(ууид("3cded51a-86b4-39f0-a12a-5d1fdced6546"));
  mixin Интерфейсы!(_RemotingTimeoutException, _Object, ISerializable, _Exception);
}

abstract final class InternalRemotingServices {
  mixin(ууид("53a3c917-bb24-3908-b58b-09ecda99265f"));
  mixin Интерфейсы!(_InternalRemotingServices, _Object);
}

abstract final class RemotingSurrogateSelector {
  mixin(ууид("24eec005-3938-3c71-821d-7f68fd850b2d"));
  mixin Интерфейсы!(_RemotingSurrogateSelector, _Object, ISurrogateSelector);
}

abstract final class SoapDateTime {
  mixin(ууид("48ad62e8-bd40-37f4-8fd7-f7a17478a8e6"));
  mixin Интерфейсы!(_SoapDateTime, _Object);
}

abstract final class SoapDuration {
  mixin(ууид("de47d9cf-0107-3d66-93e9-a8acb06b4583"));
  mixin Интерфейсы!(_SoapDuration, _Object);
}

abstract final class SoapTime {
  mixin(ууид("d049dc2b-82c3-3350-a1cc-bf69fee3825e"));
  mixin Интерфейсы!(_SoapTime, _Object, ISoapXsd);
}

abstract final class SoapDate {
  mixin(ууид("2decbcb7-bac0-316d-9131-43035c5cb480"));
  mixin Интерфейсы!(_SoapDate, _Object, ISoapXsd);
}

abstract final class SoapYearMonth {
  mixin(ууид("a7136bdf-b141-3913-9d1c-9bc5aff21470"));
  mixin Интерфейсы!(_SoapYearMonth, _Object, ISoapXsd);
}

abstract final class SoapYear {
  mixin(ууид("75999eba-0679-3d43-bdc4-02e4d637f1b1"));
  mixin Интерфейсы!(_SoapYear, _Object, ISoapXsd);
}

abstract final class SoapMonthDay {
  mixin(ууид("463ae13f-c7e5-357e-a41c-df8762fff85c"));
  mixin Интерфейсы!(_SoapMonthDay, _Object, ISoapXsd);
}

abstract final class SoapDay {
  mixin(ууид("c9f0a842-3ce1-338f-a1d4-6d7bb397bdaa"));
  mixin Интерфейсы!(_SoapDay, _Object, ISoapXsd);
}

abstract final class SoapMonth {
  mixin(ууид("caec7d4f-0b02-3579-943f-821738ee78cc"));
  mixin Интерфейсы!(_SoapMonth, _Object, ISoapXsd);
}

abstract final class SoapHexBinary {
  mixin(ууид("8c1425c9-a7d3-35cd-8248-928ca52ad49b"));
  mixin Интерфейсы!(_SoapHexBinary, _Object, ISoapXsd);
}

abstract final class SoapBase64Binary {
  mixin(ууид("f59d514c-f200-319f-bf3f-9e4e23b2848c"));
  mixin Интерфейсы!(_SoapBase64Binary, _Object, ISoapXsd);
}

abstract final class SoapInteger {
  mixin(ууид("09a60795-31c0-3a79-9250-8d93c74fe540"));
  mixin Интерфейсы!(_SoapInteger, _Object, ISoapXsd);
}

abstract final class SoapPositiveInteger {
  mixin(ууид("7b769b29-35f0-3bdc-aae9-e99937f6cdec"));
  mixin Интерфейсы!(_SoapPositiveInteger, _Object, ISoapXsd);
}

abstract final class SoapNonPositiveInteger {
  mixin(ууид("2bb6c5e0-c2b9-3608-8868-21cfd6ddb91e"));
  mixin Интерфейсы!(_SoapNonPositiveInteger, _Object, ISoapXsd);
}

abstract final class SoapNonNegativeInteger {
  mixin(ууид("6850404f-d7fb-32bd-8328-c94f66e8c1c7"));
  mixin Интерфейсы!(_SoapNonNegativeInteger, _Object, ISoapXsd);
}

abstract final class SoapNegativeInteger {
  mixin(ууид("c41d0b30-a518-3093-a18f-364af9e71eb7"));
  mixin Интерфейсы!(_SoapNegativeInteger, _Object, ISoapXsd);
}

abstract final class SoapAnyUri {
  mixin(ууид("cdfa7117-b2a4-3a3f-b393-bc19d44f9749"));
  mixin Интерфейсы!(_SoapAnyUri, _Object, ISoapXsd);
}

abstract final class SoapQName {
  mixin(ууид("d8a4f3eb-e7ec-3620-831a-b052a67c9944"));
  mixin Интерфейсы!(_SoapQName, _Object, ISoapXsd);
}

abstract final class SoapNotation {
  mixin(ууид("b54e38f8-17ff-3d0a-9ff3-5e662de2055f"));
  mixin Интерфейсы!(_SoapNotation, _Object, ISoapXsd);
}

abstract final class SoapNormalizedString {
  mixin(ууид("0e71f9bd-c109-3352-bd60-14f96d56b6f3"));
  mixin Интерфейсы!(_SoapNormalizedString, _Object, ISoapXsd);
}

abstract final class SoapToken {
  mixin(ууид("777f668e-3272-39cd-a8b5-860935a35181"));
  mixin Интерфейсы!(_SoapToken, _Object, ISoapXsd);
}

abstract final class SoapLanguage {
  mixin(ууид("84f70b6c-d59e-394a-b879-ffcc30ddcaa2"));
  mixin Интерфейсы!(_SoapLanguage, _Object, ISoapXsd);
}

abstract final class SoapName {
  mixin(ууид("4e515531-7a71-3cdd-8078-0a01c85c8f9d"));
  mixin Интерфейсы!(_SoapName, _Object, ISoapXsd);
}

abstract final class SoapIdrefs {
  mixin(ууид("2763be6b-f8cf-39d9-a2e8-9e9815c0815e"));
  mixin Интерфейсы!(_SoapIdrefs, _Object, ISoapXsd);
}

abstract final class SoapEntities {
  mixin(ууид("9a3a64f4-8ba5-3dcf-880c-8d3ee06c5538"));
  mixin Интерфейсы!(_SoapEntities, _Object, ISoapXsd);
}

abstract final class SoapNmtoken {
  mixin(ууид("c498f2d9-a77c-3d4b-a1a5-12cc7b99115d"));
  mixin Интерфейсы!(_SoapNmtoken, _Object, ISoapXsd);
}

abstract final class SoapNmtokens {
  mixin(ууид("14be6b21-c682-3a3a-8b24-fee75b4ff8c5"));
  mixin Интерфейсы!(_SoapNmtokens, _Object, ISoapXsd);
}

abstract final class SoapNcName {
  mixin(ууид("d13b741d-051f-322f-93aa-1367a3c8aafb"));
  mixin Интерфейсы!(_SoapNcName, _Object, ISoapXsd);
}

abstract final class SoapId {
  mixin(ууид("fa0b54d5-f221-3648-a20c-f67a96f4a207"));
  mixin Интерфейсы!(_SoapId, _Object, ISoapXsd);
}

abstract final class SoapIdref {
  mixin(ууид("433ca926-9887-3541-89cc-5d74d0259144"));
  mixin Интерфейсы!(_SoapIdref, _Object, ISoapXsd);
}

abstract final class SoapEntity {
  mixin(ууид("f00ca7a7-4b8d-3f2f-a5f2-ce4a4478b39c"));
  mixin Интерфейсы!(_SoapEntity, _Object, ISoapXsd);
}

abstract final class SynchronizationAttribute {
  mixin(ууид("5520b6d3-6ec6-3ce7-958b-e69faf6eff99"));
  mixin Интерфейсы!(_SynchronizationAttribute, _Object, _Attribute, IContextAttribute, IContextProperty, IContributeServerContextSink, IContributeClientContextSink);
}

abstract final class TrackingServices {
  mixin(ууид("e822f35c-ddc2-3fb2-9768-a2aebced7c40"));
  mixin Интерфейсы!(_TrackingServices, _Object);
}

abstract final class IsolatedStorageException {
  mixin(ууид("4479c009-4cc3-39a2-8f92-dfcdf034f748"));
  mixin Интерфейсы!(_IsolatedStorageException, _Object, ISerializable, _Exception);
}

abstract final class InternalRM {
  mixin(ууид("cf8f7fcf-94fe-3516-90e9-c103156dd2d5"));
  mixin Интерфейсы!(_InternalRM, _Object);
}

abstract final class SoapMessage {
  mixin(ууид("e772bbe6-cb52-3c19-876a-d1bfa2305f4e"));
  mixin Интерфейсы!(_SoapMessage, _Object, ISoapMessage);
}

abstract final class SoapFault {
  mixin(ууид("a8d058c4-d923-3859-9490-d3888fc90439"));
  mixin Интерфейсы!(_SoapFault, _Object, ISerializable);
}

abstract final class BinaryFormatter {
  mixin(ууид("50369004-db9a-3a75-be7a-1d0ef017b9d3"));
  mixin Интерфейсы!(_BinaryFormatter, _Object, IRemotingFormatter, IFormatter);
}

abstract final class CryptographicException {
  mixin(ууид("7f8c7dc5-d8b4-3758-981f-02af6b42461a"));
  mixin Интерфейсы!(_CryptographicException, _Object, ISerializable, _Exception);
}

abstract final class CryptographicUnexpectedOperationException {
  mixin(ууид("c41fa05c-8a7a-3157-8166-4104bb4925ba"));
  mixin Интерфейсы!(_CryptographicUnexpectedOperationException, _Object, ISerializable, _Exception);
}

abstract final class RNGCryptoServiceProvider {
  mixin(ууид("40031115-09d2-3851-a13f-56930be48038"));
  mixin Интерфейсы!(_RNGCryptoServiceProvider, _Object, IDisposable);
}

abstract final class ToBase64Transform {
  mixin(ууид("5f3a0f8d-5ef9-3ad5-94e0-53aff8bce960"));
  mixin Интерфейсы!(_ToBase64Transform, _Object, ICryptoTransform, IDisposable);
}

abstract final class FromBase64Transform {
  mixin(ууид("c1abb475-f198-39d5-bf8d-330bc7189661"));
  mixin Интерфейсы!(_FromBase64Transform, _Object, ICryptoTransform, IDisposable);
}

abstract final class CspParameters {
  mixin(ууид("af60343f-6c7b-3761-839f-0c44e3ca06da"));
  mixin Интерфейсы!(_CspParameters, _Object);
}

abstract final class CryptoConfig {
  mixin(ууид("9ea60eca-3dcd-340f-8e95-67845d185999"));
  mixin Интерфейсы!(_CryptoConfig, _Object);
}

abstract final class DESCryptoServiceProvider {
  mixin(ууид("b6eb52d5-bb1c-3380-8bca-345ff43f4b04"));
  mixin Интерфейсы!(_DESCryptoServiceProvider, _Object, IDisposable);
}

abstract final class DSACryptoServiceProvider {
  mixin(ууид("673dfe75-9f93-304f-aba8-d2a86ba87d7c"));
  mixin Интерфейсы!(_DSACryptoServiceProvider, _Object, IDisposable, ICspAsymmetricAlgorithm);
}

abstract final class DSASignatureDeformatter {
  mixin(ууид("1f17c39c-99d5-37e0-8e98-8f27044bd50a"));
  mixin Интерфейсы!(_DSASignatureDeformatter, _Object);
}

abstract final class DSASignatureFormatter {
  mixin(ууид("8f6d198c-e66f-3a87-aa3f-f885dd09ea13"));
  mixin Интерфейсы!(_DSASignatureFormatter, _Object);
}

abstract final class HMACMD5 {
  mixin(ууид("a7eddcb5-6043-3988-921c-25e3dee6322b"));
  mixin Интерфейсы!(_HMACMD5, _Object, ICryptoTransform, IDisposable);
}

abstract final class HMACRIPEMD160 {
  mixin(ууид("20051d1b-321f-3e4d-a3da-5fbe892f7ec5"));
  mixin Интерфейсы!(_HMACRIPEMD160, _Object, ICryptoTransform, IDisposable);
}

abstract final class HMACSHA1 {
  mixin(ууид("00b01b2e-b1fe-33a6-ad40-57de8358dc7d"));
  mixin Интерфейсы!(_HMACSHA1, _Object, ICryptoTransform, IDisposable);
}

abstract final class HMACSHA256 {
  mixin(ууид("2c314899-8f99-3041-a49d-2f6afc0e6296"));
  mixin Интерфейсы!(_HMACSHA256, _Object, ICryptoTransform, IDisposable);
}

abstract final class HMACSHA384 {
  mixin(ууид("ae53ed01-cab4-39ce-854a-8bf544eeec35"));
  mixin Интерфейсы!(_HMACSHA384, _Object, ICryptoTransform, IDisposable);
}

abstract final class HMACSHA512 {
  mixin(ууид("477a7d8e-8d26-3959-88f6-f6ab7e7f50cf"));
  mixin Интерфейсы!(_HMACSHA512, _Object, ICryptoTransform, IDisposable);
}

abstract final class MACTripleDES {
  mixin(ууид("39b68485-6773-3c46-82e9-56d8f0b4570c"));
  mixin Интерфейсы!(_MACTripleDES, _Object, ICryptoTransform, IDisposable);
}

abstract final class MD5CryptoServiceProvider {
  mixin(ууид("d2548bf2-801a-36af-8800-1f11fbf54361"));
  mixin Интерфейсы!(_MD5CryptoServiceProvider, _Object, ICryptoTransform, IDisposable);
}

abstract final class PKCS1MaskGenerationMethod {
  mixin(ууид("7ae844f0-eca8-3f15-ae27-afa21a2aa6f8"));
  mixin Интерфейсы!(_PKCS1MaskGenerationMethod, _Object);
}

abstract final class RC2CryptoServiceProvider {
  mixin(ууид("62e92675-cb77-3fc9-8597-1a81a5f18013"));
  mixin Интерфейсы!(_RC2CryptoServiceProvider, _Object, IDisposable);
}

abstract final class RIPEMD160Managed {
  mixin(ууид("3d367908-928f-3c13-8b93-5e1718820f6d"));
  mixin Интерфейсы!(_RIPEMD160Managed, _Object, ICryptoTransform, IDisposable);
}

abstract final class RSACryptoServiceProvider {
  mixin(ууид("d9035152-6b1f-33e3-86f4-411cd21cde0e"));
  mixin Интерфейсы!(_RSACryptoServiceProvider, _Object, IDisposable, ICspAsymmetricAlgorithm);
}

abstract final class RSAOAEPKeyExchangeDeformatter {
  mixin(ууид("4d187ac2-d815-3b7e-bcea-8e0bbc702f7c"));
  mixin Интерфейсы!(_RSAOAEPKeyExchangeDeformatter, _Object);
}

abstract final class RSAOAEPKeyExchangeFormatter {
  mixin(ууид("a0e2e749-63ce-3651-8f4f-f5f996344c32"));
  mixin Интерфейсы!(_RSAOAEPKeyExchangeFormatter, _Object);
}

abstract final class RSAPKCS1KeyExchangeDeformatter {
  mixin(ууид("ee96f4e1-377e-315c-aef5-874dc8c7a2aa"));
  mixin Интерфейсы!(_RSAPKCS1KeyExchangeDeformatter, _Object);
}

abstract final class RSAPKCS1KeyExchangeFormatter {
  mixin(ууид("92755472-2059-3f96-8938-8ac767b5187b"));
  mixin Интерфейсы!(_RSAPKCS1KeyExchangeFormatter, _Object);
}

abstract final class RSAPKCS1SignatureDeformatter {
  mixin(ууид("6f674828-9081-3b45-bc39-791bd84ccf8f"));
  mixin Интерфейсы!(_RSAPKCS1SignatureDeformatter, _Object);
}

abstract final class RSAPKCS1SignatureFormatter {
  mixin(ууид("7bc115cd-1ee2-3068-894d-e3d3f7632f40"));
  mixin Интерфейсы!(_RSAPKCS1SignatureFormatter, _Object);
}

abstract final class RijndaelManaged {
  mixin(ууид("1f9f18a3-efc0-3913-84a5-90678a4a9a80"));
  mixin Интерфейсы!(_RijndaelManaged, _Object, IDisposable);
}

abstract final class SHA1CryptoServiceProvider {
  mixin(ууид("fc13a7d5-e2b3-37ba-b807-7fa6238284d5"));
  mixin Интерфейсы!(_SHA1CryptoServiceProvider, _Object, ICryptoTransform, IDisposable);
}

abstract final class SHA1Managed {
  mixin(ууид("fdf9c30d-ccab-3e2d-b584-9e24ce8038e3"));
  mixin Интерфейсы!(_SHA1Managed, _Object, ICryptoTransform, IDisposable);
}

abstract final class SHA256Managed {
  mixin(ууид("44181b13-ae94-3cfb-81d1-37db59145030"));
  mixin Интерфейсы!(_SHA256Managed, _Object, ICryptoTransform, IDisposable);
}

abstract final class SHA384Managed {
  mixin(ууид("7fd3958d-0a14-3001-8074-0d15ead7f05c"));
  mixin Интерфейсы!(_SHA384Managed, _Object, ICryptoTransform, IDisposable);
}

abstract final class SHA512Managed {
  mixin(ууид("a6673c32-3943-3bbb-b476-c09a0ec0bcd6"));
  mixin Интерфейсы!(_SHA512Managed, _Object, ICryptoTransform, IDisposable);
}

abstract final class SignatureDescription {
  mixin(ууид("3fa7a1c5-812c-3b56-b957-cb14af670c09"));
  mixin Интерфейсы!(_SignatureDescription, _Object);
}

abstract final class TripleDESCryptoServiceProvider {
  mixin(ууид("daa132bf-1170-3d8b-a0ef-e2f55a68a91d"));
  mixin Интерфейсы!(_TripleDESCryptoServiceProvider, _Object, IDisposable);
}

abstract final class X509Certificate {
  mixin(ууид("4c69c54f-9824-38cc-8387-a22dc67e0bab"));
  mixin Интерфейсы!(_X509Certificate, _Object, IDeserializationCallback, ISerializable);
}
