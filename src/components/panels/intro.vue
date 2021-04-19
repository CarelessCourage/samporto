<template>
  <div id="intro" ref="panel">
    <div class="header">
      <div class="patch">
        <h1 :style="'left: ' + -pPosition + 'vw;'">
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
    initPanel: function () {
      let panelPositions = [];
      let pWidth = this.$refs.panel.offsetWidth;
      var w = window.innerWidth;
      let pPercentage = this.percentage(pWidth, w);

      panelPositions.push({ name: "panel", width: pPercentage });

      this.$emit("mounted", panelPositions);
    },
  },
  mounted() {
    this.initPanel();
    window.addEventListener("resize", () =>
      setTimeout(() => this.initPanel(), 1000)
    );
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
    //border-left: var(--border) solid $fg;

    .patch {
      border-right: var(--border) solid $fg;
      //border-left: var(--border) solid $fg;
      border-top: var(--border) solid $fg;
      background-color: $bg;
      width: calc(100% + var(--border) + var(--border));
      margin-left: calc(var(--border) * -1);
      position: relative;
      height: 90vh;
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

@media only screen and (max-width: 600px) {
  #intro {
    grid-template-columns: 1fr;
    grid-template-rows: 1fr 1fr;
    .header .patch {
      height: auto;
    }
    .content {
      position: relative;
      z-index: 20;
      background: $bg;
      border-right: var(--border) solid $fg;
    }
  }
}
</style>
