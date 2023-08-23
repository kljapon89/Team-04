<template>
    <div class="container">
      <div class="information-container">
        <h1 class="text-center"><strong>Información de la solicitud</strong></h1>
        <div v-if="isLoading" class="spinner"></div>
        <div v-else>
          <ul>
            <li><strong>Archivos aceptados:</strong> {{ filesAccepted }}</li>
            <li><strong>Idioma:</strong> {{ language }}</li>
            <li><strong>Host remoto:</strong> {{ remoteHost }}</li>
            <li><strong>Dirección IP:</strong> {{ ipAddress }}</li>
            <li><strong>Nombre del navegador:</strong> {{ browserName }}</li>
            <li><strong>Sistema operativo:</strong> {{ operatingSystem }}</li>
          </ul>
          <div class="text-center">
            <button class="btn" @click="goToHomePage">Volver al inicio</button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "InformationView",
    data() {
      return {
        filesAccepted: "",
        language: "",
        remoteHost: "",
        ipAddress: "",
        browserName: "",
        operatingSystem: "",
        isLoading: true
      };
    },
    created() {
      this.fetchInformation();
    },
    methods: {
      fetchInformation() {
        fetch("https://httpbin.org/get")
          .then(response => response.json())
          .then(data => {
            const headers = data.headers;
            this.filesAccepted = headers["Accept"];
            this.language = headers["Accept-Language"];
            this.remoteHost = headers["Host"];
            this.ipAddress = data.origin;
            this.browserName = headers["User-Agent"].split(") ")[0] + ")";
            this.operatingSystem = headers["Sec-Ch-Ua-Platform"];
            this.isLoading = false;
          })
          .catch(error => {
            console.error("Error al obtener la información de la solicitud:", error);
            this.isLoading = false;
          });
      },
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
  
  .information-container {
    max-width: 600px;
    padding: 20px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
  }
  
  li {
    margin-bottom: 10px;
  }
  
  strong {
    font-weight: bold;
  }
  
  .spinner {
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
    margin: 20px auto;
  }
  
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  
  .btn {
    background-color: #3498db;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
  }
  
  .btn:hover {
    background-color: #2176bd;
  }
  </style>
  