//
//  MusicM.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import SwiftUI

// Модель данных для представления музыкальной станции/трека
// Соответствует нескольким протоколам для удобства использования в SwiftUI
struct MusicM: Codable, Identifiable, Equatable, Hashable {
    
    // MARK: - Properties
    // Уникальный идентификатор, необходимый для протокола Identifiable
    // Автоматически генерируется при создании каждого экземпляра
    let id = UUID()
    
    // Случайный цвет для фона или акцента элемента
    // Генерируется автоматически при создании каждого экземпляра
    let randomColor = Color(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1)
    )
    
    // Название музыкальной станции или трека
    let name: String
    
    // URL для загрузки изображения (обложки, иконки станции)
    let imageUrl: URL
    
    // URL для стриминга аудио
    let streamUrl: String
    
    // MARK: - CodingKeys
    // Перечисление для маппинга JSON ключей на свойства модели
    // Необходимо для корректного декодирования из JSON
    enum CodingKeys: String, CodingKey {
        case name                    // Соответствует свойству name
        case streamUrl = "url"       // В JSON ключ "url" маппится на streamUrl
        case imageUrl = "favicon"    // В JSON ключ "favicon" маппится на imageUrl
    }
    
    // MARK: - Initializers
    
    // Прямой инициализатор для создания модели вручную
    // Используется при создании тестовых данных или локальных объектов
    init(name: String, imageURL: URL, streamUrl: String) {
        self.name = name
        self.imageUrl = imageURL
        self.streamUrl = streamUrl
    }
    
    // Инициализатор для декодирования из JSON
    // Требуется протоколом Codable для парсинга из внешних данных
    init(from decoder: any Decoder) throws {
        // Контейнер для декодирования по ключам CodingKeys
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Декодирование названия станции
        self.name = try container.decode(String.self, forKey: .name)
        
        // Декодирование URL стрима
        self.streamUrl = try container.decode(String.self, forKey: .streamUrl)
        
        // Декодирование URL изображения с обработкой ошибок
        let imageUrlString = try container.decode(String.self, forKey: .imageUrl)
        
        // Пытаемся создать URL из строки, при неудаче используем fallback URL
        imageUrl = URL(string: imageUrlString) ?? URL(string: "https://i.postimg.cc/dVhrFLff/temp-Image-Ox-S6ie.avif")!
    }
}

// MARK: - Protocol Conformance Explanation
/*
 Codable:
   - Позволяет сериализовать и десериализовать модель из/в JSON
   - Используется для сетевых запросов и сохранения данных

 Identifiable:
   - Требуется SwiftUI для List, ForEach и других компонентов
   - Обеспечивает уникальный идентификатор для каждого элемента

 Equatable:
   - Позволяет сравнивать экземпляры модели на равенство
   - Используется для обновлений UI и оптимизации производительности
*/
