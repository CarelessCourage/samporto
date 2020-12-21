<template>
  <div id="app">
    <threeScene />
  </div>
</template>


<script>
import threeScene from "./components/threeScene.vue";

export default {
  name: "App",
  components: {
    threeScene,
  },
  methods: {
    scrollMove: function () {
      let scroll = -this.position * 100;
      return "transform: translateY(" + scroll + "px)";
    },
    scrollScale: function (index) {
      let pos = this.position;

      let iteration = index * 100;
      let space = iteration + 100;
      let top = "top: " + space + "px;";

      let dist = Math.min(Math.abs(pos - index), 1);
      dist = 1 - dist ** 2;
      let final = 1 + 0.4 * dist;

      let scale = "transform: scale(" + final + ");";

      return top + scale;
    },
  },
};
</script>

<style lang="scss">
html {
  max-width: 100vw;
  overflow-x: hidden;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  //height: 100vh;
  max-width: 100vw;
  overflow-x: hidden;
}
body {
  margin: 0px;
}
</style>
