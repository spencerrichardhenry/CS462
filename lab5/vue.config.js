module.exports = {
  devServer: {
    proxy: {
      "^/sky": {
        target: "http://localhost:8080"
      }
    },
    port: 3030
  }
};
