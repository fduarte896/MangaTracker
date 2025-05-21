# 📚 Manga Tracker

**Manga Tracker** is an iOS app built with SwiftUI that lets users **explore, organize, and track their manga collection** across devices. With a responsive design for iPhone and iPad, and dynamic layouts based on orientation, it provides an engaging and structured experience for manga enthusiasts.

---

## ✨ Features

- 🔍 **Explore Section**  
  Browse manga by category, with dynamic subcategory loading as you scroll.

- 🧾 **Bucket List & Collection**  
  Track manga you plan to read (bucket list) and those you've collected.

- 🧩 **Reusability & Adaptivity**  
  Custom cells, onboarding flow, and detail views adapt between iPhone and iPad — including support for split view and orientation changes.

- 🧼 **Clean Architecture**  
  Uses MVVM for better separation of concerns and modularity.

- 🗃️ **Local Persistence with SwiftData**  
  Collection and bucket list data is stored locally and updated in real time.

- 🧪 **iOS 17+ Optimizations**  
  Leverages the latest SwiftUI features and modifiers for smooth user experience.

---

## 🛠 Technologies Used

- Swift + SwiftUI
- MVVM Architecture
- SwiftData (modern persistence)
- Adaptive layouts with `@Environment(\.horizontalSizeClass)`
- State-driven navigation and view switching
- Launch screen & onboarding flow

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/manga-tracker.git
