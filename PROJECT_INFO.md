# EcoTrack - Environmental Impact Tracking Application

## 📝 Description

EcoTrack is a comprehensive mobile and web application designed to empower individuals in their journey toward environmental sustainability. In an era where climate change poses one of humanity's greatest challenges, many people want to make a positive impact but struggle to understand their environmental footprint or track their progress effectively. EcoTrack bridges this gap by providing an intuitive, gamified platform that makes environmental consciousness accessible and engaging.

**The Problem It Solves:**

Climate action often feels overwhelming and abstract. People don't know where to start, can't measure their impact, and lack motivation to maintain sustainable habits. Traditional carbon calculators provide one-time snapshots without ongoing engagement, while environmental apps often focus on single aspects like recycling or energy use without providing a holistic view.

EcoTrack addresses these challenges by offering:

1. **Comprehensive Carbon Footprint Tracking**: Users can calculate their carbon emissions across transportation, home energy, diet, and air travel with detailed breakdowns showing exactly where their impact comes from.

2. **Goal-Based Action Plans**: Instead of just showing problems, EcoTrack helps users set and track personalized environmental goals—whether reducing car usage, cutting electricity consumption, or planting trees in their community.

3. **Real-Time Progress Monitoring**: Users see their environmental impact evolve over time with visual progress charts, achievement badges, and a points system that gamifies sustainability.

4. **Activity Feed**: Every positive action—from planting a tree to completing a sustainability goal—is logged and celebrated, creating a personal environmental journey timeline.

5. **Educational Resources**: Built-in sustainability tips provide actionable advice tailored to different categories like transportation, energy, diet, and waste reduction.

**Who It Helps:**

- **Individual Climate Activists**: People passionate about reducing their environmental impact get tools to measure, track, and improve their carbon footprint systematically.

- **Students & Educators**: Environmental science students can use EcoTrack for projects and research, while educators can encourage sustainable habits among learners.

- **Corporate CSR Teams**: Companies implementing sustainability initiatives can use EcoTrack to track employee participation and measure collective impact.

- **NGO Workers**: Environmental organizations can leverage the platform to engage communities in tree-planting campaigns and conservation efforts.

- **Everyday Citizens**: Anyone wanting to live more sustainably but unsure where to start gets clear guidance, measurable goals, and motivation to maintain eco-friendly habits.

**Key Features:**

The application provides a beautiful, modern interface with glassmorphic design elements and smooth animations that make environmental tracking feel premium and engaging. Users start by creating an account through a guided onboarding process that captures their location, sustainability goals, and usage intentions. The dashboard presents real-time statistics on trees planted, CO₂ offset, and recent environmental activities.

The carbon calculator breaks down emissions into four categories with interactive sliders, providing immediate feedback on whether users are above or below regional averages. The goals system allows users to create custom sustainability targets with progress tracking, deadlines, and completion rewards. Swipe gestures make goal management intuitive—swipe right to complete a goal and earn points, swipe left to delete.

All data syncs in real-time through Firebase Firestore, ensuring users can access their environmental journey across devices. The points system gamifies sustainability: users earn 100 points for planting trees, 200 for completing goals, and 50 for maintaining below-average carbon footprints. This gamification creates positive reinforcement loops that encourage continued engagement.

**Impact:**

By making environmental action measurable, achievable, and rewarding, EcoTrack transforms abstract climate concerns into concrete personal achievements. Users don't just feel good about helping the environment—they can see exactly how much CO₂ they've offset, how many trees they've planted, and how their habits have evolved over time. This data-driven approach to sustainability empowers individuals to make informed decisions and maintain long-term commitment to environmental stewardship.

---

## 🔗 Links

**GitHub Repository:** [Coming Soon - Will be published]

**Live Demo:** [Coming Soon - Deployment in progress]

**Project Location:** `c:\Users\victor\Desktop\aethra`

---

## 👥 Team Information

**Team Type:** Solo Developer

**Developer:**
- **Name:** Victor
- **Role:** Full-Stack Developer
- **Responsibilities:** 
  - Application architecture and design
  - Frontend development (Flutter)
  - Backend integration (Firebase)
  - UI/UX design
  - Data modeling and state management
  - Testing and deployment

**Development Timeline:** November 2024 - Present

---

## 🛠️ Tech Stack

### **Frontend Framework**
- **Flutter 3.0+** - Cross-platform UI framework for building natively compiled applications
- **Dart** - Programming language optimized for building mobile, desktop, and web applications

### **State Management**
- **Provider 6.1.1** - Lightweight state management solution for Flutter applications
- **ChangeNotifier** - Built-in Flutter class for observable state changes

### **Backend & Database**
- **Firebase Core 4.2.1** - Firebase SDK for Flutter
- **Cloud Firestore 6.1.0** - NoSQL cloud database for real-time data synchronization
- **Firebase Authentication 6.1.2** - User authentication and authorization
- **Firebase Storage 13.0.4** - Cloud storage for user-generated content (avatars, images)
- **Firebase Messaging 16.0.4** - Push notifications for user engagement

### **UI & Design**
- **Google Fonts 6.1.0** - Custom typography (Outfit, Inter)
- **Flutter Animate 4.5.0** - Declarative animations and transitions
- **Material Design 3** - Modern design system with glassmorphism effects
- **Custom Theme System** - Centralized theming with vibrant gradients and dark mode

### **Data Visualization**
- **FL Chart 1.1.1** - Beautiful, animated charts for progress tracking
- **Custom Progress Indicators** - Linear and circular progress visualizations

### **Location & Permissions**
- **Geolocator 14.0.2** - GPS location services for regional customization
- **Permission Handler 12.0.1** - Runtime permission management

### **Media & Assets**
- **Image Picker 1.0.4** - Camera and gallery access for profile pictures
- **Cached Network Image 3.3.0** - Efficient image loading and caching
- **Lottie 3.3.2** - Vector animations for enhanced UX

### **Utilities**
- **HTTP 1.1.0** - RESTful API communication
- **Intl 0.20.2** - Internationalization and date formatting
- **Path Provider 2.1.1** - File system path access
- **JSON Annotation 4.8.1** - JSON serialization support

### **Development Tools**
- **Flutter Lints 6.0.0** - Recommended linting rules for Flutter
- **Build Runner 2.4.7** - Code generation tool
- **JSON Serializable 6.7.1** - Automatic JSON serialization code generation

### **Architecture & Patterns**
- **MVVM (Model-View-ViewModel)** - Separation of concerns architecture
- **Repository Pattern** - Abstracted data layer with FirestoreService
- **Factory Pattern** - Model creation with factory constructors
- **Stream-based Real-time Updates** - Reactive data flow with Firestore streams

### **Data Models**
- **Goal Model** - Sustainability goal tracking with progress calculation
- **Activity Model** - User action logging with relative timestamps
- **CarbonCalculation Model** - Detailed carbon footprint breakdown

### **Platform Support**
- **Web** - Progressive Web App (PWA) compatible
- **Windows** - Desktop application support
- **Android** - Native mobile app (planned)
- **iOS** - Native mobile app (planned)

### **Development Environment**
- **IDE:** Visual Studio Code / Android Studio
- **Version Control:** Git
- **Package Manager:** pub (Dart package manager)
- **Build System:** Flutter build tools

### **Key Technical Decisions**

1. **Firebase over Custom Backend**: Chose Firebase for rapid development, built-in authentication, real-time sync, and automatic scaling without server management.

2. **Provider over Riverpod/Bloc**: Selected Provider for its simplicity, excellent Flutter integration, and sufficient complexity handling for this application's needs.

3. **Firestore over SQL**: NoSQL database chosen for flexible schema evolution, real-time listeners, offline support, and seamless Firebase ecosystem integration.

4. **Flutter over React Native**: Flutter selected for superior performance, beautiful Material Design implementation, single codebase for all platforms, and excellent developer experience.

5. **Glassmorphism Design**: Modern UI aesthetic with frosted glass effects creates premium feel while maintaining readability and accessibility.

---

## 📊 Project Statistics

- **Total Files:** 50+ Dart files
- **Lines of Code:** ~5,000+ lines
- **Models:** 3 (Goal, Activity, CarbonCalculation)
- **Screens:** 11 (Onboarding, Welcome, Login, Registration, Dashboard, Profile, Goals, Progress, Tips, Calculator, Permissions)
- **Services:** 1 (FirestoreService)
- **Providers:** 1 (UserDataProvider)
- **Dependencies:** 25+ packages

---

## 🎯 Future Enhancements

- Social features for sharing achievements
- Community challenges and leaderboards
- Integration with smart home devices for automatic energy tracking
- Machine learning for personalized sustainability recommendations
- Carbon offset marketplace integration
- Multi-language support
- iOS and Android native releases
- Wearable device integration

---

**Built with ❤️ for the planet 🌍**
