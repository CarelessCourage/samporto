<template>
  <div id="images" ref="panel">
    <div class="images">
      <img
        src="@/assets/Fleur.png"
        alt=""
        class="main"
        :style="'left: ' + normalizePosition(0, 5, 0) + 'em;'"
      />
      <img
        src="@/assets/lonley2.jpg"
        alt=""
        class="subOne"
        :style="'left: ' + normalizePosition(25, 3, 0) + 'vw;'"
      />
      <img
        src="@/assets/coffee.png"
        alt=""
        class="subTwo"
        :style="'left: ' + normalizePosition(43, -9, 1.005) + 'vw;'"
      />
    </div>
    <div
      class="container1"
      v-if="!clean"
      :style="'left: ' + normalizePosition(10, 0, 0) + 'vw;'"
    >
      <div class="text">
        <p>{{ panel.content }}</p>
      </div>
      <div class="entry"><h2>Title 1</h2></div>
      <div class="entry"><h2>Title 2</h2></div>
      <div class="entry"><h2>Title 3</h2></div>
    </div>

    <div
      class="container2"
      v-if="clean"
      :style="'left: ' + normalizePosition(10, 0, 0) + 'vw;'"
    >
      <p>{{ panel.content }}</p>
    </div>
  </div>
</template>


<script>
export default {
  name: "intro",
  props: ["pPosition", "panel"],
  data() {
    return {
      clean: true,
    };
  },
  methods: {
    normalizePosition: function (pos, div, mul) {
      //setup
      let scroll = this.pPosition;
      let position = this.panel.position;

      //normalize position
      let diffDiv = scroll + position;
      let diffMul = diffDiv;

      //Add user input, divide and multiply
      diffDiv = diffDiv / div;
      diffMul = diffMul * mul;

      //result
      return diffDiv + diffMul + pos;
    },
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
    initPanel: function () {
      let panelPositions = [];
      let pWidth = 900;
      let w = pWidth;

      window.onload = function () {
        w = window.innerWidth;
        pWidth = this.$refs.panel.offsetWidth;
      };

      let pPercentage = this.percentage(pWidth, w);

      panelPositions.push({ name: "panel", width: pPercentage });

      this.$emit("mounted", panelPositions);
    },
  },
  mounted() {
    this.initPanel();
  },
};
</script>

<style lang="scss">
@use '@/css' as *;

.container2 {
  top: 3em;
  background-color: $bg;
  max-width: 45em;
  position: absolute;
  z-index: 0;
  right: 10vw;
  text-align: left;
  padding: 4em;
  box-sizing: border-box;
}

.container1 {
  top: -5em;
  display: grid;
  grid-template-rows: auto 1fr 1fr 1fr;
  background-color: $bg;
  max-width: 45em;
  position: absolute;
  z-index: 4;
  right: 10vw;
  text-align: left;
  border: var(--border) solid $fg;
  border-bottom: none;
}

.entry {
  border-top: var(--border) solid $fg;
  border-bottom: var(--border) solid $fg;
  padding: 4em;
  padding-top: 1em;
  padding-bottom: 1em;
  box-sizing: border-box;
  &:nth-of-type(odd) {
    border: none;
  }
}

.text {
  padding: 4em;
  box-sizing: border-box;
}

.images {
  width: 100%;
  height: 100%;
  overflow: hidden;
}

#images {
  --border: 3px;
  width: 100vw;
  position: relative;
  height: calc(100vh - 15vh);
}

img {
  float: left;
  object-fit: cover;
  max-height: 10em;
  width: 10em;
  position: relative;
  max-height: calc(100vh - 15vh);
  z-index: 5;
}

img.main {
  width: 40em;
  top: calc(var(--border) * 2);
}

img.subOne {
  width: 25em;
  position: absolute;
  left: 25vw;
  top: calc(var(--border) * 2);
}

img.subTwo {
  width: 30em;
  height: 18em;
  position: absolute;
  left: 42vw;
  bottom: 0em;
  z-index: 4;
}
</style>
