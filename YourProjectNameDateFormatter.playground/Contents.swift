import Foundation

final class YourProjectNameDateFormatter {
    private static var dateFormatters = [Int: DateFormatter]()

    private init() {}

    // MARK: - Date Formatting

    /// Преобразует строку в объект типа Date, используя указанный формат даты.
    /// - Parameters:
    ///     - string: Строка, которую необходимо преобразовать в дату.
    ///     - format: Формат даты для преобразования строки.
    /// - Returns: Объект типа Date, полученный из строки, или nil, если преобразование не удалось.
    static func date(from string: String, format: DateFormat = .apiFullDateFormat) -> Date? {
        let formatter = dateFormatter(for: Configurator(dateFormat: format))
        return formatter.date(from: string)
    }

    /// Преобразует строку в объект типа Date, используя указанный конфигуратор.
    /// - Parameters:
    ///     - string: Строка, которую необходимо преобразовать в дату.
    ///     - configurator: Конфигуратор форматтера для преобразования строки.
    /// - Returns: Объект типа Date, полученный из строки, или nil, если преобразование не удалось.
    static func date(from string: String, withConfigurator configurator: Configurator) -> Date? {
        let formatter = dateFormatter(for: configurator)
        return formatter.date(from: string)
    }

    /// Преобразует объект типа Date в строку, используя указанный формат даты.
    /// - Parameters:
    ///     - date: Объект типа Date, который необходимо преобразовать в строку.
    ///     - format: Формат даты для преобразования объекта типа Date.
    /// - Returns: Строковое представление объекта типа Date в указанном формате.
    static func string(from date: Date, format: DateFormat) -> String {
        let formatter = dateFormatter(for: Configurator(dateFormat: format))
        return formatter.string(from: date)
    }

    /// Преобразует объект типа Date в строку, используя указанный формат даты.
    /// - Parameters:
    ///     - date: Объект типа Date, который необходимо преобразовать в строку.
    ///     - configurator: Конфигуратор форматтера для преобразования строки.
    /// - Returns: Строковое представление объекта типа Date в указанном формате.
    static func string(from date: Date, withConfigurator configurator: Configurator) -> String {
        let formatter = dateFormatter(for: configurator)
        return formatter.string(from: date)
    }

    /**
     Преобразует строку даты в формат, показывающий "сколько времени прошло".

     - Parameters:
        - string: Строка даты, которую нужно преобразовать.
        - format: Формат входной строки даты. По умолчанию - `.apiDateFormat`.

     - Returns: Строка, представляющая прошедшее время с момента входной даты в человекочитаемом формате.

     Пример использования:

     ```swift
     let dateString = "2022-05-01T12:30:45"
     let timeAgo = dateConverterToTimeAgo(from: dateString, format: .apiDateFormat)
     print(timeAgo) // Вывод: "3 дня назад"
     */
    static func dateConverterToTimeAgo(from string: String, format: DateFormat = .apiFullDateFormat) -> String {
        let dateFormatter = dateFormatter(for: Configurator(dateFormat: format))

        if let date = dateFormatter.date(from: string) {

            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
            
            if let years = components.year, years > 0 {
                return "\(years) \(pluralize(years, singular: "год", plural: "года", pluralGenitive: "лет"))"
            } else if let months = components.month, months > 0 {
                return "\(months) \(pluralize(months, singular: "месяц", plural: "месяца", pluralGenitive: "месяцев"))"
            } else if let days = components.day, days > 0 {
                return "\(days) \(pluralize(days, singular: "день", plural: "дня", pluralGenitive: "дней"))"
            } else if let hours = components.hour, hours > 0 {
                return "\(hours) \(pluralize(hours, singular: "час", plural: "часа", pluralGenitive: "часов"))"
            } else if let minutes = components.minute, minutes > 0 {
                return "\(minutes) \(pluralize(minutes, singular: "минута", plural: "минуты", pluralGenitive: "минут"))"
            }
        }

        return "Только что"
    }

    /**
     Преобразует строку даты в формат, показывающий "сколько времени прошло".

     - Parameters:
        - string: Строка даты, которую нужно преобразовать.
        - format: Формат входной строки даты. По умолчанию - `.apiDateFormat`.

     - Returns: Объект типа `DateConvertedType`, представляющий прошедшее время с момента входной даты.

     Метод `convertDataToTimeAgoType` принимает строку даты и формат входной строки, а затем вычисляет разницу между этой датой и текущим моментом. Результат представляется в следующем формате:

     - Если прошло больше года, возвращает `.years` с количеством лет в строке.
     - Если прошло больше месяца, возвращает `.months` с количеством месяцев в строке.
     - Если прошло больше дня, возвращает `.days` с количеством дней в строке.
     - Если прошло больше часа, возвращает `.hours` с количеством часов в строке.
     - Если прошло больше минуты, возвращает `.minutes` с количеством минут в строке.
     - Если прошло менее минуты, возвращает `.justNow` с фразой "Только что".

     Входной формат строки даты может быть указан явно с помощью параметра `format`. По умолчанию используется формат `.apiDateFormat`.

     Пример использования:

     ```swift
     let dateString = "2022-05-01T12:30:45"
     let timeAgo = DateConverter.convertDataToTimeAgoType(from: dateString, format: .apiDateFormat)
     
     switch timeAgo {
     case .years(let years):
         print(years) // Вывод: "3 года"
     case .months(let months):
         print(months) // Вывод: "2 месяца"
     case .days(let days):
         print(days) // Вывод: "7 дней"
     case .hours(let hours):
         print(hours) // Вывод: "5 часов"
     case .minutes(let minutes):
         print(minutes) // Вывод: "30 минут"
     case .justNow(let phrase):
         print(phrase) // Вывод: "Только что"
     }
     */
    static func convertDataToTimeAgoType(from string: String, format: DateFormat = .apiFullDateFormat) -> DateConvertedType {
        let dateFormatter = dateFormatter(for: Configurator(dateFormat: format))

        if let date = dateFormatter.date(from: string) {
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)

            if let years = components.year, years > 0 {
                return .years("\(years) \(pluralize(years, singular: "год", plural: "года", pluralGenitive: "лет"))")
            } else if let months = components.month, months > 0 {
                return .months("\(months) \(pluralize(months, singular: "месяц", plural: "месяца", pluralGenitive: "месяцев"))")
            } else if let days = components.day, days > 0 {
                return .days("\(days) \(pluralize(days, singular: "день", plural: "дня", pluralGenitive: "дней"))")
            } else if let hours = components.hour, hours > 0 {
                return .hours("\(hours) \(pluralize(hours, singular: "час", plural: "часа", pluralGenitive: "часов"))")
            } else if let minutes = components.minute, minutes > 0 {
                return .minutes("\(minutes) \(pluralize(minutes, singular: "минута", plural: "минуты", pluralGenitive: "минут"))")
            }
        }
        return .justNow("Только что")
    }

    /// Возвращает экземпляр класса DateFormatter для указанного формата даты.
    /// Если уже существует кэшированный экземпляр для указанного формата, возвращает его,
    /// иначе создает новый экземпляр, устанавливает формат даты и кэширует его для дальнейшего использования.
    /// - Parameter configurator: Конфигурация даты для создания экземпляра DateFormatter.
    /// - Returns: Экземпляр класса DateFormatter с указанным форматом даты.
    private static func dateFormatter(for configurator: Configurator) -> DateFormatter {
        if let cachedFormatter = dateFormatters[configurator.hashValue] {
            return cachedFormatter
        }
        var formatter = DateFormatter()

        configurator.configure(dateFormatter: &formatter)
        dateFormatters[configurator.hashValue] = formatter
        return formatter
    }

    /// Возвращает строку, согласованную с числом, используя указанную единственную, множественную и множественную родительный падеж формы.
    ///
    /// - Parameters:
    ///   - number: Число, для которого нужно согласовать строку.
    ///   - singular: Строка в единственном числе.
    ///   - plural: Строка в множественном числе (не родительном падеже).
    ///   - pluralGenitive: Строка в множественном родительном падеже.
    /// - Returns: Строка, согласованная с числом.
    private static func pluralize(_ number: Int, singular: String, plural: String, pluralGenitive: String) -> String {
        let absNumber = abs(number)
        let remainder10 = absNumber % 10
        let remainder100 = absNumber % 100

        if remainder10 == 1 && remainder100 != 11 {
            return singular
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return plural
        } else {
            return pluralGenitive
        }
    }
}

// MARK: - DateConvertedType
extension YourProjectNameDateFormatter {
    /// Перечисление, представляющее время, прошедшее с определенной даты
    enum DateConvertedType {
        case years(String)
        case months(String)
        case days(String)
        case hours(String)
        case minutes(String)
        case justNow(String)

        var convertedData: String {
            switch self {
            case .years(let string):
               return string
            case .months(let string):
                return string
            case .days(let string):
                return string
            case .hours(let string):
                return string
            case .minutes(let string):
                return string
            case .justNow(let string):
                return string
            }
        }
    }
}

// MARK: - Configurator
extension YourProjectNameDateFormatter {
    /// Класс `Configurator` представляет собой объект конфигурации, используемый для настройки объекта форматирования даты.
    final class Configurator: Hashable {
        private var dateFormat: DateFormat?
        private var locale: LocaleFormat?
        private var timeZone: TimeZone?

        init(dateFormat: DateFormat? = nil, locale: LocaleFormat? = nil, timeZone: TimeZone? = nil) {
            self.dateFormat = dateFormat
            self.locale = locale
            self.timeZone = timeZone
        }

        func update(dateFormat: DateFormat) {
            self.dateFormat = dateFormat
        }

        func update(locale: LocaleFormat) {
            self.locale = locale
        }

        func update(timeZone: TimeZone) {
            self.timeZone = timeZone
        }

        fileprivate func configure(dateFormatter: inout DateFormatter) {
            if let dateFormat = dateFormat {
                if case let .cutWordsDateWithTime(localeFormat) = dateFormat {
                    self.locale = localeFormat
                }
                dateFormatter.dateFormat = dateFormat.rawValue
            }

            if let locale = locale {
                dateFormatter.locale = Locale(identifier: locale.rawValue)
            }

            if let timeZone = timeZone {
                dateFormatter.timeZone = timeZone
            }
        }

        // MARK: - Hashable
        static func == (lhs: Configurator, rhs: Configurator) -> Bool {
            return lhs.dateFormat?.rawValue == rhs.dateFormat?.rawValue &&
                   lhs.locale == rhs.locale &&
                   lhs.timeZone == rhs.timeZone
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(dateFormat?.rawValue)
            hasher.combine(locale)
            hasher.combine(timeZone)
        }
    }
}

// MARK: - DateFormat
extension YourProjectNameDateFormatter {
    /// Перечисление для форматов даты
    enum DateFormat {
        /// Сокращенное отображение даты, нули вначале обрезаются: "1.2.2024"
        case cutZeroShortDate
        /// Сокращенное отображение даты: "01.02.2024"
        case shortDate
        /// Полное отображение даты: "01 February 2024"
        case fullDate
        /// Полное отображение с обрезанными словами: "1 Feb 2024"
        case cutWordsFullDate
        /// Отображение только месяца и числа с обрезанными словами: "11 Nov"
        case cutWordsDate
        /// Отображение времени: ""21:24"
        case time
        /// Формат даты для использования в API: "2024-02-01T21:24:56.142+0500"
        case apiFullDateFormat
        /// Только дата для использования в API: "2024-02-01"
        case apiDateFormat
        /// Отображение только месяца и числа: "11 November"
        case date
        /// Отображение дня недели: "Monday"
        case dayOfTheWeek
        /// Отображение только месяца и числа с обрезанными словами + время: "6 февр. в 10:07"
        case cutWordsDateWithTime(LocaleFormat)
        
        var rawValue: String {
            switch self {
            case .cutZeroShortDate:
                return "d.M.yyyy"

            case .shortDate:
                return "dd.MM.yyyy"

            case .fullDate:
                return "dd MMMM yyyy"

            case .cutWordsFullDate:
                return "d MMM yyy"

            case .cutWordsDate:
                return "dd MMM"
                
            case .time:
                return "HH:mm"
                
            case .apiFullDateFormat:
                return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
            case .apiDateFormat:
                return "yyyy-MM-dd"
                
            case .date:
                return "dd MMMM"
                
            case .dayOfTheWeek:
                return "eeee"
                
            case .cutWordsDateWithTime(let localeFormat):
                switch localeFormat {
                case .eng: return "d MMM at HH:mm"
                case .rus: return "d MMM в HH:mm"
                }
            }
        }
    }
}

// MARK: - LocaleFormat
extension YourProjectNameDateFormatter {
    /// Перечисление для локали форматов даты
    enum LocaleFormat: String {
        case rus = "ru_RU"
        case eng = "en_US"
    }
}
