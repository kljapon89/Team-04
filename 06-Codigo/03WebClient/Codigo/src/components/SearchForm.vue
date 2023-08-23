<template>
    <nav class="navbar">
      <div class="navbar-container">
        <h1 class="navbar-title">Buscador</h1>
        <form class="search-form" @submit.prevent="search">
          <input class="search-input" v-model="searchTerm" type="text" placeholder="Buscar..." />
          <button class="search-button" type="submit">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <path
                d="M21.707 20.293l-4.413-4.414c1.31-1.595 2.106-3.618 2.106-5.879 0-4.962-4.038-9-9-9s-9 4.038-9 9 4.038 9 9 9c2.261 0 4.284-.796 5.879-2.106l4.414 4.413c.391.39 1.023.39 1.414 0 .391-.39.391-1.023 0-1.414zM5 10c0-3.859 3.141-7 7-7s7 3.141 7 7-3.141 7-7 7-7-3.141-7-7z"
              />
            </svg>
          </button>
        </form>
      </div>
    </nav>
  </template>
 
  
  <script>
  export default {
    data() {
      return {
        searchTerm: "",
        isLoading: false,
        articles: []
      };
    },
    methods: {
      search() {
        this.isLoading = true;
        // Simulación de búsqueda con un retardo de 2 segundos
        setTimeout(() => {
          this.isLoading = false;
          this.$emit("search", this.searchTerm);
  
          // Desplazarse hacia la parte superior después de la búsqueda
          window.scrollTo({
            top: 0,
            behavior: "smooth"
          });
        }, 2000);
      },
      getArticleURL(articleId) {
        return `https://journals.plos.org/plosone/article?id=${encodeURIComponent(articleId)}`;
      }
    }
  };
  </script>
   <style>
   .navbar {
     padding: 20px;
   }
   
   .navbar-container {
     display: flex;
     align-items: center;
     justify-content: center;
   }
   
   .navbar-title {
     font-size: 24px;
     font-weight: bold;
     color: #555;
     margin-right: 20px;
   }
   
   .search-form {
     display: flex;
     align-items: center;
   }
   
   .search-input {
     margin-right: 10px;
     padding: 8px 12px;
     border: 1px solid #ddd;
     border-radius: 20px;
     font-size: 16px;
     outline: none;
   }
   
   .search-button {
     display: flex;
     align-items: center;
     justify-content: center;
     padding: 8px;
     background-color: #fff;
     border: none;
     border-radius: 50%;
     cursor: pointer;
     box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
   }
   
   .search-button svg {
     width: 20px;
     height: 20px;
     fill: #555;
   }
   </style>