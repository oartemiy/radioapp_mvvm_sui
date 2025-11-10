//
//  HomeHeaderV.swift
//  RadioApp
//  Created by B.RF Group on 03.11.2025.
//
import SwiftUI

// Главный заголовочный вид для домашнего экрана
struct HomeHeaderV: View {
    let headerStr: String // Текст заголовка
    let onTapSearch: () -> () // Замыкание для обработки нажатия на кнопку поиска
    
    var body: some View {
        HStack(alignment: .center) {
            // Отображение заголовка
            Text(headerStr)
                .foregroundColor(.text_header) // Цвет текста из ресурсов
                .bold().font(.title2) // Жирное начертание
            
            Spacer() // Разделитель, занимает все свободное пространство
            
            // Кнопка поиска
            Button(action: onTapSearch) {
                Image.search // Использование кастомного изображения поиска
                    .resizable() // Возможность изменения размера
                    .frame(width: 16, height: 16) // Фиксированный размер иконки
                    .padding(12) // Внутренние отступы вокруг иконки
                    .background(Color.primary_color) // Фоновый цвет
                    .cornerRadius(20) // Закругление углов
                    .modifier(NeuShadow()) // Кастомный модификатор неоморфной тени
            }
        }
        .padding(.top, 12) // Верхний отступ
        .padding(.horizontal, Constants.Sizes.HORIZONTAL_SPACING) // Горизонтальные отступы из констант
    }
}

// Кастомный стиль кнопки с неоморфным эффектом
struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30) // Большие отступы для создания круга
            .background(
                Group {
                    if configuration.isPressed {
                        // Визуальный эффект при нажатии - вдавленная кнопка
                        Circle()
                            .fill(Color.offWhite)
                            // Тени для создания эффекта вдавленности
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: -5, y: -5)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: 10, y: 10)
                    } else {
                        // Стандартное состояние - выпуклая кнопка
                        Circle()
                            .fill(Color.offWhite)
                            // Тени для создания эффекта выпуклости
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}

// Демонстрационный экран неоморфизма
struct Neuromorphism: View {
    @Environment(\.presentationMode) var presentationMode // Для управления навигацией
    
    var body: some View {
        ZStack {
            // Градиентный фон от темного к более темному
            LinearGradient(Color.darkStart, Color.darkEnd)
            
            // Основной неоморфный прямоугольник
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.offWhite) // Цвет фона
                .frame(width: 300, height: 300) // Размеры
                // Неоморфные тени
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            
            // Кнопка с сердцем
            Button(action: {
                print("Button tapped")
            }) {
                Image(systemName: "heart.fill") // SF Symbols иконка
                    .foregroundColor(.gray)
            }
            .buttonStyle(SimpleButtonStyle()) // Применение кастомного стиля
            
            // Вертикальный стек для элементов управления
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    // Кнопка закрытия
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss() // Закрытие текущего вида
                    }) {
                        Image.close // Кастомная иконка закрытия
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(12)
                            .background(Color.primary_color)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, Constants.Sizes.HORIZONTAL_SPACING)
                    .padding(.top, 60) // Отступ от верхнего края безопасной зоны
                    
                    Spacer() // Выравнивание кнопки закрытия слева
                }
                Spacer() // Заполнение оставшегося пространства
            }
        }
        .edgesIgnoringSafeArea(.all) // Растягивание на всю область экрана
    }
}
