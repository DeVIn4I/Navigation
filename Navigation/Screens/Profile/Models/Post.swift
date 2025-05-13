//
//  Post.swift
//  Navigation
//
//  Created by Razumov Pavel on 28.03.2025.
//

import UIKit

public struct Post {
    public var author: String
    public var description: String
    public var image: String
    public var likes: Int
    public var views: Int
    
    public static func makePosts() -> [Post] {
        [
            .init(
                author: "Swift",
                description:
                """
                Swift — современный язык от Apple для разработки под iOS, macOS, watchOS и tvOS.
                Он безопасный, быстрый и легко читается благодаря лаконичному синтаксису.
                Swift активно развивается и поддерживает современные фичи вроде async/await и protocol-oriented подхода.
                """,
                image: .swiftImageName,
                likes: 250,
                views: 1200
            ),
            .init(
                author: "Kotlin",
                description:
                """
                Kotlin — официальный язык для Android-разработки от JetBrains.
                Он полностью совместим с Java, но предлагает более краткий и безопасный синтаксис.
                Kotlin поддерживает как объектно-ориентированное, так и функциональное программирование.
                """,
                image: .kotlinImageName,
                likes: 50,
                views: 120
            ),
            .init(
                author: "C++",
                description:
                """
                C++ — мощный язык системного уровня, часто используемый для разработки игр, операционных систем и высокопроизводительных приложений.
                Он предоставляет низкоуровневый контроль над памятью и высокую производительность.
                C++ поддерживает как процедурное, так и объектно-ориентированное программирование.
                """,
                image: .cPlusPlusImageName,
                likes: 1000,
                views: 123450
            ),
            .init(
                author: "Python",
                description:
                """
                Python — универсальный язык с читаемым синтаксисом, широко используемый в науке, веб-разработке, автоматизации и искусственном интеллекте.
                Благодаря большому количеству библиотек и фреймворков, Python популярен как среди новичков, так и профессионалов.
                Поддерживает как объектно-ориентированный, так и функциональный стиль программирования.
                """,
                image: .pythonImageName,
                likes: 654,
                views: 12431
            ),
            .init(
                author: "JavaScript",
                description:
                """
                JavaScript — основной язык для создания интерактивных веб-интерфейсов.
                Работает во всех браузерах и используется как на клиенте, так и на сервере (через Node.js).
                Поддерживает современные возможности, включая модули, классы, промисы и async/await.
                """,
                image: .javaScriptImageName,
                likes: 256,
                views: 512
            )
        ]
    }
}

private extension String {
    ///Название изображения для отображения Swift
    static let swiftImageName = "swift"
    ///Название изображения для отображения Kotlin
    static let kotlinImageName = "kotlin"
    ///Название изображения для отображения Python
    static let pythonImageName = "python"
    ///Название изображения для отображения JavaScript
    static let javaScriptImageName = "js"
    ///Название изображения для отображения C++
    static let cPlusPlusImageName = "C_plus_plus"
}
