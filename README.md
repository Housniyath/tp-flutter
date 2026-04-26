# 📱 Habit Tracker App

Application Flutter de suivi d’habitudes avec synchronisation en temps réel.

---

## 🎯 Objectif

Permettre à un utilisateur de :

* créer des habitudes
* suivre leur réalisation quotidienne
* consulter un historique
* synchroniser ses données entre plusieurs appareils

---

## 🚀 Technologies utilisées

* Flutter
* Firebase (Authentication + Firestore)
* Git & GitHub

---

## 👥 Membres du groupe

* Responsable : [ADJIBADE Housniyath]
* Membre 1 : Authentification
* Membre 2 : Gestion des habitudes
* Membre 3 : Suivi quotidien
* Membre 4 : Historique
* Membre 5 :Design & Navigation


---

## 🧱 Architecture du projet

```plaintext
lib/
 ├── core/
 │    ├── services/
 │    ├── utils/
 │    └── constants/
 │
 ├── features/
 │    ├── auth/
 │    ├── habits/
 │    └── tracking/
 │
 ├── widgets/
 ├── routes/
 └── main.dart
```

---

## ⚙️ Installation du projet

```bash
git clone https://github.com/ton-username/habit_tracker.git
cd habit_tracker
flutter pub get
flutter run
```

---

## 🌐 Fonctionnalités

### 🔐 Authentification

* Inscription
* Connexion

### 📝 Gestion des habitudes

* Ajouter une habitude
* Supprimer une habitude
* Voir la liste

### 📅 Suivi quotidien

* Marquer une habitude comme réalisée
* Une seule validation par jour
* Historique des jours cochés

---

## 🔄 Synchronisation

Les données sont synchronisées en temps réel via Firebase.

---

## 📌 Règles de collaboration

### 🔹 Branches

* Ne jamais travailler directement sur `main`
* Créer une branche :

```bash
git checkout -b feature/nom-feature
```

---



## ⚠️ Contraintes techniques

* Données stockées côté backend uniquement
* Synchronisation temps réel obligatoire
* Une habitude validée une seule fois par jour
* Gestion des dates en UTC

---

## 📌 Remarques

Chaque membre doit respecter l’architecture du projet pour éviter les conflits et garantir la cohérence du code.
