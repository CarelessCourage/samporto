<template>
  <div id="intro" ref="panel">
    <div class="header">
      <div class="patch">
        <h1 :style="'left: ' + normalizePosition(5, 1) + 'vw;'">
          {{ panel.title }}
        </h1>
      </div>
    </div>
    <div class="content">
      <p>{{ panel.content }}</p>
    </div>
  </div>
</template>


<script>
export default {
  name: "intro",
  props: ["pPosition", "panel"],
  methods: {
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
    normalizePosition: function (pos, mul) {
      //setup
      let scroll = Math.abs(this.pPosition);
      let position = Math.abs(this.panel.position);
      let res = scroll - position;

      //Add user input, divide and multiply
      let diffMul = res * mul;

      //result
      return diffMul + pos;
    },
  },
  mounted() {
    let panelPositions = [];
    let pWidth = this.$refs.panel.offsetWidth;
    var w = window.innerWidth;
    let pPercentage = this.percentage(pWidth, w);

    panelPositions.push({ name: "panel", width: pPercentage });

    this.$emit("mounted", panelPositions);
  },
};
</script>

<style lang="scss">
@use '@/css' as *;

h1 {
  position: absolute;
  left: 0.5em;
}

#intro {
  width: 100vw;
  --border: 3px;
  position: relative;
  transition: 0.4s;
  display: grid;
  grid-template-columns: 1fr 1fr;

  .header {
    border-right: var(--border) solid $fg;
    border-left: var(--border) solid $fg;

    .patch {
      border-right: var(--border) solid $fg;
      border-left: var(--border) solid $fg;
      border-top: var(--border) solid $fg;
      background-color: $bg;
      width: calc(100% + var(--border) + var(--border));
      margin-left: calc(var(--border) * -1);
      height: 90vh;
      position: relative;
      top: -15vh;
      display: flex;
      justify-content: center;
      padding: 5em;
      padding-top: 10em;
      box-sizing: border-box;
      overflow: hidden;
      pointer-events: none;
    }
  }

  .content {
    display: flex;
    justify-content: center;
    align-items: center;
    p {
      text-align: left;
      width: 60%;
    }
  }
}
</style>
