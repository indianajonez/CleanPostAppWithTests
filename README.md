# 📱 CleanPostApp

**CleanPostApp** — современное iOS-приложение для просмотра и управления постами с возможностью офлайн-режима и выбором хранилища данных: `UserDefaults` или `CoreData`.

---

## 🚀 Основной функционал

- Загрузка постов с API: [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com)
- Постраничная подгрузка (пагинация)
- Добавление собственных постов
- Управление избранными
- Удаление кастомных постов
- Поддержка офлайн-режима с сохранением данных
- Системные алерты при ошибках
- Стартовый экран выбора хранилища (`UserDefaults` / `CoreData`)
- Дизайн в соответствии с [Human Interface Guidelines (HIG)](https://developer.apple.com/design/human-interface-guidelines/)

---

## 🧱 Архитектура

- **MVVM** — чёткое разделение логики и UI
- **Async/Await** — асинхронная работа с API
- **Dependency Injection** через протоколы: `PostStorageProtocol`, `NetworkServiceProtocol`
- **Mock-сервисы** — покрытие бизнес-логики тестами

---

## 🗂 Структура проекта

- `Views/`
  - `Favorites/`
    - `FavoritesView.swift`
  - `Main/`
    - `AppRootView.swift`
    - `MainTabView.swift`
  - `Posts/`
    - `AddPostView.swift`
    - `PostRowView.swift`
    - `PostsListView.swift`
  - `Welcome/`
    - `WelcomeView.swift`
    - `StorageSelectionCard.swift`
    - `AnimatedGradient.swift`
    - `JournalLogoView.swift`
- `ViewModels/`
  - `PostsViewModel.swift`
- `Models/`
  - `Post.swift`
- `Networking/`
  - `NetworkService.swift`
  - `APIError.swift`
- `Storage/`
  - `PostStorageProtocol.swift`
  - `UserDefaultsStorage.swift`
  - `FavoritesStorage.swift`
  - `CoreData/`
    - `CoreDataManager.swift`
    - `CoreDataStorage.swift`
    - `CDPost+CoreDataClass.swift`
    - `CDPost+CoreDataProperties.swift`
    - `CleanPostModel.xcdatamodeld`
- `State/`
  - `NetworkState.swift`
- `Factory/`
  - `ViewModelFactory.swift`
- `Supporting/`
  - `AppData.swift`
  - `CleanPostAppApp.swift`
  - `Assets.xcassets/`
- `Tests/`
  - `CleanPostAppTests.swift`
  - `PostsViewModelTests.swift`
  - `MockNetworkService.swift`
  - `MockPostStorage.swift`

---

## 🧪 Тестирование

- Покрытие бизнес-логики `PostsViewModel`
- Используются: `XCTest`, async/await, мок-сервисы

---

## 📸 Скриншоты

| WelcomeView | PostsListView |
|-------------|----------------|
| ![Welcome](./screenshots/welcome.png) | ![Posts](./screenshots/posts.png) |

| AddPostView | FavoritesView |
|-------------|----------------|
| ![NewPost](./screenshots/new_post.png) | ![Favorites](./screenshots/favorites.png) |

---

## 🧭 Возможные доработки

- Редактирование пользовательских постов
- Экран с деталями поста
- Отображение даты и автора
- Импорт и экспорт постов
- Авторизация
- Поддержка iPad и Mac (Catalyst)

---

## 📎 Приложение тестового задания

Файл `test-task.pdf` содержит оригинальное условие от работодателя, на основе которого реализован проект.

---

## 📝 Автор

**Ekaterina Saveleva**  
Полная реализация: архитектура, UI, логика, тесты  
[iOS-разработчик и преподаватель](https://t.me/indiana_jonez)  
2025 © Все права защищены
