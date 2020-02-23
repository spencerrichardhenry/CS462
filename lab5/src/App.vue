<template>
<div id="app">
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <a class="navbar-brand">Temp Store</a>
    </nav>
    <div class="content">
      <router-view />
    </div>
  </body>
</div>
</template>

<style>
p {
  font-size: 1em;
  text-align: center;
}

h3 {
  margin-top: 5%;
  margin-left: 10%;
  font-size: 1.3em;
  line-height: 5vw;
}

.navbar-brand {
  font-size: 30px;
  color: #fff !important;
}

body {
  font-family: sans-serif;
  font-size: 3vw;
  color: #393e46;
}

.container p {
  font-size: 0.8em;
  text-decoration: none;
  color: #393e46;
  text-align: center;
  margin: 0;
}

hr {
  margin-top: 0;
}

.home {
  margin-left: auto;
  margin-right: auto;
  display: table;
}

input {
  display: block;
  margin: auto;
}

body {
  text-align: center;
  margin: auto;
}

.popularity {
  text-align: center;
}

h3 {
  margin: 0;
  text-align: center;
}

img {
  display: block;
  margin: auto;
}
</style>
