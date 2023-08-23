<template>
    <div class="container">
      <div class="not-found-container">
        <h1 class="not-found-title">404</h1>
        <p class="not-found-text">Oops! La página que buscas no se encontró.</p>
        <button class="not-found-button" @click="goToHomePage">Volver al inicio</button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "NotFoundView",
    methods: {
      goToHomePage() {
        this.$router.push("/");
      }
    }
  };
  </script>
  
  <style>
  .container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #f5f5f5;
  }
  
  .not-found-container {
    text-align: center;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    padding: 40px;
  }
  
  .not-found-title {
    font-size: 72px;
    color: #e74c3c;
    margin-bottom: 20px;
  }
  
  .not-found-text {
    font-size: 24px;
    color: #333333;
    margin-bottom: 40px;
  }
  
  .not-found-button {
    background-color: #3498db;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 18px;
  }
  
  .not-found-button:hover {
    background-color: #2176bd;
  }
  </style>
  