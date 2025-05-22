# 📱 CleanPostApp

**CleanPostApp** — это лёгкое и современное iOS-приложение для просмотра и управления постами, с возможностью работы в офлайн-режиме и выбора хранилища данных: `UserDefaults` или `CoreData`.

---

## 🚀 Основной функционал

- Загрузка постов с сервера (https://jsonplaceholder.typicode.com)
- Отображение постов в виде списка
- Пагинация (постраничная подгрузка)
- Избранные посты (состояние сохраняется)
- Удаление пользовательских постов
- Добавление собственных постов
- Поддержка офлайн-режима (локальный кэш)
- Выброс ошибки через `alert` при недоступности сети
- Автоматическое определение состояния соединения
- Визуальные предупреждения:
  - "Нет интернета — показан локальный кэш"
  - "Сервер недоступен. Возможно, включён VPN"
- Возможность выбрать хранилище (`UserDefaults` или `CoreData`) при запуске
- UI в соответствии с [Human Interface Guidelines (HIG)](https://developer.apple.com/design/human-interface-guidelines/)

---

## 🧱 Архитектура

- **MVVM**: чёткое разделение логики, хранения и представления
- **Combine**: реактивное управление состоянием и сетевыми событиями
- **Протоколы**: гибкость и тестируемость (`PostStorageProtocol`, `NetworkServiceProtocol`)
- **Mock-сервисы**: для написания юнит-тестов без реального API

---

## 💾 Работа с офлайн-режимом и кэшем

- При первом запуске данные загружаются из сети и сохраняются в выбранное хранилище (`UserDefaults` или `CoreData`)
- При отсутствии интернета отображаются локально сохранённые данные
- Баннер в интерфейсе сообщает, откуда загружены данные:
  - "Нет интернета — показан локальный кэш"
  - "Сервер недоступен. Возможно, включён VPN"
- При восстановлении соединения можно обновить список вручную (`Pull to refresh`)

---

## 🗂 Структура проекта

├── AppRootView.swift
├── Views/
│ ├── MainTabView.swift
│ ├── PostsListView.swift
│ ├── PostRowView.swift
│ ├── AddPostView.swift
│ ├── FavoritesView.swift
│ ├── WelcomeView.swift
│ ├── JournalLogoView.swift
│ └── StorageSelectionCard.swift
├── ViewModels/
│ └── PostsViewModel.swift
├── Models/
│ ├── Post.swift
│ └── StorageType.swift
├── Services/
│ ├── NetworkService.swift
│ └── Color+Hex.swift
├── Storage/
│ ├── UserDefaultsStorage.swift
│ ├── CoreDataStorage.swift
│ ├── CoreDataManager.swift
│ ├── CDPost+CoreDataClass.swift
│ └── CDPost+CoreDataProperties.swift
├── Helpers/
│ └── AnimatedGradient.swift
├── Tests/
│ ├── PostsViewModelTests.swift
│ ├── MockPostStorage.swift
│ └── MockNetworkService.swift
---

## 🧪 Тестирование

- Покрытие базовой бизнес-логики `PostsViewModel`
- Используются: `XCTest`, `Combine`, `MockNetworkService`, `MockPostStorage`

---

## 📸 Скриншоты

Примеры ключевых экранов приложения:

| Экран приветствия | Список постов |
|-------------------|----------------|
| ![Welcome](./screenshots/welcome.png) | ![Posts](./screenshots/posts.png) |

| Новый пост | Избранное |
|------------|-------------|
| ![NewPost](./screenshots/new_post.png) | ![Favorites](./screenshots/favorites.png) |

---

## 🧭 Возможные доработки

- Детальный экран поста
- Редактирование пользовательских постов
- Работа с авторизацией и API пользователей
- Отображение даты создания, автора, количества лайков
- Экспорт/импорт данных, синхронизация

---

## 📝 Автор

**Ekaterina Saveleva**  
iOS-разработчик и преподаватель  
Разработка и дизайн: 100%  
Тесты, архитектура, README — авторские  
[Telegram](https://t.me/indiana_jonez)  
2025 © Все права защищены

