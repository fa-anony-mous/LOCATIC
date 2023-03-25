const functions = require("firebase-functions");

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCP8-O7WlzTXZ552lA3GAHTO-ZmpCrVGHI",
  authDomain: "locatic-3d072.firebaseapp.com",
  projectId: "locatic-3d072",
  storageBucket: "locatic-3d072.appspot.com",
  messagingSenderId: "723781297499",
  appId: "1:723781297499:web:e0ef99e0aa4389cfd7a67e",
  measurementId: "G-1ML72R83JQ"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
