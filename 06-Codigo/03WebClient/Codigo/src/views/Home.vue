<template>
    <div class="py-8">
      <div class="">
        <div class="flex justify-center">
          <SearchForm @search="performSearch" />
        </div>
        <div class="mt-4 flex justify-center" v-if="isLoading">Cargando información...</div>
        <div v-else>
          <div class="flex justify-center" v-if="articles.length === 0 && !isLoading">
            <p>No hay información para mostrar...</p>
          </div>
          <div v-else>
            <div class="results-container">
              <table class="table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Journal</th>
                    <th>ISSN</th>
                    <th>Publication Date</th>
                    <th>Article Type</th>
                    <th>Author</th>
                    <th>Score</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="article in articles" :key="article.id">
                    <td>{{ article.id }}</td>
                    <td>
                      <a class="text-title" :href="getArticleURL(article.id)" target="_blank">{{ article.title_display }}</a>
                    </td>
                    <td>{{ article.journal }}</td>
                    <td>{{ article.eissn }}</td>
                    <td>{{ article.publication_date }}</td>
                    <td>{{ article.article_type }}</td>
                    <td>{{ truncateAuthors(article.author_display) }}</td>
                    <td>{{ article.score }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <style>
  .results-container {
    padding: 20px;
  }
  
  .table {
    width: 100%;
    border-collapse: collapse;
  }
  
  .table th,
  .table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }
  
  .table th {
    background-color: #f2f2f2;
  }

  .text-title {
    color: #8ab4f8 !important;
  }
  </style>
  
  
  <style>
  .results-container {
    padding: 20px;
  }
  </style>
  
  
  <script>
  import SearchForm from "@/components/SearchForm.vue";
  
  export default {
    name: "HomeView",
    components: {
      SearchForm
    },
    data() {
      return {
        articles: [],
        isLoading: false
      };
    },
    methods: {
        performSearch(searchTerm) {
    this.isLoading = true;
    this.articles = [];

    const url = `https://api.plos.org/search?q=title:${encodeURIComponent(
      searchTerm
    )}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        // Eliminar el primer elemento del array de resultados
        if (Array.isArray(data)) {
          data.shift();
        }

        this.articles = data.response.docs;
        this.isLoading = false;
      })
      .catch(error => {
        console.error("Error fetching articles:", error);
        this.isLoading = false;
      });
  },
      getArticleURL(articleId) {
        return `https://journals.plos.org/plosone/article?id=${encodeURIComponent(articleId)}`;
      },
      truncateAuthors(authors) {
      const maxLength = 10; // Maximum length for the authors
      let truncatedAuthors = authors.slice(0, maxLength);

      if (authors.length > maxLength) {
        truncatedAuthors.push("..."); // Add ellipsis if there are more authors
      }

      return truncatedAuthors.join(", ");
    }


    }
  };
  </script>
  