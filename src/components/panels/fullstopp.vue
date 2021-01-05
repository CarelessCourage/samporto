<template>
  <div id="fullstopp" ref="panel">
    <div class="container">
      <h2 class="source" @click="distSubStyle(0)">
        sourceissource.com {{ panel.subTargets[1].position }}
      </h2>
      <div class="content">
        <p
          v-for="(par, index) in panel.subTargets"
          :key="index"
          id="subPanel"
          :style="
            'opacity:' + distSubStyle(index) * 0.01 + ';' + borderNone(index)
          "
        >
          {{ panel.content }}
        </p>
      </div>
    </div>
  </div>
</template>


<script>
export default {
  name: "fullstopp",
  props: ["pPosition", "panel"],
  methods: {
    borderNone: function (index) {
      let dist = this.distSubStyle(index);
      let result = "";
      if (dist < 50) {
        result = "border-left: none; border-right: none;";
      }
      return result;
    },
    distSubStyle: function (index) {
      let result = 0;

      let pos = Math.abs(this.panel.subTargets[index].position);
      let scroll = Math.abs(this.pPosition);
      let diff = Math.abs(pos - scroll);
      let dist = 100 - diff;

      if (dist < 0) {
        result = 0;
      } else {
        result = dist;
      }

      return result;
      //:style="'opacity:' + distSubStyle(index) * 0.01 + ';'"
    },
    percentage: function (partialValue, totalValue) {
      return (100 * partialValue) / totalValue;
    },
  },
  mounted() {
    let panelPositions = [];
    let pWidth = this.$refs.panel.offsetWidth;
    let spWidth = document.querySelector("#subPanel").offsetWidth;
    var w = window.innerWidth;
    let pPercentage = this.percentage(pWidth, w);
    let spPercentage = this.percentage(spWidth, w);

    panelPositions.push({ name: "panel", width: pPercentage });
    panelPositions.push({ name: "subPanel", width: spPercentage });

    //console.log("subPael Width: ", spPercentage);

    this.$emit("mounted", panelPositions);
  },
};
</script>

<style lang="scss">
#fullstopp {
  --border: 3px;
  --subPanelWidth: 60vw;
  //background: blue;
  padding: 20vw;
  padding-top: 10vh;
  //width: 200vw;
  .container {
    //background: blue;
    position: relative;
  }
  .source {
    margin: 0px;
    left: calc(50vw - (var(--subPanelWidth) / 2));
    position: sticky;
    //background: red;
    width: var(--subPanelWidth);
    padding: 2em;
    padding-top: 1em;
    padding-bottom: 1em;
    box-sizing: border-box;
    text-align: left;
    border: var(--border) solid rgb(0, 0, 0);
    //margin-left: calc(var(--border) * -1);
  }
  .content {
    display: flex;
    justify-content: center;
    align-items: center;

    p {
      margin: 0px;
      margin-top: calc(var(--border) * -1);
      //margin-left: calc(var(--border) * -1);
      //background: pink;
      //column-count: 2;
      //column-width: 8rem;
      font-size: 1.5em;
      width: var(--subPanelWidth);
      text-align: left;
      border: var(--border) solid rgb(0, 0, 0);
      transition: border 0.8s;
      padding: 5em;
      box-sizing: border-box;
    }
  }
}
</style>
